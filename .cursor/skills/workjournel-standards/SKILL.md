---
name: workjournel-standards
description: Enforce WorkJournel.ai project standards including responsive design (Mobile & Desktop), strict adherence to AppTheme, and MVVM architecture. Use when creating new features, UI components, or refactoring code.
---

# WorkJournel.ai Project Standards

## 1. Responsive Design (sm / md / lg)

### Breakpoint System
Use `AppBreakpoints.fromWidth(width)` to get the `ResponsiveSize` enum:
- **sm** (< 600px): Mobile-only. Design provided for this size.
- **md** (600px - 1024px): Tablet/small desktop. Interpolate between sm and lg.
- **lg** (>= 1024px): Desktop. Design provided for this size.

### Design Principles
- **Designs are provided ONLY for sm (mobile) and lg (desktop)**. For md, interpolate sizing/spacing between sm and lg values.
- **sm is mobile native UI** — should feel like a native mobile app with touch-friendly elements, sticky CTAs, and mobile-first patterns.
- **md and lg use CONSTANT sizing** — never use `Expanded`, `Flexible`, or window-relative sizing (like percentages of screen height) for component dimensions.
- **Content scrolls, never breaks** — if content doesn't fit the viewport, wrap in `SingleChildScrollView`. Never let components overflow or get cut off.

### Implementation Rules
1. Use `LayoutBuilder` to get constraints and determine `ResponsiveSize`.
2. **NEVER** use `Expanded` or `Flexible` for components that should have constant sizes (e.g., hero sections, cards, benefit lists).
3. Use fixed heights/widths for md/lg components. Let the container scroll if needed.
4. For md size, use values between sm and lg (e.g., if sm padding is 20 and lg is 48, md could be 32).
5. Always wrap md/lg layouts in `SingleChildScrollView` to handle small viewports.
6. Use `ConstrainedBox` with `maxWidth` to limit content width on large screens.

### Anti-Patterns to AVOID
```dart
// BAD: Component size depends on window height - breaks on small windows
Expanded(
  child: HeroBento(size: ResponsiveSize.lg),
)

// BAD: AspectRatio makes height depend on available width
AspectRatio(
  aspectRatio: 1.6,
  child: HeroBento(size: ResponsiveSize.md),
)

// GOOD: Fixed height, scrollable container
SingleChildScrollView(
  child: SizedBox(
    height: 600,  // constant height
    child: HeroBento(size: ResponsiveSize.lg),
  ),
)
```

## 2. Strict Theme Adherence
NEVER use hardcoded colors or custom local styles if a theme equivalent exists.
- **Colors**: Use `AppColors` from `lib/theme/app_theme.dart`.
- **Typography**: Use the `AppTextStyles` extension on `TextStyle`.
- **Spacing**: Follow the spacing tokens defined in the design guide (e.g., 2rem for Bento cards).

## 3. MVVM Architecture
Follow the Model-View-ViewModel pattern for all features.
- **Model**: Data structures and business logic.
- **View**: Flutter widgets (UI only).
- **ViewModel**: State management and UI logic.
- **Folder Structure**:
  ```
  lib/
  ├── models/
  ├── viewmodels/
  ├── screens/ (Views)
  ├── widgets/ (Reusable UI components)
  └── services/ (API/Data providers)
  ```

## 4. Widget Standards
### Always Use Widget Classes
- **Never** use functions that return widgets (functional widgets).
- Always create a proper `StatelessWidget` or `StatefulWidget` class.

### Widget File Organization
- **Do not** put all widgets for a screen in a single file. Break them into small, focused files — one widget per file.
- **Screen-specific widgets**: Place them in a folder inside `widgets/` named after the screen.
- **Common/shared widgets**: Place them as files directly inside `widgets/common/`.
- **Folder Structure**:
  ```
  lib/
  └── widgets/
      ├── common/
      │   ├── custom_button.dart
      │   └── loading_indicator.dart
      ├── welcome/
      │   ├── feature_card.dart
      │   └── hero_section.dart
      └── dashboard/
          ├── stats_tile.dart
          └── activity_feed.dart
  ```

## 5. Navigation
- **Always use `go_router`** for all navigation. Do not use `Navigator.push`, `Navigator.pushNamed`, or any other navigation approach.

## 6. Dependency Management
- **STRICT: Always use the terminal** to add packages. Run `flutter pub add <package>` instead of manually editing `pubspec.yaml`. This ensures the latest compatible version is always resolved.

## 7. Code Style & Rules
- Do not add demo/test/example code unless explicitly asked.
- **STRICT: Do NOT add code comments.** No inline comments, no doc comments, no section dividers — unless the user explicitly asks for them.
- Use `.withValues(alpha: ...)` instead of deprecated `.withOpacity()`.

## Checklist for New Features
- [ ] UI is responsive (sm / md / lg breakpoints)
- [ ] sm layout is mobile-native (touch-friendly, sticky CTAs)
- [ ] md/lg layouts use constant sizing (no Expanded/Flexible for content)
- [ ] md/lg layouts scroll when content exceeds viewport
- [ ] All colors/styles use `AppTheme`
- [ ] Logic is separated into a ViewModel
- [ ] Folder structure follows MVVM
- [ ] Widgets are class-based (no functional widgets)
- [ ] Widgets are split into small, focused files
- [ ] Navigation uses `go_router`
- [ ] Dependencies added via `flutter pub add`
- [ ] No deprecated members used
