# Fastlane Usage

This file documents how to use the Fastlane lanes in this project. The generated lane list remains
in `fastlane/README.md` and may be overwritten by Fastlane.

## Prerequisites

Install Ruby dependencies from the repository root:

```bash
bundle install
```

Run lanes through Bundler, in a UTF-8 locale as fastlane requires. Without one, `xcpretty` can stop
at the first non-ASCII character of the test output:

```bash
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
APP_SCHEME="EUDI Wallet Dev" bundle exec fastlane ios tests
```

The `tests` lane stops unless a scheme is given, through `APP_SCHEME` or as a lane parameter
(`bundle exec fastlane ios tests scheme:"EUDI Wallet Dev"`). Neither test lane names a simulator, so
`scan` picks one unless `SCAN_DEVICE` is set.

The iOS build still uses the Xcode project, schemes, and configuration described in
[../wiki/HOW_TO_BUILD.md](../wiki/HOW_TO_BUILD.md).

## Common Lanes

| Lane | Purpose |
| --- | --- |
| `ios tests` | Runs the selected scheme's test plan with `scan`. |
| `ios code_coverage` | Runs tests with coverage enabled and generates `xcov` output in `xcov_output/`. Failing tests do not fail the lane (`fail_build: false`); read the test results there. `fastlane/.xcovignore` leaves out test code, the app shell, configuration, errors, views and other UI components, UI models, routes and dependency injection; view models, extensions, the navigation host and the storage controllers are counted. xcov matches each entry, lowercased, against file names as a regular expression anchored at the end, or as a path prefix. |
| `ios deploy` | Pulls the latest Git state, creates an App Store Connect API key, calculates a build number from TestFlight, sets version and build number values, archives the app, uploads it to App Store Connect/TestFlight, deletes the IPA and dSYM files, resets project version values, tags the release, pushes the tag to any configured remote, and optionally creates a GitHub release. |
| `ios upload_appstore` | Uploads the generated IPA to App Store Connect/TestFlight with `pilot`, without waiting for processing or distributing the build to testers. |
| `ios github_release` | Creates a GitHub release from the repository, token, tag and version that `deploy` passes in. |
| `ios upload_tag` | Sets the URL of the `origin` remote to the given remote and pushes a Git tag to it. The previous URL is not restored. |
| `ios update_build_number` | Updates build numbers in plist and Xcode project values for configured targets. |
| `ios update_version` | Updates marketing version in the Xcode project for configured targets and configuration. |
| `ios reset_project` | Resets build number and version values back to repository defaults. |
| `ios build_number` | Adds one to the build number passed in; `deploy` passes the latest TestFlight build number. |
| `ios tag_name` | Builds the release tag name. |
| `ios full_version` | Builds the CalVer-style full version string. |
| `ios minified_version` | Computes and writes the App Store-compatible version without the build-type suffix. |

The lanes after `deploy` are helpers that `deploy` calls. They take lane parameters rather than
environment variables, and most of them fail when run on their own without those parameters.

## Required Environment Variables

The `tests` and `code_coverage` lanes expect:

| Variable | Required for | Meaning |
| --- | --- | --- |
| `APP_PROJECT` | Coverage | Xcode project path, for example `EudiReferenceWallet.xcodeproj`. |
| `APP_SCHEME` | Tests and coverage | Scheme to test, for example `EUDI Wallet Dev`, `EUDI Wallet Demo`, or a production scheme. |
| `XCOV_EXCLUDE_TARGETS` | Coverage | Optional comma-separated targets to exclude from coverage, named as in the coverage report, for example `EudiReferenceWalletIDProvider.appex`. |
| `SCAN_DEVICE` | Tests and coverage | Optional simulator to test on, with its runtime, for example `iPhone 17 Pro (26.5)`. Without it, `scan` picks a simulator. |

The `deploy` lane expects:

| Variable | Required for | Meaning |
| --- | --- | --- |
| `APP_SCHEME` | Archive | Scheme to archive. Production should use a dedicated production scheme. |
| `APP_BUILD_TYPE` | Versioning and tags | Release label used in generated version and tag values, for example `Demo` or `Prod`. |
| `APP_TARGETS` | Versioning | Comma-separated targets whose build number/version should be updated. Include the extension target where needed. |
| `APP_VERSION_CONFIG` | Versioning | Build configuration to update, for example `Release Demo` or `Release Prod`. |
| `APP_TAG` | Tags | Tag namespace or brand segment used in the generated Git tag. |
| `APP_BUNDLE_ID` | Upload and export options | Main app bundle identifier. |
| `APP_PROVISION_PROFILE` | Export options | Main app provisioning profile name. |
| `APP_EXTENSION_BUNDLE_ID` | Export options | Identity Document Provider extension bundle identifier. Not read by the checked-in lane; used by the export mapping below. |
| `APP_EXTENSION_PROVISION_PROFILE` | Export options | Extension provisioning profile name. Not read by the checked-in lane; used by the export mapping below. |
| `APP_IPA_PATH` | Upload | Path to the generated IPA. |
| `TESTFLIGHT_GROUPS` | Upload | Optional comma-separated TestFlight groups, passed to `pilot`. They have no effect at present: the lane sets `skip_waiting_for_build_processing`, so `pilot` returns before it distributes the build. Assign testers in App Store Connect. |
| `CONNECT_KEY_ID` | App Store Connect | App Store Connect API key ID. |
| `CONNECT_ISSUER_ID` | App Store Connect | App Store Connect API issuer ID. |
| `CONNECT_KEY_PATH` | App Store Connect | Path to the private key file injected by CI secret storage. |
| `CONNECT_APPLE_ID` | App Store Connect | Apple account used by Fastlane metadata. |
| `CONNECT_ITC_TEAM_ID` | App Store Connect | App Store Connect team ID. |
| `CONNECT_TEAM_NAME` | App Store Connect | Apple Developer team name. |
| `CONNECT_TEAM_ID` | App Store Connect | Apple Developer team ID. |
| `PROD_REMOTE_REPO` | Optional tag upload | Remote URL to push tags to a production mirror. `upload_tag` sets `origin` to this URL. |
| `DEV_REMOTE_REPO` | Optional tag upload | Remote URL to push tags to a development mirror, after the production one. `upload_tag` sets `origin` to this URL. |
| `GITHUB_RELEASE_REPO` | Optional GitHub release | Repository name for GitHub releases, for example `owner/repo`. |
| `GITHUB_RELEASE_TOKEN` | Optional GitHub release | Token used by Fastlane to create the release. |

Current lane caveat:

The checked-in `deploy` lane currently passes only the main app provisioning profile to
`build_app`. The app target embeds `EudiReferenceWalletIDProvider`, so production CI must extend the
lane so the exported IPA includes explicit profile mappings for both the main app and the extension.

## Example Commands

Run tests for the Dev scheme:

```bash
APP_SCHEME="EUDI Wallet Dev" \
SCAN_DEVICE="iPhone 17 Pro (26.5)" \
bundle exec fastlane ios tests
```

Run coverage for the Dev scheme:

```bash
APP_PROJECT="EudiReferenceWallet.xcodeproj" \
APP_SCHEME="EUDI Wallet Dev" \
SCAN_DEVICE="iPhone 17 Pro (26.5)" \
XCOV_EXCLUDE_TARGETS="EudiReferenceWalletIDProvider.appex" \
bundle exec fastlane ios code_coverage
```

Deploy a controlled Demo build to TestFlight:

```bash
APP_SCHEME="EUDI Wallet Demo" \
APP_BUILD_TYPE="Demo" \
APP_TARGETS="EudiWallet,EudiReferenceWalletIDProvider" \
APP_VERSION_CONFIG="Release Demo" \
APP_TAG="Wallet" \
APP_BUNDLE_ID="eu.europa.ec.euidi" \
APP_PROVISION_PROFILE="EUDI Demo Release" \
APP_IPA_PATH="./EudiWallet.ipa" \
CONNECT_KEY_ID="<key-id>" \
CONNECT_ISSUER_ID="<issuer-id>" \
CONNECT_KEY_PATH="<path-to-private-key>" \
CONNECT_APPLE_ID="<apple-id>" \
CONNECT_ITC_TEAM_ID="<itc-team-id>" \
CONNECT_TEAM_NAME="<team-name>" \
CONNECT_TEAM_ID="<team-id>" \
bundle exec fastlane ios deploy
```

Production export mapping for the embedded extension:

```ruby
provisioningProfiles = {
  ENV["APP_BUNDLE_ID"] => ENV["APP_PROVISION_PROFILE"],
  ENV["APP_EXTENSION_BUNDLE_ID"] => ENV["APP_EXTENSION_PROVISION_PROFILE"]
}
```

## Production Notes

Before using Fastlane for production:

* Add a dedicated production scheme, for example `EUDI Wallet Prod`.
* Add production build configurations, for example `Debug Prod` and `Release Prod`.
* Add production `.xcconfig` files and a `PROD` app build variant.
* Update the lane or export options to include provisioning profile mappings for both the main app
  and the Identity Document Provider extension; the current lane only maps the main app profile.
* Add secret scanning and demo-endpoint checks before upload.
* Archive the IPA, dSYM files, entitlements, provisioning profile metadata, dependency report, SBOM,
  signing certificate fingerprint, Git commit, and test reports. The current `deploy` lane deletes the
  IPA and dSYM files after the upload (`clean_build_artifacts`), so copy them before that step.
* Store App Store Connect API keys, certificates, profiles, and passwords only in approved CI secret
  storage.
* Do not rely on TestFlight build numbers as the only source of production release numbering unless
  the release process explicitly approves it.

## Release Cautions

The current `deploy` lane mutates version and build number values, archives the app, uploads it to
App Store Connect/TestFlight, deletes the IPA and dSYM files, and resets project version values. Only
then does it create a Git tag, push it to the configured remotes and, if configured, create a GitHub
release. To push the tag, `upload_tag` sets the URL of the `origin` remote to `PROD_REMOTE_REPO` or
`DEV_REMOTE_REPO` and does not restore it, so after a run `origin` points at the last of them. Run
the lane only from a clean working tree and a controlled CI environment.

For production, ensure the pipeline fails if the archive contains any of the demo values listed in
[Pre-Release Automated Checks](../wiki/GO_LIVE.md#pre-release-automated-checks).

For the complete production release process, see [../wiki/GO_LIVE.md](../wiki/GO_LIVE.md).
