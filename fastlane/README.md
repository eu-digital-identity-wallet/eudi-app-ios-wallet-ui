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

Build & Deploy Wallet

### ios github_release

```sh
[bundle exec] fastlane ios github_release
```

Release to github

### ios upload_tag

```sh
[bundle exec] fastlane ios upload_tag
```

Upload tag to remote repo

### ios upload_appstore

```sh
[bundle exec] fastlane ios upload_appstore
```

Reset version and build number to default

### ios reset_project

```sh
[bundle exec] fastlane ios reset_project
```

Reset default project settings

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

### ios full_version

```sh
[bundle exec] fastlane ios full_version
```

Build Version

### ios minified_version

```sh
[bundle exec] fastlane ios minified_version
```

Appstore Build Version

----

This README.md is auto-generated and will be re-generated every time [_fastlane_](https://fastlane.tools) is run.

More information about _fastlane_ can be found on [fastlane.tools](https://fastlane.tools).

The documentation of _fastlane_ can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
