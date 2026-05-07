---
user-invocable: true
name: frontend-i18n
description: Use when adding any user-facing text, labels, aria-labels, or error messages - ALL text must be translated
---

# Internationalization Standards

## Critical Rule

**ALL user-facing text MUST be translated. NO hardcoded strings.**

This includes:

- All visible text
- All `aria-label` attributes
- All `alt` texts (except dynamic product names)
- All error messages
- All placeholder texts
- All button labels
- All form labels

## Server Components

```tsx
import { getTranslations } from 'next-intl/server';

async function ProductCard({ product }: { product: Product }) {
  const t = await getTranslations('ProductCard');

  return (
    <article>
      <h2>{t('title')}</h2>
      <p>
        {t('price-label')}: {formatPrice(product.price)}
      </p>
      <button aria-label={t('add-to-cart')}>{t('buy')}</button>
    </article>
  );
}
```

## Client Components

```tsx
'use client';

import { useTranslations } from 'next-intl';

function FavoriteButton({ productCode }: { productCode: string }) {
  const t = useTranslations('Favorites');
  const { isFavorite, toggleFavorite } = useFavorite(productCode);

  const label = isFavorite ? t('remove') : t('add');

  return (
    <button onClick={toggleFavorite} aria-label={label}>
      <HeartIcon filled={isFavorite} />
    </button>
  );
}
```

## Dynamic Content with Variables

```json
// messages/cs.json
{
  "ProductCard": {
    "items-count": "Počet položek: {count}",
    "price-with-vat": "Cena s DPH: {price}",
    "added-by": "Přidal: {name} dne {date}"
  }
}
```

```tsx
// Usage
<span>{t('items-count', { count: 5 })}</span>
<span>{t('price-with-vat', { price: formatPrice(100) })}</span>
<span>{t('added-by', { name: user.name, date: formatDate(createdAt) })}</span>
```

## Translation File Structure

```
messages/
├── cs.json    # Czech (default)
└── en.json    # English
```

```json
// Namespace organization
{
  "Header": { ... },
  "Footer": { ... },
  "ProductCard": { ... },
  "Favorites": {
    "add": "Přidat do oblíbených",
    "remove": "Odebrat z oblíbených"
  },
  "Common": {
    "loading": "Načítání...",
    "error": "Něco se pokazilo",
    "retry": "Zkusit znovu"
  }
}
```

## Common Patterns

```tsx
// Pluralization
{
  "items": "{count, plural, =0 {Žádné položky} one {# položka} few {# položky} other {# položek}}"
}

// Conditional text
const label = isActive ? t('deactivate') : t('activate');

// Formatted numbers
{t('price', { price: formatPrice(product.price) })}

// Formatted dates
{t('created', { date: formatDate(product.createdAt) })}
```

## Bad Patterns (NEVER DO)

```tsx
// Bad - Hardcoded string
<button>Add to Cart</button>

// Bad - Concatenation instead of variables
<span>{"Items: " + count}</span>

// Bad - Missing aria-label translation
<button aria-label="Close"><XIcon /></button>
```
