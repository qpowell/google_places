## 1.0.0

- Upgraded httparty 0.14.0 -> 0.15.6
- Dropped support for Ruby 1.9.x (required for the httparty upgrade)
- Upgraded RSpec 3.5.0 -> 3.6.0

## 0.34.2

- Add the `matched_substrings` attribute to the Prediction results (for autocomplete results)
- Add the `structured_formatting` attribute to the Prediction results (for autocomplete results)

## 0.34.1

- Remove new argument that was accidentally added to the Review class

## 0.34.0

- Added the option `details: true` to all methods that return a collection of spots
- Added `permanently_closed` to the returned fields for a spot
- Introduced the CHANGELOG
