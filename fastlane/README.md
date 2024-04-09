fastlane documentation
----

# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```sh
xcode-select --install
```

For _fastlane_ installation instructions, see [Installing _fastlane_](https://docs.fastlane.tools/#installing-fastlane)

# Available Actions

## iOS

### ios coverage

```sh
[bundle exec] fastlane ios coverage
```

Run test coverage

### ios tests

```sh
[bundle exec] fastlane ios tests
```

Run tests

### ios deploy

```sh
[bundle exec] fastlane ios deploy
```

Build EUDI Wallet Demo version and upload it to AppCenter

### ios resetVersioning

```sh
[bundle exec] fastlane ios resetVersioning
```

Reset version and build number to default

### ios update_build_number

```sh
[bundle exec] fastlane ios update_build_number
```

Set build number

### ios update_version

```sh
[bundle exec] fastlane ios update_version
```

Set version

### ios build_number

```sh
[bundle exec] fastlane ios build_number
```

Build Number

### ios tag_name

```sh
[bundle exec] fastlane ios tag_name
```

Build Tag Name

### ios upload_to_appcenter

```sh
[bundle exec] fastlane ios upload_to_appcenter
```

Upload to AppCenter

### ios latest_appcenter_release

```sh
[bundle exec] fastlane ios latest_appcenter_release
```

Get Release version From AppCenter

### ios calver

```sh
[bundle exec] fastlane ios calver
```

Build Version

----

This README.md is auto-generated and will be re-generated every time [_fastlane_](https://fastlane.tools) is run.

More information about _fastlane_ can be found on [fastlane.tools](https://fastlane.tools).

The documentation of _fastlane_ can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
