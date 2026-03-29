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

# Re-sign all dylibs (without entitlements — same as setup_desktop.sh does)
find "$JRE_DIR" -type f -name "*.dylib" | while read -r file; do
  codesign --force --sign - "$file" 2>/dev/null || true
done
echo "[fix-jre] Dylibs re-signed."

# Re-sign all Mach-O executables WITHOUT sandbox entitlements
find "$JRE_DIR/bin" -type f -perm +111 | while read -r file; do
  if file "$file" | grep -q "Mach-O"; then
    echo "[fix-jre] Re-signing: $(basename "$file")"
    codesign --force --sign - "$file"
  fi
done

# Also handle the case where bin/java is a symlink to the real binary
# (e.g., zulu-24.jre/Contents/Home/bin/java)
find "$JRE_DIR" -type f -name "java" | while read -r file; do
  if file "$file" | grep -q "Mach-O"; then
    echo "[fix-jre] Re-signing resolved java: $file"
    codesign --force --sign - "$file"
  fi
done

echo "[fix-jre] Done — JRE binaries signed without sandbox entitlements."
