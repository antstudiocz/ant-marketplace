---
user-invocable: true
name: laravel-performance
description: Use when writing or reviewing Laravel 12+ code involving database queries, Eloquent relationships, queue jobs, or route optimization. Detects N+1 queries, missing eager loading, select *, count() vs exists(), unoptimized jobs without rate limiting, large datasets without chunking, or missing monitoring setup.
---

# Laravel 12+ Performance Expert

**Announce at start:** "I'm using the laravel-performance skill to optimize for performance."

## Mode Detection

If user asks to "review", "audit", "optimize", or "check performance" of existing code, switch to **Review Mode** (see below). Otherwise, operate in **Implementation Mode**.

## Eloquent Query Optimization

### N+1 Prevention (priority order)

1. **Global auto-loading** (12.8+): `Model::automaticallyEagerLoadRelationships()` in AppServiceProvider. Best for large apps with many dynamic relationships.
2. **Per-model `$with`**: For always-needed relationships. `protected $with = ['author'];`
3. **Per-query `with()`**: For context-specific loading. `Post::with('comments')->get()`
4. **`chaperone()`**: On HasMany to auto-hydrate parent, preventing reverse N+1.

### Detection setup (require in every Laravel 12+ project)

```php
// AppServiceProvider::boot()
Model::preventLazyLoading(!app()->isProduction());
Model::handleLazyLoadingViolationUsing(function ($model, $relation) {
    logger()->warning("N+1: {$model::class}::{$relation}");
});
```

### Query patterns

| Instead of | Use | Why |
|-----------|-----|-----|
| `Model::all()` | `Model::select('id','name')->get()` | Avoid unused columns |
| `->count() > 0` | `->exists()` | Stops at first match |
| `Model::all()` on 10k+ rows | `Model::chunkById(500, fn)` | Memory-safe processing |
| Multiple queries for related data | `joinSub()` or subquery | Single DB round-trip |
| `DB::table()->get()` in loop | Single query with `whereIn()` | Batch instead of N queries |
| `Model::all()` then filter in PHP | `Model::where()->get()` | Filter at DB level |

## Queue & Job Optimization

### Job calling external API? Always add rate limiting:

```php
// AppServiceProvider::boot()
RateLimiter::for('external-api', fn($job) => Limit::perMinute(30)->by($job->userId));

// In job class:
public function middleware(): array
{
    return [new RateLimited('external-api')];
}
```

### Job middleware checklist

| Middleware | When to use |
|-----------|-------------|
| `new RateLimited('name')` | Job calls external API |
| `new WithoutOverlapping($id)` | Only one instance per entity allowed |
| `new SkipIfBatchCancelled` | Job is part of a Bus::batch() |
| `ShouldBeUnique` interface | Only one instance on entire queue |
| `retryUntil()` over `$tries` | Rate-limited releases count as attempts |
| `ShouldBeEncrypted` interface | Job payload contains sensitive data |

### Large dataset processing

- **100+ items**: Use `Bus::batch()` with chunked jobs
- **External API per item**: Dedicated queue + `--rest=5` worker flag
- **Order matters**: Single queue with `WithoutOverlapping`
- **Heavy compute**: Offload to queue, never in Octane request worker

## Monitoring Setup

### Development (AppServiceProvider::boot)

```php
if (!app()->isProduction()) {
    DB::listen(fn($q) => $q->time > 100 && logger()->warning("Slow: {$q->sql}"));
    DB::whenQueryingForLongerThan(500, fn() => logger()->warning("Cumulative slow queries"));
}
```

### Production

- **Laravel Pulse**: Real-time dashboard — slow queries, jobs, cache hit/miss, server load.
- **`DB::whenQueryingForLongerThan()`**: With Slack/Sentry notification for cumulative slow requests.
- **Pulse sampling**: Set `sample_rate => 0.1` for high-traffic apps (scales up in dashboard).

## Deploy Checklist

Every Laravel 12+ deploy should include:

```bash
php artisan optimize          # Cache config, routes, views, events
# .env: CACHE_STORE=redis, SESSION_DRIVER=redis
```

## Cross-reference to Caching

When a performance issue is best solved by caching (repeated expensive query, heavy aggregation, static content):

→ **Use `ant:laravel-caching` skill** for cache method selection, invalidation strategy, and layer recommendations. That skill covers `Cache::memo()`, `Cache::flexible()`, cache tags, HTTP headers, and the full cache layer stack.

## Review Mode

When user asks to review code for performance:

### Step 1: Identify data access points
Scan for: Eloquent queries, `DB::` calls, relationship access in loops, external API calls, queue dispatches.

### Step 2: Check each against rules
- N+1? Relationship accessed in loop without `with()`?
- `select *`? Missing column specification on large tables?
- `count()` where `exists()` would suffice?
- Large dataset (1000+ rows) without `chunkById()`?
- Job calling external API without rate limiting middleware?
- Missing `preventLazyLoading()` setup?

### Step 3: Check infrastructure
- `automaticallyEagerLoadRelationships()` or per-model `$with` configured?
- `DB::listen()` / `DB::whenQueryingForLongerThan()` set up?
- `php artisan optimize` in deploy pipeline?
- Monitoring (Pulse/Telescope) installed?

### Step 4: Output structured review

```
## Performance Review: [file/class name]

### Critical (must fix)
- [Issue] → [Fix with code snippet]

### Recommended (significant improvement)
- [Issue] → [Suggested approach]

### Optional (nice-to-have)
- [Minor optimizations]

### Already Good
- [Acknowledge correct patterns]

### Caching Opportunities
- [Items to review with `ant:laravel-caching` skill]
```
