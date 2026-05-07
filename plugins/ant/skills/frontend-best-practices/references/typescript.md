---
user-invocable: true
name: frontend-typescript
description: Use when defining types, interfaces, props, or handling null/undefined values
---

# TypeScript Standards

## Interface vs Type

| Use         | For                                          |
| ----------- | -------------------------------------------- |
| `interface` | Component props, object shapes (public APIs) |
| `type`      | Unions, intersections, utility types         |

```tsx
// Interface for props
interface ProductCardProps {
  product: Product;
  variant?: 'default' | 'compact';
  onAddToCart?: (product: Product) => void;
}

// Type for unions
type ButtonVariant = 'default' | 'outline' | 'ghost' | 'destructive';
type Status = 'idle' | 'loading' | 'success' | 'error';

// Type for intersections
type UserWithPermissions = User & { permissions: Permission[] };

// Type for utility types
type PartialProduct = Partial<Product>;
type ProductKeys = keyof Product;
```

## Import Types

Always use `import type` for type-only imports:

```tsx
// Good - separate type imports
import { useState } from 'react';
import type { Product } from '@/types/Product';
import type { User } from '@/types/User';

// Good - mixed imports
import { useQuery, type QueryResult } from '@apollo/client';
import { Button, type ButtonProps } from '@/components/ui/Button';

// Bad - regular imports for types
import { Product } from '@/types/Product'; // Should use 'import type'
```

## Props Typing

```tsx
// Basic props interface
interface ProductCardProps {
  product: Product;
  variant?: 'default' | 'compact';
  className?: string;
}

// Extending HTML element props
interface ButtonProps extends React.ButtonHTMLAttributes<HTMLButtonElement> {
  variant?: 'default' | 'outline';
  isLoading?: boolean;
}

export function Button({
  variant = 'default',
  isLoading = false,
  children,
  disabled,
  ...props
}: ButtonProps) {
  return (
    <button disabled={disabled || isLoading} {...props}>
      {isLoading ? <Spinner /> : children}
    </button>
  );
}
```

## Strict Null Handling

```tsx
// Good - Explicit null check
interface UserProfileProps {
  user: User | null;
}

export function UserProfile({ user }: UserProfileProps) {
  if (!user) {
    return <div>{t('user.notFound')}</div>;
  }
  return <h2>{user.name}</h2>; // user is now non-null
}

// Good - Optional chaining + nullish coalescing
const title = product?.name ?? t('untitled');
const discount = product.discount?.percentage ?? 0;

// Good - Type guards
function isProduct(item: Product | Category): item is Product {
  return 'price' in item;
}

if (isProduct(item)) {
  console.log(item.price); // TypeScript knows it's Product
}

// Bad - Non-null assertion without check
const price = product!.price; // DANGEROUS!
```

## Generic Components

```tsx
interface DataTableProps<T> {
  data: T[];
  columns: Column<T>[];
  onRowClick?: (row: T) => void;
}

export function DataTable<T>({ data, columns, onRowClick }: DataTableProps<T>) {
  return (
    <table>
      {data.map((row, i) => (
        <tr key={`row-${i}`} onClick={() => onRowClick?.(row)}>
          {columns.map((col) => (
            <td key={col.key}>{col.render(row)}</td>
          ))}
        </tr>
      ))}
    </table>
  );
}
```
