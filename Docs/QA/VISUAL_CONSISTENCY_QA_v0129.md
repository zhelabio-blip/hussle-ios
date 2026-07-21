# Hussle v0.12.9 — Visual Consistency QA

## User-reported corrections
- Welcome dog portrait is now a smaller, fully filled circle.
- Welcome copy uses a minimum 24 pt side inset and wraps/centers when needed.
- Discover dog and owner portraits use explicit square fill frames before circular clipping.
- Demo source images were recropped to remove baked borders, white margins, and UI fragments.
- The corrupted Sophie owner image was replaced by a clean portrait-only crop.
- Discover card portrait size was reduced and internal spacing increased.

## Three-pass static QA
1. Geometry: all DogThumbnail and OwnerThumbnail instances render through one shared circular component.
2. Data: dog/owner image names map to existing bundled resources; all 12 resources are valid square JPEG files.
3. Copy/layout: welcome copy spelling and punctuation reviewed; core screen side inset is 24 pt.

## Honest validation status
The archive has passed static source/resource checks. Actual compile/runtime validation requires Xcode on macOS.
