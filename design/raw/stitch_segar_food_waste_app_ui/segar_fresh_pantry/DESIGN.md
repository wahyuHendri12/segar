---
name: Segar Fresh Pantry
colors:
  surface: '#fbf9f4'
  surface-dim: '#dbdad5'
  surface-bright: '#fbf9f4'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#f5f3ee'
  surface-container: '#efeee9'
  surface-container-high: '#eae8e3'
  surface-container-highest: '#e4e2dd'
  on-surface: '#1b1c19'
  on-surface-variant: '#3e4a3f'
  inverse-surface: '#30312d'
  inverse-on-surface: '#f2f1eb'
  outline: '#6e7a6f'
  outline-variant: '#bdcabc'
  surface-tint: '#006d38'
  primary: '#006a36'
  on-primary: '#ffffff'
  primary-container: '#018646'
  on-primary-container: '#f6fff4'
  inverse-primary: '#71dc92'
  secondary: '#855300'
  on-secondary: '#ffffff'
  secondary-container: '#fea619'
  on-secondary-container: '#684000'
  tertiary: '#b1212d'
  on-tertiary: '#ffffff'
  tertiary-container: '#d43c42'
  on-tertiary-container: '#fffbff'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#8df9ac'
  primary-fixed-dim: '#71dc92'
  on-primary-fixed: '#00210d'
  on-primary-fixed-variant: '#005229'
  secondary-fixed: '#ffddb8'
  secondary-fixed-dim: '#ffb95f'
  on-secondary-fixed: '#2a1700'
  on-secondary-fixed-variant: '#653e00'
  tertiary-fixed: '#ffdad8'
  tertiary-fixed-dim: '#ffb3b0'
  on-tertiary-fixed: '#410006'
  on-tertiary-fixed-variant: '#92011a'
  background: '#fbf9f4'
  on-background: '#1b1c19'
  surface-variant: '#e4e2dd'
typography:
  display-lg:
    fontFamily: Plus Jakarta Sans
    fontSize: 32px
    fontWeight: '800'
    lineHeight: 40px
    letterSpacing: -0.02em
  headline-lg:
    fontFamily: Plus Jakarta Sans
    fontSize: 24px
    fontWeight: '700'
    lineHeight: 32px
    letterSpacing: -0.015em
  headline-md:
    fontFamily: Plus Jakarta Sans
    fontSize: 20px
    fontWeight: '700'
    lineHeight: 28px
    letterSpacing: -0.01em
  headline-sm:
    fontFamily: Plus Jakarta Sans
    fontSize: 18px
    fontWeight: '600'
    lineHeight: 24px
    letterSpacing: -0.005em
  body-lg:
    fontFamily: Plus Jakarta Sans
    fontSize: 16px
    fontWeight: '400'
    lineHeight: 24px
  body-md:
    fontFamily: Plus Jakarta Sans
    fontSize: 14px
    fontWeight: '400'
    lineHeight: 20px
  body-sm:
    fontFamily: Plus Jakarta Sans
    fontSize: 12px
    fontWeight: '400'
    lineHeight: 16px
  label-lg:
    fontFamily: Plus Jakarta Sans
    fontSize: 14px
    fontWeight: '600'
    lineHeight: 20px
    letterSpacing: 0.01em
  label-md:
    fontFamily: Plus Jakarta Sans
    fontSize: 12px
    fontWeight: '700'
    lineHeight: 16px
    letterSpacing: 0.02em
  label-sm:
    fontFamily: Plus Jakarta Sans
    fontSize: 11px
    fontWeight: '600'
    lineHeight: 14px
    letterSpacing: 0.02em
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  gutter: 1rem
  margin: 1.25rem
  space-xs: 0.25rem
  space-sm: 0.5rem
  space-md: 0.75rem
  space-lg: 1rem
  space-xl: 1.5rem
---

## Brand & Style

This design system embodies a fresh, encouraging, and approachable companion for daily home cooking, targeted at urban households, frugal budgeters, and boarding-house students (*anak kos*). The aesthetic blends **Modern Tactile Cleanliness** with soft organic warmth. It avoids the sterile coldness of standard inventory enterprise tools in favor of an inviting, domestic atmosphere that removes the guilt from ingredient spoilage and turns proactive food preservation into an easy, rewarding habit.

The emotional tone balances optimism, cleanliness, and pragmatic efficiency. Visuals are grounded in soft, warm daylight tones with generous breathing space, soft-edged component envelopes, cheerful categorization badges, and clear high-visibility freshness statuses.

## Colors

The palette draws inspiration from lively green grocers, sunlit kitchen shelves, and natural agricultural produce.

- **Primary (`#2E9E5B`)**: The signature leafy green used for key action triggers, affirmative states, and safe status badges (*Aman*).
- **Secondary (`#F59E0B`)**: Warm citrus amber signaling impending expiry and caution (*Segera Dipakai*). Used selectively to create urgency without generating panic.
- **Tertiary (`#E5484D`)**: Gentle culinary red signifying spoiled or past-date items (*Sudah Basi*).
- **Neutrals & Surfaces**:
  - Main App Canvas: Soft warm off-white (`#FAFAF7`), keeping screen glare low while remaining cozy.
  - Card & Modal Surfaces: Crisp white (`#FFFFFF`).
  - Subtle Border Strokes: Soft warm grey (`#EAEAE5`).
  - Text Primary: Deep charcoal green-black (`#18231C`) for optimal contrast and readability.
  - Text Secondary: Muted warm slate (`#71716D`).

## Typography

Typography relies on **Plus Jakarta Sans** across all levels to combine geometric legibility with gentle, humanistic curves suited for Indonesian phrasing.

Key typographic rules:
- Headings use heavier weights (`700` and `800`) with tight letter spacing for structured scannability.
- Body copy remains uncluttered at `400` weight with comfortable line heights, ensuring ingredient notes and recipe steps remain effortlessly legible during cooking.
- Status badges and metadata labels utilize `label-md` and `label-sm` with slightly widened tracking for instantaneous status scanning in quick-glance kitchen environments.

## Layout & Spacing

The layout is built for hand-held single-thumb mobile ergonomics centered on a 390px baseline canvas (390×844 dp). 

- **Outer Margin**: 20px (`1.25rem`) safe side-inset on mobile screens.
- **Card Spacing & Internal Gaps**: Base scale steps on a disciplined 4px/8px modular rhythm (`space-xs` = 4px, `space-sm` = 8px, `space-md` = 12px, `space-lg` = 16px, `space-xl` = 24px).
- **Section Rhythm**: Stacked modules and ingredient lists maintain 16px to 24px bottom clearances, preserving an airy, uncluttered feel.
- **Bottom Clearance**: All scroll containers must include a minimum bottom padding of 96px to clear the fixed bottom navigation bar and the elevated floating action button.

## Elevation & Depth

Visual hierarchy uses clean, tactile layering combining low-contrast physical outlines with soft ambient drop shadows. Avoid harsh dark drop shadows.

- **Level 0 (Flat / Canvas)**: Off-white canvas (`#FAFAF7`) with no elevation.
- **Level 1 (Cards & Feed Items)**: Pure white background (`#FFFFFF`), a crisp 1px perimeter border (`#EAEAE5`), and an ambient shadow: `box-shadow: 0 4px 16px -2px rgba(24, 35, 28, 0.04), 0 2px 6px -1px rgba(24, 35, 28, 0.02)`.
- **Level 2 (Active Sheets / Dropdowns / Filter Chips Selected)**: `box-shadow: 0 8px 24px -4px rgba(24, 35, 28, 0.08), 0 3px 8px -2px rgba(24, 35, 28, 0.04)`.
- **Level 3 (Floating Action Button & Overlays)**: Central primary Add button and active modals utilize a soft green-tinted glow: `box-shadow: 0 12px 28px -6px rgba(46, 158, 91, 0.35), 0 4px 12px -2px rgba(46, 158, 91, 0.15)`.
- **Level 4 (Bottom Navigation Bar)**: Pinned surface with subtle top stroke (`#EAEAE5`) and soft upper shadow: `box-shadow: 0 -4px 20px rgba(0, 0, 0, 0.03)`.

## Shapes

The interface maintains a friendly, organic roundedness token scale (`roundedness: 2`).

- **Pantry Inventory Cards**: Standard 16px (`1rem`) border radius, establishing soft container boundaries.
- **Status Pills, Tags, and Badges**: Fully rounded pill shapes (`border-radius: 9999px`) to distinguish categorical metadata from structural content cards.
- **Action Buttons & Inputs**: 12px to 14px border radius for ergonomic tap targets.
- **Center Add Button**: Full circle (`56px × 56px`, `50%` radius) elevated within the bottom navigation bar.
- **Image Containers & Badges**: 12px border radius for ingredient thumbnails and category illustrations.

## Components

### 1. Ingredient Inventory Cards
- **Dimensions & Style**: Surface `#FFFFFF`, border `1px solid #EAEAE5`, border radius `16px`, padding `16px`.
- **Contents**: Left food icon/illustration thumbnail (48×48px with soft tinted backdrop), middle title with storage place (*Kulkas*, *Rak Bumbu*, *Freezer*), right status pill and days-left counter.
- **Micro-Progress Bar**: 4px high track indicating shelf-life progression at the card base (Green → Orange → Red fill).

### 2. Freshness Status Pills
- **Aman**: Background `#EAF7EE`, text `#2E9E5B`, font `label-sm`, full pill radius.
- **Segera Dipakai**: Background `#FEF3C7`, text `#B45309`, font `label-sm`, full pill radius.
- **Sudah Basi**: Background `#FEE2E2`, text `#B91C1C`, font `label-sm`, full pill radius.

### 3. Buttons
- **Primary**: Background `#2E9E5B`, label `#FFFFFF` (`label-lg`), height `48px`, border radius `14px`. Hover/Active: `#26854C`.
- **Secondary / Subdued**: Background `#EAF7EE`, label `#2E9E5B`, border `none`, height `48px`, border radius `14px`.
- **Outlined**: Background `transparent`, border `1px solid #EAEAE5`, text `#18231C`.

### 4. Input Fields & Search
- **Height**: 48px, background `#FFFFFF`, border `1px solid #EAEAE5`, border radius `12px`, padding `0 16px`.
- **Focus State**: Border color `#2E9E5B`, ring outline `2px solid rgba(46, 158, 91, 0.15)`.

### 5. Filter Chips & Tags
- **Default**: Background `#FAFAF7`, border `1px solid #EAEAE5`, text `#71716D`, padding `6px 14px`, pill radius.
- **Selected**: Background `#2E9E5B`, border `1px solid #2E9E5B`, text `#FFFFFF`, font `label-sm`.

### 6. Mobile Bottom Navigation Bar
- **Bar Container**: 5-slot flex layout, background `#FFFFFF`, border-top `1px solid #EAEAE5`, height `68px` (plus safe-area-inset).
- **Navigation Slots**:
  1. *Beranda* (Home icon + label)
  2. *Resep* (Recipe book icon + label)
  3. *Tambah* (Center slot: 56px circular floating action button, `#2E9E5B` with white `+` icon, lifted -16px above the bar line)
  4. *Statistik* (Bar chart icon + label)
  5. *Profil* (User avatar/profile icon + label)
- **Active State**: Primary Green icon and label (`#2E9E5B`, `label-sm`). Inactive state: `#71716D`.