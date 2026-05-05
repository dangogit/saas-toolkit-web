---
name: ncode-web-design
description: Web-specific design rules for Next.js + shadcn/ui + Tailwind CSS projects. Handles font loading, RTL implementation with Tailwind logical properties, shadcn customization, responsive design, and dark mode. Activates alongside ncode-anti-vibe-coding during web UI work.
---

# nCode Web Design Rules

Web-platform-specific design rules for Next.js projects. These rules extend `ncode-anti-vibe-coding` with web-specific implementation details.

---

## Section 1: Font Loading (Next.js)

Load all fonts via `next/font/google` - never via CDN links, `<link>` tags, or `@import` in CSS.

```ts
// app/layout.tsx
import { Heebo } from 'next/font/google'
import { Inter } from 'next/font/google'

const heebo = Heebo({
  subsets: ['hebrew', 'latin'],
  variable: '--font-heebo',
  display: 'swap',
})

const inter = Inter({
  subsets: ['latin'],
  variable: '--font-inter',
  display: 'swap',
})

export default function RootLayout({ children }) {
  return (
    <html lang="he" dir="rtl" className={`${heebo.variable} ${inter.variable}`}>
      <body className={heebo.className}>
        {children}
      </body>
    </html>
  )
}
```

Rules:
- Hebrew body font comes from DESIGN.md - do not default to the Next.js default (Geist)
- Set subsets: `['hebrew', 'latin']` for any Hebrew font
- Latin/English complement font loaded separately via `next/font/google`
- Apply the primary font via `className` on `<body>`, not just via a CSS variable
- Use `variable` to expose the font as a CSS custom property for Tailwind config

---

## Section 2: RTL Implementation (Tailwind CSS)

### Logical Properties - Full Mapping

Always use logical properties. Physical direction properties (left/right) break RTL layouts.

| Physical (avoid) | Logical (use) |
|-------------------|---------------|
| `ml-4` | `ms-4` |
| `mr-4` | `me-4` |
| `pl-4` | `ps-4` |
| `pr-4` | `pe-4` |
| `left-4` | `start-4` |
| `right-4` | `end-4` |
| `text-left` | `text-start` |
| `text-right` | `text-end` |
| `rounded-l-lg` | `rounded-s-lg` |
| `rounded-r-lg` | `rounded-e-lg` |
| `border-l` | `border-s` |
| `border-r` | `border-e` |

### HTML Setup

Set direction on the root element in `app/layout.tsx`:

```tsx
<html lang="he" dir="rtl">
```

### When to Use `rtl:` Variant

Keep the `rtl:` variant prefix only for cases logical properties cannot cover:
- Directional icons that need to be mirrored (chevrons, arrows)
- CSS transforms that are direction-dependent
- Third-party components that hardcode physical properties

### Inline LTR Content

Phone numbers, URLs, and code snippets must always render left-to-right:

```tsx
// Inline phone number
<span dir="ltr">+972-50-123-4567</span>

// Code snippet
<bdo dir="ltr">npm install</bdo>

// URL
<a href="..." dir="ltr">https://example.com</a>
```

---

## Section 3: shadcn/ui Customization

### components.json

Set the default radius to match DESIGN.md - do not leave the shadcn default:

```json
{
  "style": "default",
  "rsc": true,
  "tsx": true,
  "tailwind": {
    "config": "tailwind.config.ts",
    "css": "app/globals.css",
    "baseColor": "neutral",
    "cssVariables": true
  },
  "aliases": {
    "components": "@/components",
    "utils": "@/lib/utils"
  }
}
```

### CSS Variables in globals.css

Map DESIGN.md brand colors to shadcn CSS variables:

```css
@layer base {
  :root {
    --background: 0 0% 100%;
    --foreground: 222.2 84% 4.9%;
    --primary: /* brand primary from DESIGN.md */;
    --primary-foreground: 210 40% 98%;
    --radius: /* from DESIGN.md */;
  }

  .dark {
    --background: 222.2 84% 4.9%;
    --foreground: 210 40% 98%;
    --primary: /* dark-mode variant */;
  }
}
```

### Component Discipline

- Pick 5-7 shadcn components and use them consistently throughout the app
- Do not install every available component - unused components create noise
- Common core set: Button, Card, Input, Dialog, Sheet, Badge, Dropdown

### Button Padding Override

shadcn's default button padding is too tight for Hebrew text. Override in globals.css or in the component variant:

```css
/* globals.css */
.btn-hebrew {
  @apply px-6 py-3;
}
```

Or configure in `components/ui/button.tsx` variant defaults: minimum `px-6 py-3`.

### RTL-Specific Component Rules

- Dialogs and Sheet components: ensure text inside uses `text-start` not `text-left`
- Sidebar component: must render on the right side in RTL (`side="right"`)
- Dropdown menus: check that the alignment (`align`) prop doesn't force LTR positioning

---

## Section 4: Responsive Design

### Approach

Mobile-first. Write styles for 375px first, then add `sm:`, `md:`, `lg:`, `xl:` overrides for larger screens.

### Breakpoints (Tailwind defaults)

| Prefix | Min-width | Target device |
|--------|-----------|---------------|
| `sm:` | 640px | Large phones, small tablets |
| `md:` | 768px | iPad |
| `lg:` | 1024px | Laptop |
| `xl:` | 1280px | Desktop |

### Spacing Standards

- Container max-width: `max-w-6xl` (~1200px) - never full-width edge-to-edge
- Section vertical padding: `py-16` on mobile, `py-24` on desktop
- Card padding: `p-6` minimum
- Between heading and content: `mb-6` minimum

```tsx
// Correct container pattern
<section className="py-16 lg:py-24">
  <div className="container max-w-6xl mx-auto px-4">
    {/* content */}
  </div>
</section>
```

### Test Breakpoints

Always verify at these widths before shipping:
- 375px - iPhone SE (smallest common viewport)
- 768px - iPad portrait
- 1280px - Standard desktop
- 1920px - Large monitor

### Touch and Interaction

- Touch targets: 44x44px minimum, even on web (mobile browsers use touch)
- No horizontal scroll at any breakpoint - test by resizing browser
- Images: always use `next/image` with responsive `sizes` prop

```tsx
<Image
  src={src}
  alt={alt}
  fill
  sizes="(max-width: 768px) 100vw, (max-width: 1200px) 50vw, 33vw"
/>
```

---

## Section 5: Web-Specific Patterns

### Navigation

Sticky nav with glass effect - the only acceptable use of glassmorphism:

```tsx
<nav className="sticky top-0 z-50 bg-background/80 backdrop-blur-md border-b border-border">
  {/* nav content */}
</nav>
```

Mobile hamburger menu rules:
- Menu must open from the right side in RTL layouts
- Use shadcn Sheet with `side="right"` for the mobile drawer
- Close button must be positioned at the start (right in RTL), not end

Sidebar layouts:
- Content sidebar: render on the right side for RTL reading flow
- Navigation sidebar: right side by default in RTL

### Hover States

Every clickable element needs a visible hover state - no invisible interaction zones.

Preferred patterns:
- Subtle scale: `hover:scale-[1.02] transition-transform duration-150 ease-out`
- Background change: `hover:bg-muted transition-colors duration-150 ease-out`

Rules:
- Transitions: 150-200ms duration, `ease-out` easing only
- No bounce (`ease-in-out` spring), no elastic easing
- No color shifts on hover (hue changes are jarring) - use opacity or background changes

### Scroll Behavior

```css
/* globals.css */
html {
  scroll-behavior: smooth;
}
```

- Smooth scroll for all anchor links
- No parallax effects - they degrade performance and accessibility
- Sticky headers must account for their own height in scroll offsets:

```tsx
// Offset scroll target by header height
<div id="section" className="scroll-mt-16">
```

### SEO-Visible Elements

- Hero sections must contain real HTML text, not images of text
- One `<h1>` per page - enforce this in every page component
- Heading hierarchy: `h1` > `h2` > `h3` - never skip levels

---

## Section 6: Web Dark Mode Implementation

### CSS Variables Strategy

All color tokens must use CSS variables - no hardcoded hex or Tailwind color names in components:

```css
/* globals.css */
:root {
  --color-brand: 220 90% 56%;
  --color-surface: 0 0% 100%;
}

.dark {
  --color-brand: 220 85% 65%;
  --color-surface: 222 47% 11%;
}
```

### shadcn Dark Mode: Class Strategy

Configure Tailwind to use class-based dark mode in `tailwind.config.ts`:

```ts
export default {
  darkMode: 'class',
  // ...
}
```

### Toggle Implementation

Persist mode to localStorage and respect the OS preference as the initial default:

```ts
// Read OS preference if no saved preference exists
const saved = localStorage.getItem('theme')
const prefersDark = window.matchMedia('(prefers-color-scheme: dark)').matches
const initial = saved ?? (prefersDark ? 'dark' : 'light')

document.documentElement.classList.toggle('dark', initial === 'dark')
```

Toggle must:
1. Update `classList` on `<html>` immediately (no flash)
2. Save to `localStorage`
3. Show a sun/moon icon that matches the current state

### Verification

- Test both light and dark modes at every breakpoint before shipping
- OpenGraph images: must look acceptable on both light and dark social media backgrounds
- Check shadcn components in both modes - some need explicit dark-mode overrides
