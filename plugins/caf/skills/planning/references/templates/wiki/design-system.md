# Design System

This document defines the UI design system including design tokens, components, patterns, and guidelines. It serves as the source of truth for visual and interaction design.

**Last updated**: [Date]

## Design Tokens

### Colors

**Primary colors**:
- `primary-500`: #[hex] - Main brand color
- `primary-600`: #[hex] - Darker shade for hover states
- `primary-400`: #[hex] - Lighter shade for backgrounds

**Neutral colors**:
- `gray-900`: #[hex] - Primary text
- `gray-700`: #[hex] - Secondary text
- `gray-500`: #[hex] - Disabled text
- `gray-300`: #[hex] - Borders
- `gray-100`: #[hex] - Backgrounds
- `gray-50`: #[hex] - Subtle backgrounds

**Semantic colors**:
- `success-500`: #[hex] - Success states
- `error-500`: #[hex] - Error states
- `warning-500`: #[hex] - Warning states
- `info-500`: #[hex] - Informational states

**Usage example**:
```css
.button-primary {
  background-color: var(--primary-500);
  color: white;
}

.button-primary:hover {
  background-color: var(--primary-600);
}
```

### Typography

**Font families**:
- `font-sans`: [Font name], -apple-system, system-ui, sans-serif
- `font-mono`: [Mono font], 'Courier New', monospace

**Font sizes**:
- `text-xs`: 12px / 0.75rem
- `text-sm`: 14px / 0.875rem
- `text-base`: 16px / 1rem
- `text-lg`: 18px / 1.125rem
- `text-xl`: 20px / 1.25rem
- `text-2xl`: 24px / 1.5rem
- `text-3xl`: 30px / 1.875rem
- `text-4xl`: 36px / 2.25rem

**Font weights**:
- `font-normal`: 400
- `font-medium`: 500
- `font-semibold`: 600
- `font-bold`: 700

**Line heights**:
- `leading-tight`: 1.25
- `leading-normal`: 1.5
- `leading-relaxed`: 1.75

### Spacing

**Scale** (in pixels):
- `spacing-1`: 4px
- `spacing-2`: 8px
- `spacing-3`: 12px
- `spacing-4`: 16px
- `spacing-5`: 20px
- `spacing-6`: 24px
- `spacing-8`: 32px
- `spacing-10`: 40px
- `spacing-12`: 48px
- `spacing-16`: 64px

### Border Radius

- `rounded-sm`: 2px
- `rounded`: 4px
- `rounded-md`: 6px
- `rounded-lg`: 8px
- `rounded-xl`: 12px
- `rounded-full`: 9999px

### Shadows

- `shadow-sm`: 0 1px 2px rgba(0,0,0,0.05)
- `shadow`: 0 1px 3px rgba(0,0,0,0.1)
- `shadow-md`: 0 4px 6px rgba(0,0,0,0.1)
- `shadow-lg`: 0 10px 15px rgba(0,0,0,0.1)
- `shadow-xl`: 0 20px 25px rgba(0,0,0,0.1)

### Breakpoints

- `sm`: 640px - Mobile landscape
- `md`: 768px - Tablet
- `lg`: 1024px - Desktop
- `xl`: 1280px - Large desktop
- `2xl`: 1536px - Extra large desktop

## Components

### Button

**Variants**:

**Primary button**:
- Background: `primary-500`
- Text: white
- Hover: `primary-600`
- Padding: `spacing-3` `spacing-6`
- Border radius: `rounded-md`
- Font weight: `font-medium`

**Secondary button**:
- Background: transparent
- Border: 1px solid `gray-300`
- Text: `gray-700`
- Hover: `gray-100` background
- Padding: `spacing-3` `spacing-6`

**Sizes**:
- Small: `text-sm`, padding `spacing-2` `spacing-4`
- Medium: `text-base`, padding `spacing-3` `spacing-6` (default)
- Large: `text-lg`, padding `spacing-4` `spacing-8`

**States**:
- Default: Normal appearance
- Hover: Darker background or subtle shadow
- Active: Pressed appearance
- Disabled: 50% opacity, no pointer events
- Loading: Show spinner, disabled state

**Example**:
```jsx
<Button variant="primary" size="medium">
  Save Changes
</Button>
```

### Input

**Text input**:
- Border: 1px solid `gray-300`
- Border radius: `rounded-md`
- Padding: `spacing-3`
- Font size: `text-base`
- Focus: `primary-500` border, outline ring

**States**:
- Default: Normal border
- Focus: Primary color border + ring
- Error: `error-500` border
- Disabled: `gray-100` background, cursor not-allowed

**Example**:
```jsx
<Input
  type="text"
  placeholder="Enter workspace name"
  error={errors.name}
/>
```

### Card

**Default card**:
- Background: white
- Border: 1px solid `gray-200`
- Border radius: `rounded-lg`
- Padding: `spacing-6`
- Shadow: `shadow-sm`

**Hover state**:
- Shadow: `shadow-md`
- Transition: 150ms ease

### Modal

**Overlay**:
- Background: rgba(0,0,0,0.5)
- Backdrop blur: 4px

**Modal container**:
- Background: white
- Border radius: `rounded-lg`
- Max width: 500px (default)
- Padding: `spacing-6`
- Shadow: `shadow-xl`

**Header**:
- Font size: `text-xl`
- Font weight: `font-semibold`
- Margin bottom: `spacing-4`

### Dropdown Menu

[Define dropdown patterns]

### Toast Notification

[Define toast notification patterns]

## Patterns

### Navigation

**Sidebar navigation**:
- Width: 240px
- Background: `gray-50`
- Border right: 1px solid `gray-200`
- Items: `text-sm`, padding `spacing-3`
- Active state: `primary-500` background with 10% opacity

**Top navigation bar**:
- Height: 64px
- Background: white
- Border bottom: 1px solid `gray-200`
- Shadow: `shadow-sm`

### Form Layout

**Form groups**:
- Margin bottom: `spacing-6`
- Label above input
- Error message below input in `error-500`

**Form actions**:
- Align right
- Primary button + Secondary button (optional)
- Spacing: `spacing-3` between buttons

### Loading States

**Spinner**:
- Size: 24px (default)
- Color: `primary-500`
- Animation: Rotate 360deg in 1s

**Skeleton loader**:
- Background: `gray-200`
- Animation: Pulse 2s ease-in-out infinite

**Full page loader**:
- Centered spinner
- Optional message below

### Empty States

**Layout**:
- Centered content
- Icon (48px)
- Heading (`text-lg`, `font-semibold`)
- Description (`text-sm`, `gray-600`)
- Call-to-action button

### Error States

**Inline error**:
- Below input field
- `text-sm`, `error-500`
- Icon (optional)

**Page error**:
- Centered content
- Error icon (64px)
- Error code and message
- Action button to retry or go back

## Accessibility

**Color contrast**:
- Text on background: minimum 4.5:1 ratio (WCAG AA)
- Large text (18px+): minimum 3:1 ratio

**Focus indicators**:
- All interactive elements have visible focus state
- Focus ring: 2px solid `primary-500` with 2px offset

**Keyboard navigation**:
- All interactive elements accessible via Tab
- Logical tab order
- Enter/Space activates buttons
- Escape closes modals/dropdowns

**Screen readers**:
- Use semantic HTML
- Add ARIA labels where needed
- Announce state changes

## Animation

**Transitions**:
- Duration: 150ms (fast), 300ms (normal), 500ms (slow)
- Easing: ease-in-out (default), ease-in, ease-out

**Common animations**:
- Fade in: opacity 0 to 1
- Slide in: transform translateY(10px) to 0
- Scale: transform scale(0.95) to 1

## Icons

**Icon library**: [Heroicons / Feather / Material / Custom]

**Sizes**:
- Small: 16px
- Medium: 24px (default)
- Large: 32px

**Usage**:
- Use consistent icon set
- Match icon visual weight to text weight
- Provide text labels or aria-labels

## Responsive Design

**Mobile-first approach**:
- Design for mobile (320px+) first
- Add complexity at larger breakpoints

**Common breakpoint adjustments**:
- Stack columns vertically on mobile
- Hamburger menu on mobile, full nav on desktop
- Smaller text and padding on mobile
- Touch-friendly tap targets (min 44x44px)

## Dark Mode (if applicable)

[Define dark mode color palette and patterns]

## Notes

[Additional notes about design decisions, brand guidelines, or future changes]

---

## How to use this document

1. **When creating design specs**: Reference this document for existing components and patterns
2. **When designing new features**: Use existing tokens and components when possible
3. **When adding components**: Update this document with new component definitions
4. **When modifying design**: Update the relevant section and note the change

This document should be updated whenever:
- New components are created
- Design tokens are added or modified
- Patterns are established or changed
- Accessibility requirements change
