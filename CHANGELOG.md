## 2.0.0
### Breaking Changes for 2.0.0:
- Removed the `spots_by_radar` method
- Remove support for all unsupported versions of Ruby (< 2.4)

### Added
- Expose the `json_result_object` field on a Spot object

## 1.2.0
### Added
- Add a region option to the `spots` and `spots_by_query` methods

### Fixed
- Fix spots* method options leaking to other methods

## 1.1.0

- Include the profile_photo_url attribute for the GooglePlaces::Review object
- Gracefully handle HTTP 500 errors from the Google API

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
