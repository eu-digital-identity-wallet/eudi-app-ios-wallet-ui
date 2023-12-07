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

### ios tests

```sh
[bundle exec] fastlane ios tests
```

Run tests

### ios demo

```sh
[bundle exec] fastlane ios demo
```

Build EUDI Wallet Demo version and upload it to AppCenter

### ios update_build_number

```sh
[bundle exec] fastlane ios update_build_number
```

Set build number to default 1

### ios reset_buildnumber

```sh
[bundle exec] fastlane ios reset_buildnumber
```

Set build number to default 1

### ios build_number

```sh
[bundle exec] fastlane ios build_number
```

Build Number

### ios full_version

```sh
[bundle exec] fastlane ios full_version
```

Build Full version

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

----

This README.md is auto-generated and will be re-generated every time [_fastlane_](https://fastlane.tools) is run.

More information about _fastlane_ can be found on [fastlane.tools](https://fastlane.tools).

The documentation of _fastlane_ can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
