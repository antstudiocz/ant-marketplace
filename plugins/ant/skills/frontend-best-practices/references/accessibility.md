---
user-invocable: true
name: frontend-accessibility
description: Use when adding interactive elements, forms, images, or any user-facing content - ensures a11y compliance
---

# Accessibility Standards

## Core Rules

1. Use semantic HTML first (before ARIA)
2. All images must have `alt` text
3. All interactive elements must be keyboard accessible
4. Focus indicators must be visible
5. Forms must have labels and error messages

## Interactive Elements

All buttons and links need keyboard accessibility and focus states:

```tsx
// Button with proper focus
<button
  className="
    bg-primary text-primary-foreground
    focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2
    duration-200
  "
  aria-label={t('add-to-cart')}
>
  <CartIcon />
</button>

// Custom interactive element (if not using button/link)
<div
  role="button"
  tabIndex={0}
  onClick={handleClick}
  onKeyDown={(e) => {
    if (e.key === 'Enter' || e.key === ' ') {
      e.preventDefault();
      handleClick();
    }
  }}
  aria-label={t('action-description')}
>
  {t('click-me')}
</div>
```

## Images

```tsx
// Informative image - describe content
<Image src={product.image} alt={product.name} />

// Decorative image - empty alt, hide from screen readers
<Image src="/decorative.svg" alt="" aria-hidden="true" />

// Logo with company name
<Image src="/logo.svg" alt={t('company-logo', { name: 'CompanyName' })} />
```

## Screen Reader Only Content

Use `sr-only` for text that should only be read by screen readers:

```tsx
// Icon-only button
<button>
  <HeartIcon />
  <span className="sr-only">{t('add-to-favorites')}</span>
</button>

// Badge with context
<span className="badge">3</span>
<span className="sr-only">{t('items-in-cart')}</span>

// Skip to main content
<a href="#main" className="sr-only focus:not-sr-only focus:absolute focus:top-0 focus:left-0 focus:p-4">
  {t('skip-to-content')}
</a>
```

## Live Regions (Dynamic Updates)

Announce dynamic content changes to screen readers:

```tsx
// Polite - waits for current reading to finish (common)
<div aria-live="polite">{t('item-added-to-cart')}</div>

// Assertive - interrupts immediately (only for critical errors)
<div role="alert" aria-live="assertive">{error}</div>

// Search results count
<div aria-live="polite">
  {t('search-results', { count: results.length })}
</div>
```

## Form Accessibility

```tsx
<label htmlFor="email">{t('email')}</label>
<input
  id="email"
  type="email"
  aria-invalid={!!errors.email}
  aria-describedby={errors.email ? 'email-error' : undefined}
/>
{errors.email && (
  <p id="email-error" role="alert" className="text-destructive">
    {errors.email.message}
  </p>
)}
```

## Focus Management

- Modals: trap focus inside, return focus on close
- Forms: focus first error field on validation failure
- Page navigation: manage focus for SPA transitions
