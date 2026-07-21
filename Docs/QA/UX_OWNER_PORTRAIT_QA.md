# Hussle v0.12.6 — Owner Portrait & End-to-End UX QA

## Scope completed

- Owner photo is requested on the first onboarding form.
- Owner photo and owner name are clearly distinguished from the dog's data.
- Demo mode offers a demo owner photo so Simulator onboarding cannot become blocked by an empty photo library.
- Review Profile uses a consistent circular dog portrait with a smaller circular owner portrait overlaid at the lower-right.
- Discover uses the same dog-owner portrait composition for every card.
- Matches, Messages, Chat header, Match celebration, and Profile reuse the same circular portrait components.
- Demo data includes male and female owners.
- Dog photo, owner photo, owner name, dog breed, dog sex, goal, and location remain consistent across screens.
- Review Profile is adaptive and does not require vertical scrolling on supported iPhone heights.

## QA pass 1 — Data consistency

Checked all demo profiles:

- Charlie — Chihuahua, male — Tony
- Luna — Chihuahua, female — Anna
- Milo — Poodle, male — James
- Buddy — Dachshund, male — Minh
- Coco — Bichon Frise, female — Sophie
- Zoe — Yorkshire Terrier, female — Emma

All profiles have mapped dog and owner image assets.

## QA pass 2 — Design-system consistency

- Dog portraits use circles in all compact/profile-card contexts.
- Owner portraits use circles with a consistent white border and shadow.
- Owner portrait size remains subordinate to dog portrait size.
- Standard spacing is 16–22 pt between portrait groups and text.
- Goal chips use the same capsule styling and purpose colors.
- No text is intentionally placed flush against profile previews.

## QA pass 3 — Navigation and blocking states

- Back navigation remains available after the first onboarding page.
- Owner photo, owner name, goals, dog data, vaccination, city, and radius remain in state when navigating back.
- Continue identifies missing required information.
- Demo owner-photo action prevents Simulator users from becoming blocked if the photo library is empty.
- Review Profile displays all summary content without a vertical scroll dependency.

## Automated/static checks

- All Swift files passed `swiftc -frontend -parse`.
- `project.yml` includes the full DemoImages resource directory.
- Six dog images and six owner images are present.
- No obsolete goal labels such as Reading or Works exist in Swift UI copy.
- ZIP integrity checked after packaging.

## Mac Simulator acceptance test

Because this build environment does not contain Apple's iOS SDK or Simulator, the final runtime acceptance check must be completed on a Mac:

1. Complete onboarding using the demo owner photo.
2. Confirm the Review Profile composition fits without scrolling.
3. Confirm owner images appear in Discover, Full Profile, Match, Matches, Messages, Chat, and Profile.
4. Confirm all demo dogs retain the correct breed and owner.
