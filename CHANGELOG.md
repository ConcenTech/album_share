
# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).


## [0.3.0] - 15/10/2024

### Added

- Activity.
Users can now view and reply to likes and comments.
- Background sync.
Android and iOS only for now.

### Changed

- Moved away from bitsdojo_window package onto the window-manager package.
This allows us to have better control over the window and fix the buggy double click to maximise.

### Fixed
- App bar unable to hide on mobile platforms.
- App attempts to validate token when launched even if not signed in.

## [0.2.1] - 20/09/2024

### Added

- Changelog
- Added album title to AssetViewerScreen

### Changed

- Use same colour on material navigation bars and material app bar.
- Updated default preferences.

### Fixed
- Tapping on desktop app bar causes it to hide.
- AssetViewerPage popping when image zoomed.
Now, when the user attempts to navigate back, the image scale is first reset then the page popped if the user attempts to navigate back a second time
-  If the user attempts to navigate backwards after logging in, the user is taken to the login page again but remains logged in.
- Pop called twice when asset swiped down.


[0.2.1]: https://github.com/ConcenTech/album_share/compare/main...0.2.1
[0.3.0]: https://github.com/ConcenTech/album_share/compare/0.2.1...0.3.0
