---
user-invocable: true
name: frontend-responsive
description: Use when implementing responsive layouts, breakpoints, or device-specific rendering
---

# Responsive Design Standards

## Mobile-First Breakpoints (Tailwind)

| Prefix | Min Width | Use for                      |
| ------ | --------- | ---------------------------- |
| (none) | 0px       | Mobile (default)             |
| `sm:`  | 640px     | Large phones / small tablets |
| `md:`  | 768px     | Tablet                       |
| `lg:`  | 1024px    | Desktop                      |
| `xl:`  | 1280px    | Large desktop                |

## CSS-First Approach (Preferred)

For most cases, use Tailwind breakpoints:

```tsx
// Responsive grid
<div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">

// Show/hide elements
<div className="hidden md:block">Desktop only</div>
<div className="md:hidden">Mobile only</div>

// Responsive typography & spacing
<h1 className="text-2xl md:text-3xl lg:text-4xl">
<section className="p-4 md:p-6 lg:p-8">
```

## When to Use JavaScript Device Detection

CSS breakpoints are sufficient for:

- Layout changes (grid columns, spacing)
- Showing/hiding elements
- Typography scaling

**Use JS device detection when:**

- Completely different component trees (MobileNav vs DesktopNav)
- Heavy components you don't want to ship to mobile
- Server-side rendering needs to know device type

## User-Agent Based Detection

For SSR-friendly device detection, parse User-Agent header server-side using libraries like `ua-parser-js`:

```tsx
// Server-side detection (e.g., in middleware or layout)
import { UAParser } from 'ua-parser-js';
import { headers } from 'next/headers';

export async function isMobile(): Promise<boolean> {
  const headersList = await headers();
  const userAgent = headersList.get('user-agent') || '';
  const parser = new UAParser(userAgent);
  const deviceType = parser.getDevice().type;

  return deviceType === 'mobile';
}

// Usage in server component
const mobile = await isMobile();
```

**CRITICAL: Tablets are unreliable!**

- `isMobile()` - RELIABLE for phones
- `isTablet()` - UNRELIABLE (iPads often report as desktop Safari)
- `isDesktop()` - Includes tablets requesting desktop site

**Always use binary detection:**

```tsx
// Good - binary choice
const mobile = await isMobile();
return mobile ? <MobileLayout /> : <DesktopLayout />;

// Bad - relying on tablet detection
if (isMobile()) return <Mobile />;
if (isTablet()) return <Tablet />; // Unreliable!
return <Desktop />;
```

## Client-Side Hook Pattern

Pass server-detected value through context for client components:

```tsx
// Provider (receives server-side detection)
interface DeviceContextValue {
  isMobile: () => boolean;
}

const DeviceContext = createContext<DeviceContextValue>({
  isMobile: () => false,
});

export function DeviceProvider({
  children,
  initialIsMobile,
}: {
  children: ReactNode;
  initialIsMobile: boolean;
}) {
  return (
    <DeviceContext.Provider value={{ isMobile: () => initialIsMobile }}>
      {children}
    </DeviceContext.Provider>
  );
}

// Hook for client components
export function useDevice() {
  return useContext(DeviceContext);
}

// Usage in client component
('use client');
const { isMobile } = useDevice();
return isMobile() ? <MobileMenu /> : <DesktopMenu />;
```

## When to Use Device Detection vs CSS

| Use Case                           | Use Device Detection? | Why                           |
| ---------------------------------- | --------------------- | ----------------------------- |
| Completely different layouts       | Yes                   | Avoid shipping unused JS/HTML |
| Different spacing/sizing           | No                    | Use CSS breakpoints           |
| Hide/show minor elements           | No                    | Use CSS `hidden md:block`     |
| Heavy component (carousel vs grid) | Yes                   | Performance optimization      |

## Responsive Images

```tsx
<Image
  src={product.image}
  alt={product.name}
  width={800}
  height={800}
  sizes="(max-width: 768px) 100vw, (max-width: 1200px) 50vw, 33vw"
/>
```
