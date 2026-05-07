---
user-invocable: true
name: frontend-code-separation
description: Use when components have inline types or static data - guides separation into dedicated files
---

# Code Separation Standards

When working with components, separate concerns into dedicated files:
- **Types** → `.types.ts` or domain type files
- **Data** → `.data.ts` files
- **Component** → Only imports, logic, JSX

## Types Location Priority

| Priority | Location | When to Use |
|----------|----------|-------------|
| 1 | `Component.types.ts` | Component-specific types that won't be reused |
| 2 | `types/domain.ts` | Domain types shared across components (e.g., `types/products.ts` for product-related types) |
| 3 | `types/index.ts` | Global types used everywhere |

```tsx
// types/products.ts - Domain types
export interface Product {
  id: string;
  name: string;
  price: number;
}

// components/ProductCard/ProductCard.types.ts - Component-specific
export interface ProductCardProps {
  product: Product;
  variant?: 'default' | 'compact';
}
```

## Data Files

Static definitions go into `.data.ts` or `.data.tsx` (if contains JSX):

| Goes to `data.ts` | Goes to `constants.ts` |
|-------------------|------------------------|
| Link definitions with text/href | Magic numbers (ITEMS_PER_PAGE) |
| Menu/navigation items | API endpoints |
| Icon configurations | Environment config |
| Static card content | Timeouts, limits |
| Dropdown options | Feature flags |

**Example - `Footer.data.tsx`:**

```tsx
import { CalendarHeartIcon, FlagIcon, GlobeIcon, HeadsetIcon } from 'lucide-react';
import type { IconItem, InfoItem, LinkSection } from './Footer.types';

export const iconsItems: IconItem[] = [
  { title: 'on-market-for-25-years', icon: <CalendarHeartIcon /> },
  { title: 'over-100-countries', icon: <GlobeIcon /> },
  { title: 'kind-support', icon: <HeadsetIcon /> },
];

export const infoItems: InfoItem[] = [
  {
    title: 'DISCOMP s.r.o',
    icon: <FlagIcon />,
    address: 'Cvokařská 1216/8',
    emails: ['info@discomp.cz'],
  },
];

export const linkItems: LinkSection[] = [
  {
    title: 'products',
    items: [
      { title: 'news', href: '/news' },
      { title: 'recommended', href: '/recommended' },
    ],
  },
];
```

## Component Structure After Separation

```
components/
  Footer/
    Footer.tsx         # Only imports, logic, JSX
    Footer.types.ts    # Interfaces and types
    Footer.data.tsx    # Static data (uses JSX for icons)
    index.ts           # Re-export
```

**Clean Component Example:**

```tsx
// Footer.tsx
import { cn } from '@/lib/utils/utils';
import { FooterIcons } from './FooterIcons';
import { FooterLinks } from './FooterLinks';
import { iconsItems, linkItems } from './Footer.data';
import type { FooterProps } from './Footer.types';

export function Footer({ className }: FooterProps) {
  return (
    <footer className={cn('space-y-6 px-4 py-16', className)}>
      <FooterIcons items={iconsItems} />
      <FooterLinks links={linkItems} />
    </footer>
  );
}
```

## When to Apply This Skill

Apply when you see:
- Interfaces/types defined in component files
- Static arrays (links, items, options) in component files
- Component file > 100 lines due to data definitions

## Checklist

- [ ] Types extracted to `.types.ts` or appropriate domain file
- [ ] Static data extracted to `.data.ts` (or `.data.tsx` if contains JSX)
- [ ] Component only has: imports, hooks, logic, return JSX
- [ ] All imports use `import type` for type-only imports
- [ ] Index file re-exports component (if folder structure)
