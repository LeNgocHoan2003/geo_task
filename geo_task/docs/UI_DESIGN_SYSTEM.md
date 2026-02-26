# Geo-Task UI Design System

Modern, minimal, premium mobile UI for the location-based reminder app.

---

## 1. Color Palette

| Role | Hex | Usage |
|------|-----|--------|
| **Primary** | `#0D9488` | Buttons, FAB, links, active states |
| **Primary Light** | `#5EEAD4` | Highlights, secondary accents |
| **Primary Dark** | `#0F766E` | Pressed states |
| **Background** | `#F8FAFC` | Screen background |
| **Surface** | `#FFFFFF` | Cards, inputs, app bar |
| **Text Primary** | `#0F172A` | Headings, primary text |
| **Text Secondary** | `#64748B` | Body, labels |
| **Text Tertiary** | `#94A3B8` | Hints, captions |
| **Border** | `#E2E8F0` | Input borders, dividers |
| **Border Light** | `#F1F5F9` | Card borders |
| **Success** | `#10B981` | Success states |
| **Error** | `#EF4444` | Errors, delete actions |
| **Warning** | `#F59E0B` | Warnings |
| **Enter chip** | bg `#ECFDF5`, fg `#059669` | “Enter” trigger badge |
| **Exit chip** | bg `#FEF3C7`, fg `#D97706` | “Exit” trigger badge |

**Gradients (subtle):**
- Primary: `#0D9488` → `#14B8A6`
- Surface: `#FFFFFF` → `#F8FAFC`

---

## 2. Typography

- **Display Small**: 28px, Bold (700), -0.5 letter spacing  
- **Headline Medium**: 22px, SemiBold (600), -0.3 letter spacing  
- **Title Large**: 18px, SemiBold  
- **Title Medium**: 16px, SemiBold  
- **Title Small**: 14px, SemiBold  
- **Body Large**: 16px, Regular  
- **Body Medium**: 14px, Regular (secondary text)  
- **Body Small**: 12px, Regular (captions)  
- **Label Large**: 14px, Medium (500)  
- **Label Medium**: 12px, Medium  

Use `AppTypography` in `lib/core/theme/app_typography.dart` for consistency.

---

## 3. Spacing System

All spacing uses multiples of 4px.

| Token | Value | Usage |
|-------|--------|--------|
| `xs` | 4px | Tight gaps |
| `sm` | 8px | Inline spacing |
| `md` | 12px | Small padding |
| `lg` | 16px | Default padding |
| `xl` | 20px | Card padding |
| `xxl` | 24px | Section spacing |
| `xxxl` | 32px | Large sections |

**Radii:**
- Card: **18px** (16–20px range)
- Card small: 14px  
- Input / button: 12–14px  
- FAB: 16px  

**Screen padding:** 20px horizontal, 16px vertical.  
**List item gap:** 10px.

---

## 4. Component Breakdown

### Home Screen
- **App bar**: Surface background, no elevation, centered title “Geo-Task”.
- **Reminder card**: 18px radius, soft shadow (`AppShadows.card`), 20px padding. Content: title, location (name or coordinates), Enter/Exit chip, radius, adaptive switch. Actions: Edit, Delete, (debug) Test notification.
- **Empty state**: Centered icon in tinted circle, headline, body text, “Add reminder” primary button.
- **FAB**: Primary color, soft shadow (`AppShadows.fab`), “+” icon.

### Add / Edit Reminder Screen (Detail)
- **Search bar**: Top; rounded field with search icon; placeholder “Search for a place” (ready for place autocomplete).
- **Map preview**: ~220px height, 18px radius; OSM tiles; circle layer for radius (meters); pin marker; tap to set location.
- **Form**: Title (required), Description (optional), Radius slider with value chip, Segmented control (Enter / Exit).
- **Bottom bar**: Fixed; Save primary button; when editing, “Delete reminder” text button above Save.

### Shared Components
- **SegmentedControl** (`core/widgets/segmented_control.dart`): Two segments, animated selection, optional icons.
- **TriggerTypeChip** (`features/reminder/.../widgets/trigger_type_chip.dart`): Pill for Enter/Exit.
- **AppShadows** (`core/theme/app_shadows.dart`): `card`, `cardHover`, `fab`.

---

## 5. Animation Suggestions

- **List items**: Staggered fade/slide on load (e.g. 50–80ms delay per item, 200–300ms duration, `Curves.easeOutCubic`).
- **Cards**: Subtle scale or shadow on tap (e.g. 150ms) for press feedback.
- **Segmented control**: 200ms `AnimatedContainer` with `Curves.easeOutCubic` for segment background.
- **FAB**: Slight scale up on hover/press (e.g. 1.05) and consistent 60fps; avoid heavy layout during animation.
- **Page transitions**: Use GoRouter’s default or custom `CustomTransitionPage` with 300ms fade + slight slide for a premium feel.
- **Slider**: Default Material slider; ensure no jank (avoid rebuilding entire page on drag).
- **Empty state**: Optional light fade-in (200–300ms) when the list becomes empty.

**Performance:** Prefer `const` widgets, avoid unnecessary rebuilds, and keep animations &lt; 300ms for snappy 60fps feel.

---

## 6. File Reference

| Asset | Path |
|-------|------|
| Colors | `lib/core/theme/app_colors.dart` |
| Typography | `lib/core/theme/app_typography.dart` |
| Spacing | `lib/core/theme/app_spacing.dart` |
| Shadows | `lib/core/theme/app_shadows.dart` |
| Theme | `lib/core/theme/app_theme.dart` |
| Segmented control | `lib/core/widgets/segmented_control.dart` |
| Trigger chip | `lib/features/reminder/presentation/widgets/trigger_type_chip.dart` |
