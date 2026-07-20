# Behavior classification

| Classification | Baseline meaning | Suite result | Future handling |
| --- | --- | --- | --- |
| `expected` | The specification defines a required invariant. | Pass only when the synthetic trace and structural assertions pass. | A diff is a specification regression unless separately reviewed. |
| `known-defect` | The specification documents a legacy limitation hypothesis and impact. | Never present it as observed live behavior or correct production behavior. | Fix requires reviewed reclassification and appropriate runtime evidence. |
| `must-change` | The desired contract is absent from `9.0.9` or deliberately deferred. | Synthetic expectation only, not a production pass claim. | Must be implemented, independently verified, then reclassified. |

No classification may weaken a safety rule. In particular, a metadata hint is
not approval evidence, requested routing is not actual host evidence, and a
missing context package is not a successful review.
