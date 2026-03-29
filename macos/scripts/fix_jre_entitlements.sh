#!/bin/bash
# Fix JRE entitlements after flutter_gemma's setup_desktop.sh signs them
# with sandbox-inherit entitlements.
#
# When the app's sandbox is DISABLED, the JRE must NOT have sandbox-inherit
# entitlements — otherwise macOS rejects the child process launch.
#
# This script reads the active entitlements file, checks if sandbox is off,
# and re-signs all JRE Mach-O binaries without entitlements.

set -e

# Determine which entitlements file to check
ENTITLEMENTS_FILE="${SRCROOT}/Runner/DebugProfile.entitlements"
if [ "${CONFIGURATION}" = "Release" ]; then
  ENTITLEMENTS_FILE="${SRCROOT}/Runner/Release.entitlements"
fi

if [ ! -f "$ENTITLEMENTS_FILE" ]; then
  echo "[fix-jre] Entitlements file not found: $ENTITLEMENTS_FILE"
  exit 0
fi

# Check if sandbox is enabled
SANDBOX_ENABLED=$(/usr/libexec/PlistBuddy -c "Print :com.apple.security.app-sandbox" "$ENTITLEMENTS_FILE" 2>/dev/null || echo "false")

if [ "$SANDBOX_ENABLED" != "false" ]; then
  echo "[fix-jre] Sandbox is ON — JRE sandbox-inherit entitlements are correct, nothing to do."
  exit 0
fi

echo "[fix-jre] Sandbox is OFF — re-signing JRE binaries without sandbox entitlements..."

APP_BUNDLE="${BUILT_PRODUCTS_DIR}/${PRODUCT_NAME}.app"
JRE_DIR="$APP_BUNDLE/Contents/Resources/jre"

if [ ! -d "$JRE_DIR" ]; then
  echo "[fix-jre] No JRE directory found at $JRE_DIR — skipping."
  exit 0
fi

# Remove the sandbox entitlements file created by setup_desktop.sh
JAVA_ENTITLEMENTS="$APP_BUNDLE/Contents/Resources/java.entitlements"
if [ -f "$JAVA_ENTITLEMENTS" ]; then
  echo "[fix-jre] Removing java.entitlements"
  rm -f "$JAVA_ENTITLEMENTS"
fi

# Determine signing identity and flags based on build configuration.
# For Release (distribution): use Developer ID + hardened runtime.
# For Debug/Profile: use ad-hoc signing without hardened runtime.
if [ "${CONFIGURATION}" = "Release" ]; then
  # Use Xcode's signing identity if available
  if [ -n "${EXPANDED_CODE_SIGN_IDENTITY}" ] && [ "${EXPANDED_CODE_SIGN_IDENTITY}" != "-" ]; then
    SIGN_IDENTITY="${EXPANDED_CODE_SIGN_IDENTITY}"
  else
    # Try to find a Developer ID Application certificate
    FOUND_IDENTITY=$(security find-identity -v -p codesigning 2>/dev/null | grep "Developer ID Application" | head -1 | sed 's/.*"\(.*\)"/\1/')
    if [ -n "$FOUND_IDENTITY" ]; then
      SIGN_IDENTITY="$FOUND_IDENTITY"
    else
      # No Developer ID found — fall back to ad-hoc with hardened runtime
      SIGN_IDENTITY="-"
    fi
  fi
  echo "[fix-jre] Release signing identity: $SIGN_IDENTITY"
else
  SIGN_IDENTITY="-"
fi

if [ "${CONFIGURATION}" = "Release" ]; then
  RUNTIME_FLAG="--options runtime"
  JRE_ENTITLEMENTS="${SRCROOT}/scripts/jre.entitlements"
  ENTITLEMENTS_FLAG="--entitlements ${JRE_ENTITLEMENTS}"
else
  RUNTIME_FLAG=""
  ENTITLEMENTS_FLAG=""
fi

echo "[fix-jre] Configuration: ${CONFIGURATION}, Identity: ${SIGN_IDENTITY}"

# Re-sign all dylibs (dylibs don't need entitlements)
find "$JRE_DIR" -type f -name "*.dylib" | while read -r file; do
  codesign --force --sign "${SIGN_IDENTITY}" $RUNTIME_FLAG "$file" 2>/dev/null || true
done
echo "[fix-jre] Dylibs re-signed."

# Re-sign all Mach-O executables with JRE entitlements (JIT, unsigned memory, etc.)
find "$JRE_DIR/bin" -type f -perm +111 | while read -r file; do
  if file "$file" | grep -q "Mach-O"; then
    echo "[fix-jre] Re-signing: $(basename "$file")"
    codesign --force --sign "${SIGN_IDENTITY}" $RUNTIME_FLAG $ENTITLEMENTS_FLAG "$file"
  fi
done

# Also handle the case where bin/java is a symlink to the real binary
# (e.g., zulu-24.jre/Contents/Home/bin/java)
find "$JRE_DIR" -type f -name "java" | while read -r file; do
  if file "$file" | grep -q "Mach-O"; then
    echo "[fix-jre] Re-signing resolved java: $file"
    codesign --force --sign "${SIGN_IDENTITY}" $RUNTIME_FLAG $ENTITLEMENTS_FLAG "$file"
  fi
done

# Sign native libraries inside JAR files (jnilib, so, dylib embedded in JARs)
if [ "${CONFIGURATION}" = "Release" ]; then
  echo "[fix-jre] Signing native libraries inside JAR files..."
  RESOURCES_DIR="$APP_BUNDLE/Contents/Resources"

  find "$RESOURCES_DIR" -name "*.jar" | while read -r jar; do
    TEMP_DIR=$(mktemp -d)
    JAR_MODIFIED=false

    # List native libraries in the JAR
    NATIVES=$(unzip -l "$jar" 2>/dev/null | grep -E '\.(jnilib|so|dylib)$' | awk '{print $4}' || true)

    if [ -n "$NATIVES" ]; then
      echo "[fix-jre] Processing JAR: $(basename "$jar")"

      for native in $NATIVES; do
        # Extract the native library
        unzip -o -j "$jar" "$native" -d "$TEMP_DIR" 2>/dev/null || continue
        NATIVE_FILE="$TEMP_DIR/$(basename "$native")"

        if [ -f "$NATIVE_FILE" ] && file "$NATIVE_FILE" | grep -q "Mach-O"; then
          echo "[fix-jre] Signing: $native"
          codesign --force --sign "${SIGN_IDENTITY}" --options runtime --timestamp "$NATIVE_FILE"

          # Update the JAR with the signed native
          # Need to preserve the path inside the JAR
          NATIVE_DIR=$(dirname "$native")
          mkdir -p "$TEMP_DIR/repack/$NATIVE_DIR"
          cp "$NATIVE_FILE" "$TEMP_DIR/repack/$NATIVE_DIR/"
          JAR_MODIFIED=true
        fi
      done

      if [ "$JAR_MODIFIED" = true ]; then
        # Update JAR with signed natives
        cd "$TEMP_DIR/repack"
        zip -u "$jar" $NATIVES 2>/dev/null || true
        cd - > /dev/null
      fi
    fi

    rm -rf "$TEMP_DIR"
  done
  echo "[fix-jre] JAR native libraries signed."
fi

echo "[fix-jre] Done — JRE binaries signed without sandbox entitlements."
