---
user-invocable: true
name: frontend-performance
description: Use when optimizing components, images, data fetching, or adding loading states and skeletons
---

# Performance Standards

## React Memoization

| Hook          | When to use                                           |
| ------------- | ----------------------------------------------------- |
| `useMemo`     | Expensive calculations that depend on specific values |
| `useCallback` | Callbacks passed to memoized children                 |
| `React.memo`  | Components that re-render often with same props       |

```tsx
// Good - expensive calculation
const sortedProducts = useMemo(() => {
  return products.sort((a, b) => a.price - b.price);
}, [products]);

// Good - callback for memoized child
const handleClick = useCallback((id: string) => {
  setSelected(id);
}, []);

<MemoizedList items={products} onItemClick={handleClick} />;

// Bad - unnecessary memoization (too simple)
const doubled = useMemo(() => count * 2, [count]);
```

## Image Optimization

Always use Next.js Image component:

```tsx
import Image from 'next/image';

// Standard image with responsive sizes
<Image
  src={product.image}
  alt={product.name}
  width={400}
  height={400}
  sizes="(max-width: 768px) 100vw, (max-width: 1200px) 50vw, 33vw"
  className="object-contain"
/>

// Above-the-fold image (hero, banner)
<Image
  src="/hero-banner.jpg"
  alt={t('hero-alt')}
  priority
  loading="eager"
/>

// Fill container
<div className="relative aspect-square">
  <Image
    src={product.image}
    alt={product.name}
    fill
    className="object-cover"
  />
</div>
```

## Code Splitting

Use dynamic imports for heavy components:

```tsx
import dynamic from 'next/dynamic';

// Lazy load with loading state
const HeavyComponent = dynamic(() => import('@/components/HeavyComponent'), {
  loading: () => <Skeleton className="h-64 w-full" />,
  ssr: false, // Client-only component
});

// Lazy load modals
const SomeModal = dynamic(() => import('@/components/SomeModal'));
```

## Data Fetching

Always fetch in parallel when possible:

```tsx
// Good - Parallel fetching
const [products, categories, banners] = await Promise.all([
  getProducts(),
  getCategories(),
  getBanners(),
]);

// Bad - Sequential fetching (slower)
const products = await getProducts();
const categories = await getCategories(); // Waits for products
const banners = await getBanners(); // Waits for categories
```

## Loading States

### Skeleton Components

Skeletons must match the layout of actual content:

```tsx
import { Skeleton } from '@/components/ui/Skeleton';

// Match real card layout
function CardSkeleton() {
  return (
    <div className="space-y-2 rounded-lg border p-4">
      <Skeleton className="h-32 w-full" /> {/* Image */}
      <Skeleton className="h-5 w-3/4" /> {/* Title */}
      <Skeleton className="h-4 w-1/2" /> {/* Price */}
    </div>
  );
}
```

### Button Loading States

```tsx
const [isPending, setIsPending] = useState(false);

<Button onClick={handleSubmit} disabled={isPending}>
  {isPending ? (
    <>
      <Loader className="mr-2 animate-spin" />
      {t('loading')}
    </>
  ) : (
    t('submit')
  )}
</Button>;
```

### Page-Level Loading

Use `loading.tsx` for route segments:

```tsx
// app/[locale]/products/loading.tsx
import { GridSkeleton } from '@/components/skeletons';

export default function Loading() {
  return <GridSkeleton count={12} />;
}
```

## Loading State Placement

| Scenario            | Solution                          |
| ------------------- | --------------------------------- |
| Full page load      | `loading.tsx` + page skeleton     |
| Section within page | Inline skeleton component         |
| Button action       | `disabled` + loading text/spinner |
| Form submission     | Disable form + loading indicator  |
| Infinite scroll     | Skeleton cards at bottom          |
| Modal content       | Skeleton inside modal             |
