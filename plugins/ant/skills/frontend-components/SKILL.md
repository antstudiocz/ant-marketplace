---
user-invocable: true
name: frontend-components
description: Use when creating, extracting, or refactoring React components - covers DRY, naming, structure
---

# Component Standards

## When to Extract a Component

- Used 2+ times → Extract
- Logic > 50 lines → Extract
- Needs isolated testing → Extract
- DON'T extract prematurely - wait for patterns to emerge

## File Naming Conventions

| Type       | Convention                             | Example                            |
| ---------- | -------------------------------------- | ---------------------------------- |
| Components | PascalCase                             | `ProductCard.tsx`                  |
| Hooks      | camelCase + use                        | `useAuth.ts`                       |
| Utils      | camelCase                              | `formatPrice.ts`                   |
| Types      | PascalCase                             | `Product.ts`                       |
| Constants  | camelCase file, SCREAMING_SNAKE values | `pagination.ts` → `ITEMS_PER_PAGE` |

## Component Structure Order

```tsx
// 1. Imports (external → internal → types)
import { useState } from 'react';
import { Button } from '@/components/ui/Button';
import type { Product } from '@/types/Product';

// 2. Interface/Types
interface ProductCardProps {
  product: Product;
  variant?: 'default' | 'compact';
}

// 3. Component function
export function ProductCard({
  product,
  variant = 'default',
}: ProductCardProps) {
  const t = useTranslations('products');
  const [isHovered, setIsHovered] = useState(false);

  return <article>...</article>;
}

// 4. Sub-components (if local only)
function PriceDisplay({ price }: { price: number }) {
  return <span>{formatPrice(price)}</span>;
}
```

## Naming Patterns

| Suffix      | Purpose                     | Example                           |
| ----------- | --------------------------- | --------------------------------- |
| `*Card`     | Card components             | `ProductCard`, `UserCard`         |
| `*Button`   | Button variants             | `AddToCartButton`, `SubmitButton` |
| `*Form`     | Form components             | `LoginForm`, `ContactForm`        |
| `*Skeleton` | Loading skeletons           | `ProductCardSkeleton`             |
| `*Field`    | Form fields with validation | `InputField`, `SelectField`       |
| `*Modal`    | Modal dialogs               | `ConfirmModal`, `DeleteModal`     |

## Export Patterns

```tsx
// Good - Named exports for components
export function ProductCard({ product }: ProductCardProps) {}

// Bad - Default exports (except for pages)
export default function ProductCard() {}
```

## Shared Components Location

```
src/components/
├── ui/           # Base UI primitives (shadcn)
├── ecommerce/    # Shopping-specific reusable
├── forms/        # Form components with validation
├── layout/       # Header, Footer, Sidebar
└── shared/       # Cross-domain shared
```

## Import Rules

```tsx
// ALWAYS use path aliases
import { ProductCard } from '@/components/ecommerce/ProductCard';
import { formatPrice } from '@/lib/utils/format';

// NEVER use relative imports
import { ProductCard } from '../../../components/ProductCard'; // BAD
```
