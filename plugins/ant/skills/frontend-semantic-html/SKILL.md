---
user-invocable: true
name: frontend-semantic-html
description: Use when creating or modifying JSX structure - guides proper use of section, article, nav, header, footer, aside, main elements
---

# Semantic HTML Standards

## When to Use Each Element

| Element     | Use for                               | NOT for            |
| ----------- | ------------------------------------- | ------------------ |
| `<section>` | Thematic content with heading         | Generic containers |
| `<article>` | Self-contained content (cards, posts) | Sections of page   |
| `<nav>`     | Navigation blocks only                | Any list of links  |
| `<header>`  | Introductory content, site header     | Every heading      |
| `<footer>`  | Footer info, metadata                 | Bottom containers  |
| `<aside>`   | Sidebar, related content              | Main content       |
| `<main>`    | Primary page content (ONE per page)   | Multiple times     |

## Examples

Good - Product section:

```tsx
<section className="py-8">
  <h2>{t('featured-products')}</h2>
  <div className="grid grid-cols-3 gap-4">
    {products.map((p) => (
      <ProductCard key={p.id} product={p} />
    ))}
  </div>
</section>
```

Good - Product card as article:

```tsx
<article className="border rounded-lg p-4">
  <h3>{product.name}</h3>
  <p className="text-muted-foreground">{formatPrice(product.price)}</p>
</article>
```

Good - Navigation:

```tsx
<nav aria-label="Main navigation" className="border-b">
  <ul className="flex gap-6 container py-4">
    <li>
      <Link href="/">{t('nav.home')}</Link>
    </li>
    <li>
      <Link href="/products">{t('nav.products')}</Link>
    </li>
  </ul>
</nav>
```

Good - Page layout:

```tsx
<>
  <header className="sticky top-0 bg-background border-b">
    <nav>...</nav>
  </header>
  <main className="container py-8">
    <article>...</article>
  </main>
  <aside className="w-64">
    <section>
      <h2>{t('related')}</h2>
      ...
    </section>
  </aside>
  <footer className="border-t py-8">...</footer>
</>
```

Bad - div instead of semantic:

```tsx
<div className="navigation">
  {' '}
  {/* Should be <nav> */}
  <div className="nav-items">...</div>
</div>
```

Bad - Multiple main elements:

```tsx
<main>Content 1</main>
<main>Content 2</main>  {/* Only ONE <main> per page! */}
```
