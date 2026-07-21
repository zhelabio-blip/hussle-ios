# Hussle — Last Approved Build Policy

A build becomes the new Last Approved Build only after Tony writes exactly: **«Сборка утверждена»**.

Until then it is a Candidate Build and cannot replace the baseline.

## Immutable rules
1. The Last Approved Build is never edited in place.
2. A Candidate Build may add functionality, but may not silently remove, hide, reorder, rename, or change any approved feature, route, state, copy, visual composition, data behavior, or error behavior.
3. Any discovered defect in an approved area must be reported before modification. It is fixed only after Tony approves the change.
4. Every candidate is compared against the baseline by files, routes, state transitions, UI, data contracts, assets, and tests.
5. Static inspection, Xcode compilation, Simulator runtime, and end-to-end behavior are reported separately.
