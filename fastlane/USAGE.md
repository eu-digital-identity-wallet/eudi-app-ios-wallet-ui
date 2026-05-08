# Fastlane Usage

This file documents how to use the Fastlane lanes in this project. The generated lane list remains
in `fastlane/README.md` and may be overwritten by Fastlane.

## Prerequisites

Install Ruby dependencies from the repository root:

```bash
bundle install
```

Run lanes through Bundler:

```bash
bundle exec fastlane ios tests
```

The iOS build still uses the Xcode project, schemes, and configuration described in
[../wiki/how_to_build.md](../wiki/how_to_build.md).

## Common Lanes

| Lane | Purpose |
| --- | --- |
| `ios tests` | Runs the selected scheme's test plan with `scan`. |
| `ios code_coverage` | Runs tests with coverage enabled and generates `xcov` output. |
| `ios deploy` | Pulls the latest Git state, creates an App Store Connect API key, calculates a build number from TestFlight, sets version values, archives the app, uploads it to App Store Connect/TestFlight, resets project version values, tags the release, and optionally creates a GitHub release. |
| `ios upload_appstore` | Uploads the generated IPA to App Store Connect/TestFlight with `pilot`. |
| `ios github_release` | Creates a GitHub release using the configured repository and token. |
| `ios upload_tag` | Pushes a Git tag to a configured remote. |
| `ios update_build_number` | Updates build numbers in plist and Xcode project values for configured targets. |
| `ios update_version` | Updates marketing version in the Xcode project for configured targets and configuration. |
| `ios reset_project` | Resets build number and version values back to repository defaults. |
| `ios build_number` | Computes the next build number from the latest TestFlight build number. |
| `ios tag_name` | Builds the release tag name. |
| `ios full_version` | Builds the CalVer-style full version string. |
| `ios minified_version` | Computes and writes the App Store-compatible version without the build-type suffix. |

## Required Environment Variables

The `tests` and `code_coverage` lanes expect:

| Variable | Required for | Meaning |
| --- | --- | --- |
| `APP_PROJECT` | Coverage | Xcode project path, for example `EudiReferenceWallet.xcodeproj`. |
| `APP_SCHEME` | Tests and coverage | Scheme to test, for example `EUDI Wallet Dev`, `EUDI Wallet Demo`, or a production scheme. |
| `XCOV_EXCLUDE_TARGETS` | Coverage | Optional comma-separated targets to exclude from coverage. |

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
| `APP_IPA_PATH` | Upload | Path to the generated IPA. |
| `TESTFLIGHT_GROUPS` | Upload | Optional comma-separated TestFlight groups. |
| `CONNECT_KEY_ID` | App Store Connect | App Store Connect API key ID. |
| `CONNECT_ISSUER_ID` | App Store Connect | App Store Connect API issuer ID. |
| `CONNECT_KEY_PATH` | App Store Connect | Path to the private key file injected by CI secret storage. |
| `CONNECT_APPLE_ID` | App Store Connect | Apple account used by Fastlane metadata. |
| `CONNECT_ITC_TEAM_ID` | App Store Connect | App Store Connect team ID. |
| `CONNECT_TEAM_NAME` | App Store Connect | Apple Developer team name. |
| `CONNECT_TEAM_ID` | App Store Connect | Apple Developer team ID. |
| `PROD_REMOTE_REPO` | Optional tag upload | Remote URL to push tags to a production mirror. |
| `DEV_REMOTE_REPO` | Optional tag upload | Remote URL to push tags to a development mirror. |
| `GITHUB_RELEASE_REPO` | Optional GitHub release | Repository name for GitHub releases, for example `owner/repo`. |
| `GITHUB_RELEASE_TOKEN` | Optional GitHub release | Token used by Fastlane to create the release. |

## Example Commands

Run tests for the Dev scheme:

```bash
APP_SCHEME="EUDI Wallet Dev" bundle exec fastlane ios tests
```

Run coverage for the Dev scheme:

```bash
APP_PROJECT="EudiReferenceWallet.xcodeproj" \
APP_SCHEME="EUDI Wallet Dev" \
XCOV_EXCLUDE_TARGETS="EudiReferenceWalletIDProvider" \
bundle exec fastlane ios code_coverage
```

On Windows PowerShell:

```powershell
$env:APP_PROJECT = "EudiReferenceWallet.xcodeproj"
$env:APP_SCHEME = "EUDI Wallet Dev"
$env:XCOV_EXCLUDE_TARGETS = "EudiReferenceWalletIDProvider"
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
TESTFLIGHT_GROUPS="<tester-groups>" \
bundle exec fastlane ios deploy
```

## Production Notes

Before using Fastlane for production:

* Add a dedicated production scheme, for example `EUDI Wallet Prod`.
* Add production build configurations, for example `Debug Prod` and `Release Prod`.
* Add production `.xcconfig` files and a `PROD` app build variant.
* Update the lane or export options to include provisioning profile mappings for both the main app
  and the Identity Document Provider extension.
* Add secret scanning and demo-endpoint checks before upload.
* Archive the IPA, dSYM files, entitlements, provisioning profile metadata, dependency report, SBOM,
  signing certificate fingerprint, Git commit, and test reports.
* Store App Store Connect API keys, certificates, profiles, and passwords only in approved CI secret
  storage.
* Do not rely on TestFlight build numbers as the only source of production release numbering unless
  the release process explicitly approves it.

## Release Cautions

The current `deploy` lane mutates version and build number values, creates a Git tag, may push tags
to configured remotes, uploads to App Store Connect/TestFlight, and then resets project version
values. Run it only from a clean working tree and a controlled CI environment.

For production, ensure the pipeline fails if the archive contains:

```text
eudiw.dev
dev.wallet-provider
issuer.eudiw.dev
issuer-backend.eudiw.dev
somesecret
somesecret2
localhost
SelfSignedDelegate
rqes://oauth/callback
eu.europa.ec.euidi.dev
```

For the complete production release process, see [../wiki/go_live.md](../wiki/go_live.md).
