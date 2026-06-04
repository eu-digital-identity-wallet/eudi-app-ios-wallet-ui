# Theming and branding guide

This guide explains how an integrator rebrands and rethemes the iOS reference application — changing
colors, fonts, shapes, logos, the app icon, the app name, and the splash screen — and how to verify
the result.

It expands the short [Theme configuration](CONFIGURATION.md#theme-configuration) summary in the main
configuration document.

## Table of contents

* [Architecture overview](#architecture-overview)
* [Quick-start rebrand checklist](#quick-start-rebrand-checklist)
* [Colors](#colors)
* [Typography and fonts](#typography-and-fonts)
* [Shapes](#shapes)
* [Dimensions and spacing](#dimensions-and-spacing)
* [Logos and in-app imagery](#logos-and-in-app-imagery)
* [App icon](#app-icon)
* [App name and bundle identity](#app-name-and-bundle-identity)
* [Brand strings](#brand-strings)
* [Splash screen](#splash-screen)
* [Status bar and toolbars](#status-bar-and-toolbars)
* [Sub-SDK theming (RQES)](#sub-sdk-theming-rqes)
* [Advanced: programmatic and white-label theming](#advanced-programmatic-and-white-label-theming)
* [Verifying your rebrand](#verifying-your-rebrand)
* [Production and accessibility checklist](#production-and-accessibility-checklist)

## Architecture overview

Branding is split across **three layers** — make sure you address all three when rebranding. The
[Theme configuration](CONFIGURATION.md#theme-configuration) summary in the configuration document
links here for the full detail.

| Layer | What it covers | Where it lives |
| --- | --- | --- |
| 1. SwiftUI theme | Colors, typography/fonts, shapes, dimensions, in-app images | `logic-resources` module (`Theme`/`ThemeManager`, `ThemeConfiguration`, the five managers) |
| 2. Branding assets | App icon, app display name, bundle id, splash/launch screen, deep-link schemes, brand strings | `Wallet/` app target (`project.pbxproj`, `Assets.xcassets`, `Wallet.plist`, `Config/*.xcconfig`) + `logic-resources` images/strings |
| 3. Sub-SDK theming | The RQES signing UI carries its own theme and translations | `logic-business` (`RQESConfig`) |

### The SwiftUI theme: `ThemeManager`

Every themeable aspect follows a **protocol + manager** pattern (the iOS analog of Android's
*template + values*):

* a **protocol** describes the *shape* of the data (e.g.
  [`ColorManagerProtocol`](../Modules/logic-resources/Sources/Manager/ColorManager.swift));
* a **manager** holds the *actual* reference values (e.g. `ColorManager`), resolving them from the
  asset catalogs / system at runtime.

The five managers — `color`, `image`, `shape`, `font`, `dimension` — are bundled by
[`ThemeConfiguration`](../Modules/logic-resources/Sources/Manager/ThemeConfiguration.swift) and
exposed through [`AppTheme`](../Modules/logic-resources/Sources/Theme/AppTheme.swift). The whole theme
is reachable from anywhere as the global singleton `Theme.shared` (where
[`Theme`](../Modules/logic-resources/Sources/Manager/ThemeManager.swift) is a typealias for
`ThemeManager`):

```swift
Theme.shared.color.accent
Theme.shared.font.titleLarge        // a TypographyStyle (font + spacing)
Theme.shared.shape.small
Theme.shared.image.logo
Theme.shared.dimension.padding
```

> **Important — how the theme is initialized.**
> The application uses the global `Theme.shared`, which defaults to `AppTheme()` built from
> the reference managers (`ColorManager`, `ImageManager`, `ShapeManager`, `TypographyManager`,
> `DimensionManager`). Those managers read their values from the **asset catalogs** in
> `logic-resources` and from system defaults.
>
> So for a normal rebrand you **edit the asset catalogs** (colors, images) and, for fonts, add a
> `WalletFontConfig.plist` — no Swift code changes are required. There is a hook,
> `Theme.config(themeConfiguration:)`, that swaps the whole theme at startup; it is only needed for
> advanced/white-label scenarios — see
> [Advanced: programmatic and white-label theming](#advanced-programmatic-and-white-label-theming).

### Light, dark, and adaptive color

* Colors resolve from **asset catalog colorsets that carry separate light and dark appearances**, and
  from **UIKit adaptive system colors**. Dark mode therefore follows the system setting automatically.
  Always rebrand **both** appearances of every colorset you add or edit.
* There is no Material-You-style "dynamic color." Your brand colors are always used.

### Shared vs. per-variant

The project ships two build variants, `Dev` and `Demo` (`BUILD_VARIANT` in
[`Wallet/Config/*.xcconfig`](../Wallet/Config); see [HOW_TO_BUILD.md](HOW_TO_BUILD.md)).

* SwiftUI theme values (colors, shapes, type scale) and in-app images live in **`logic-resources`** →
  shared by all variants. Change once.
* The **app icon** is selected **per variant** (`AppIcon` for Demo, `AppIconDev` for Dev). Change it
  for every variant you ship.
* The **display name** and **bundle id** are per build configuration in `project.pbxproj`.

## Quick-start rebrand checklist

The minimum set of changes for a full rebrand. Each row links to its detailed section below.

| Brand element | Where to change it | Notes |
| --- | --- | --- |
| Brand accent color | Add an `accent` colorset to [`Color.xcassets`](../Modules/logic-resources/Sources/Resources/Color.xcassets) | Highest-impact color: tab tint + prominent buttons. Currently falls back to system blue. See [Colors](#colors). |
| Brand colors | Edit colorsets in [`Color.xcassets`](../Modules/logic-resources/Sources/Resources/Color.xcassets) (`success`, `warning`, `pending`, `groupedBackground`, …) | Light **and** dark appearances. See [Colors](#colors). |
| Override system/semantic colors | Add a colorset named exactly after the role (e.g. `background`, `primaryLabel`) | Catalog entry wins over the system color. See [Colors](#colors). |
| Fonts | Drop font files into [`logic-resources/Sources/Resources/`](../Modules/logic-resources/Sources/Resources) + add `WalletFontConfig.plist` | Default is the **system font**. See [Typography and fonts](#typography-and-fonts). |
| Corner shapes | [`ShapeManager.swift`](../Modules/logic-resources/Sources/Manager/ShapeManager.swift) | See [Shapes](#shapes). |
| In-app logos | Replace imagesets in [`Images.xcassets`](../Modules/logic-resources/Sources/Resources/Images.xcassets) (`logo`, `EUDI-text`, …) | Keep the imageset names. See [Logos](#logos-and-in-app-imagery). |
| App icon | [`Wallet/Assets.xcassets`](../Wallet/Assets.xcassets) — `AppIcon` **and** `AppIconDev` | One per variant. See [App icon](#app-icon). |
| App display name | `INFOPLIST_KEY_CFBundleDisplayName` in `project.pbxproj` | "EUDI Wallet" by default. See [App name](#app-name-and-bundle-identity). |
| Bundle id | `PRODUCT_BUNDLE_IDENTIFIER` in `project.pbxproj` | Don't change after public release. Keep the extension id aligned. |
| Splash (in-app) | `logo` imageset + `background` color | See [Splash screen](#splash-screen). |
| Splash (OS launch) | `INFOPLIST_KEY_UILaunchScreen_Generation` / a `UILaunchScreen` dict | See [Splash screen](#splash-screen). |
| Brand strings (product name in UI) | [`Localizable.xcstrings`](../Modules/logic-resources/Sources/Resources/Localizable.xcstrings) | Search for `EUDI`/`Wallet`. See [Brand strings](#brand-strings). |
| RQES signing UI | Optional `theme` override in [`RQESConfig`](../Modules/logic-business/Sources/Config/RQESConfig.swift) | Separate SDK theme; **not** overridden by default. See [Sub-SDK theming](#sub-sdk-theming-rqes). |

## Colors

### Where colors are defined

* **Protocol:**
  [`ColorManagerProtocol`](../Modules/logic-resources/Sources/Manager/ColorManager.swift) declares
  **37 color roles** in three groups.
* **Manager:** `ColorManager` resolves each role, with the asset catalog
  [`Color.xcassets`](../Modules/logic-resources/Sources/Resources/Color.xcassets) taking precedence
  over system colors where applicable.

The three groups:

| Group | Roles | How it resolves |
| --- | --- | --- |
| **Brand** (7) | `success`, `successBackground`, `pending`, `warning`, `groupedBackground`, `groupedElevatedBackground`, `separator` | **Always** loaded from the asset catalog by name. You must edit these colorsets. |
| **System palette** (15) | `blue`, `green`, `indigo`, `orange`, `pink`, `purple`, `red`, `teal`, `yellow`, `mint`, `cyan`, `brown`, `black`, `white`, `gray` | Catalog entry named after the role wins; otherwise the SwiftUI system color. |
| **Semantic** (15) | `primaryLabel`, `secondaryLabel`, `tertiaryLabel`, `quaternaryLabel`, `background`, `secondaryBackground`, `tertiaryBackground`, `secondaryGroupedBackground`, `tertiaryGroupedBackground`, `opaqueSeparator`, `fill`, `secondaryFill`, `tertiaryFill`, `quaternaryFill`, `accent` | Catalog entry named after the role wins; otherwise the UIKit adaptive color (`accent` → system blue). |

> **Two separators.** `separator` is a **brand** color (always from the catalog); `opaqueSeparator`
> is a **semantic** role (falls back to the UIKit separator). The visible hairline dividers across the
> UI use `separator`, so edit that one to recolor dividers.

### The override mechanism

For **system** and **semantic** colors, `ColorManager` looks up a colorset whose name matches the
role's name *first*, and only falls back to the system color when none exists:

```swift
// ColorManager.swift — simplified
func color(for semantic: SemanticColors) -> Color {
  if let catalogColor = catalogColor(named: semantic.rawValue) { return catalogColor }
  // …otherwise the UIKit adaptive color
}
```

So a member-state theme **only needs to add a colorset with the matching name** (e.g. `accent`,
`background`, `primaryLabel`) to override that role — no Swift changes. Brand colors are always read
from the catalog, so you edit those colorsets directly.

### How to change / add a color

Edit the colorset's `Contents.json` (or use Xcode's asset editor). Each colorset carries a universal
(light) appearance and a dark appearance; set **both**. Components may be decimal (`"143"`) or hex
(`"0x8F"`):

```json
{
  "colors" : [
    { "idiom" : "universal",
      "color" : { "color-space" : "srgb",
        "components" : { "alpha" : "1.000", "red" : "0x2C", "green" : "0x7E", "blue" : "0x0A" } } },
    { "idiom" : "universal",
      "appearances" : [ { "appearance" : "luminosity", "value" : "dark" } ],
      "color" : { "color-space" : "srgb",
        "components" : { "alpha" : "1.000", "red" : "0x93", "green" : "0xD8", "blue" : "0x75" } } }
  ],
  "info" : { "author" : "xcode", "version" : 1 }
}
```

In Xcode you don't edit this JSON by hand: select the colorset, open the **Attributes inspector**, set
**Appearances** to **Any, Dark**, and choose the two colors. If you set only the "Any" appearance, dark
mode keeps using your light color.

### The accent color (do this first)

`Theme.shared.color.accent` is the single highest-impact brand color — it tints the dashboard tab bar
and prominent buttons. There is **no `accent` colorset by default**, so it currently falls back to the
system blue. **Add an `accent` colorset** to `Color.xcassets` to brand it.

Separately, SwiftUI's app-wide `.tint`/`.accentColor` comes from the **app target's** empty
`AccentColor` colorset in [`Wallet/Assets.xcassets`](../Wallet/Assets.xcassets)
(`ASSETCATALOG_COMPILER_GLOBAL_ACCENT_COLOR_NAME = AccentColor`). Fill it in too for consistency.

> **Gotcha — the `Base/` palette overrides system colors.** The `Base/` folder inside `Color.xcassets`
> is **not** namespaced, so its `blue`, `black`, `white`, and `red` colorsets override the SwiftUI
> system colors of the same name (e.g. `Theme.shared.color.blue` is the bundled navy `#1A438F`, not
> system blue). The catalog also ships `grey`/`darkGrey`, which are not exposed by `ColorManager`.

## Typography and fonts

### Default: the system font

The reference app **bundles no fonts and renders the system font (San Francisco)**. The type scale
resolves every role to `Font.system(textStyle)`, which gives you Dynamic Type for free. If the system
font is acceptable for your brand, there is nothing to do here.

### The type scale

[`TypographyManager`](../Modules/logic-resources/Sources/Manager/TypographyManager.swift) exposes 15
roles, each a `TypographyStyle` (a `font` plus letter `spacing`/tracking, currently `0`). Each role
maps to a **weight key** (`bold` / `medium` / `regular`) and a SwiftUI `Font.TextStyle` whose
`defaultSize` is the base point size that scales with Dynamic Type:

| Role | Weight key | Text style | Default size |
| --- | --- | --- | --- |
| `displayLarge` / `displayMedium` / `displaySmall` | `bold` | `largeTitle` / `title` / `title2` | 34 / 28 / 22 |
| `headlineLarge` / `headlineMedium` / `headlineSmall` | `medium` | `title3` / `headline` / `subheadline` | 20 / 17 / 15 |
| `titleLarge` / `titleMedium` / `titleSmall` | `medium` | `title` / `title2` / `title3` | 28 / 22 / 20 |
| `bodyLarge` / `bodyMedium` / `bodySmall` | `regular` | `body` / `callout` / `footnote` | 17 / 16 / 13 |
| `labelLarge` / `labelMedium` / `labelSmall` | `medium` / `regular` / `regular` | `headline` / `caption` / `caption2` | 17 / 12 / 11 |

Styles are applied to text with the `typography(_:)` modifier from
[`Text+Extensions.swift`](../Modules/logic-resources/Sources/Extension/Text+Extensions.swift):

```swift
Text("Hello").typography(Theme.shared.font.titleLarge)
```

### Using a custom font

Two independent things must happen: the font files must be **registered** (so the system can find
them) and the type scale must be **told to use them**. Registration is automatic; the plist is only
the mapping.

1. **Drop your font files** (`.ttf`/`.otf`) into
   [`logic-resources/Sources/Resources/`](../Modules/logic-resources/Sources/Resources). They are
   registered with Core Text automatically at startup by `Bundle.registerModuleFonts()` (see
   [`Bundle.swift`](../Modules/logic-resources/Sources/Bundle.swift), called from
   `ThemeConfiguration.init`) — **no `Info.plist`/`UIAppFonts` entry, and no manual registration, is
   needed.**
2. **Add a `WalletFontConfig.plist`** to the same `Resources/` directory, mapping the three weight
   keys to the **exact PostScript names** of your fonts:

   ```xml
   <?xml version="1.0" encoding="UTF-8"?>
   <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
   <plist version="1.0">
   <dict>
       <key>bold</key>    <string>YourBrand-Bold</string>
       <key>medium</key>  <string>YourBrand-Medium</string>
       <key>regular</key> <string>YourBrand-Regular</string>
   </dict>
   </plist>
   ```

   Only these three keys are consumed. A missing, empty, or misspelled name **falls back silently to
   the system font** (`Font.custom` does not crash). Find PostScript names in Font Book (not the file
   name — the internal PostScript name).

The plist does **not** register fonts — step 1 already did; it only selects which registered font the
type scale uses. If you drop fonts but omit the plist, they are registered yet unused and the UI stays
on the system font. The plist is a flat `[String: String]` with exactly those three keys and needs
**no `Package.swift` change** — SwiftPM's `.process("Resources")` rule bundles it automatically. To
change which weight a *role* uses (e.g. a lighter body), edit the `style(...)` mappings in
`TypographyManager.swift`.

## Shapes

Corner radii come from
[`ShapeManager`](../Modules/logic-resources/Sources/Manager/ShapeManager.swift), exposed as `CGFloat`
points:

```swift
none = 0, extraSmall = 8, small = 16, medium = 18, large = 20,
extraLarge = 24, xxLarge = 32, xxxLarge = 48, xxxxLarge = 56, full = .infinity
```

The same file also exposes three `AnyShape` helpers used by components — `lowCornerRadius`
(rounded 16, inset −4), `highCornerRadiusShape` (rounded 20, inset −4), and `capsuleShape`. If you
change the base radii, review those helpers too.

## Dimensions and spacing

The theme's dimension support is intentionally minimal.
[`DimensionManager`](../Modules/logic-resources/Sources/Manager/DimensionManager.swift) carries four
values:

```swift
padding = 16, smallImageHeight = 50, verifiedBadgeSpacing = 5, remoteImageIconSize = 50
```

`Theme.shared.dimension.padding` is the shared screen/content padding. Most other spacing and sizing
is expressed inline in the SwiftUI components (and via `ShapeManager` radii), not centralized here, so
treat the dimension manager as the small set of global measurements rather than a full spacing scale.

## Logos and in-app imagery

[`ImageManager`](../Modules/logic-resources/Sources/Manager/ImageManager.swift) exposes ~60 image
roles. They come from **two sources**, and only one is brandable:

* **Bundled imagesets** (`Image(name, bundle:)`) in
  [`Images.xcassets`](../Modules/logic-resources/Sources/Resources/Images.xcassets) — **these are your
  brand assets.**
* **SF Symbols** (`Image(systemName:)`) — system iconography (chevrons, checkmarks, gear, …), not
  brand-specific.

The brand logos and key illustrations (bundled imagesets):

| `ImageManager` role | Imageset | Where it appears |
| --- | --- | --- |
| `logo` | `logo` (`ic-logo-2.svg`) | [Splash screen](#splash-screen) and content headers |
| `euditext` | `EUDI-text` | Wordmark next to the logo |
| `logoEuDigitalIndentityWallet` | `logo-eu-digital-indentity-wallet` | Branded headers |
| `homeIdentity`, `homeContract`, `successSecuredWallet`, `digitalIdIssuance`, `chooseDocumentImage`, `scanDocumentImage`, … | matching imagesets | Onboarding / dashboard / success illustrations |

### How to swap them

Replace the asset contents in `Images.xcassets`, **keeping the imageset name** so the `ImageManager`
mapping and all call sites keep working. The reference `logo` is a single-scale vector (SVG with
"preserve vector data"). When you replace it, keep **Single Scale** + **Preserve Vector Data** enabled
for a vector — or supply `@1x`/`@2x`/`@3x` rasters — so it stays crisp at the `screenWidth / 2.5`
splash size.

To change the **functional** iconography (the SF Symbols), edit the `ImageEnum` raw values in
`ImageManager.swift` (e.g. point `menuIcon` at a different symbol or a bundled imageset).

## App icon

The app icon is selected **per build variant** via the `ASSETCATALOG_COMPILER_APPICON_NAME` build
setting (Xcode → target → Build Settings, per configuration):

* `AppIcon` — used by the **Demo** configurations
* `AppIconDev` — used by the **Dev** configurations

Both live in [`Wallet/Assets.xcassets`](../Wallet/Assets.xcassets) as single 1024×1024 app-icon sets.
Replace **both** (and any extra variant you add). The easiest path is Xcode's asset-catalog app-icon
editor.

## App name and bundle identity

### Display name

The name under the icon is the `CFBundleDisplayName`, set as an Xcode **build setting** (target →
Build Settings, per configuration — you don't hand-edit `project.pbxproj`):

```
INFOPLIST_KEY_CFBundleDisplayName = "EUDI Wallet"
```

It is the same across all four configurations (Debug/Release × Dev/Demo) by default. Change it for
your brand. For a **localized** name, add `CFBundleDisplayName` to per-locale `InfoPlist.strings`
files — a value there overrides the build-setting value at runtime (the build setting feeds the
generated `Info.plist`; `InfoPlist.strings` localizes it).

> The **ID Provider extension** has its own display name
> (`INFOPLIST_KEY_CFBundleDisplayName = EudiReferenceWalletIDProvider`), surfaced by the OS in the
> document-provider UI. Rename it too when you rebrand the product.

### Bundle identifier

`PRODUCT_BUNDLE_IDENTIFIER` is set per configuration as a build setting (target → Build Settings, or
the Signing & Capabilities pane):

| Variant | Main app | ID Provider extension |
| --- | --- | --- |
| Demo | `eu.europa.ec.euidi` | `eu.europa.ec.euidi.EudiReferenceWalletIDProvider` |
| Dev | `eu.europa.ec.euidi.dev` | `eu.europa.ec.euidi.dev.EudiReferenceWalletIDProvider` |

Use a reverse-DNS id you own (e.g. `eu.example.wallet`). The extension id must stay a child of the
main app id, and the **App Group / keychain access group** must stay aligned with it — see the
[Document Provider extension configuration](CONFIGURATION.md#document-provider-extension-configuration)
section. **Do not change the bundle id after public release** unless you intend to publish a separate
app (see [Production configuration reference](CONFIGURATION.md#production-configuration-reference)).

## Brand strings

The product name appears in user-facing copy as well as the launcher label. These live in
[`Localizable.xcstrings`](../Modules/logic-resources/Sources/Resources/Localizable.xcstrings), **not**
in the theme. If you rename the product, search the catalog for `EUDI`/`Wallet` and review at least:

* `quick_pin_set_title` ("Welcome to your wallet"), `quick_pin_set_success` and
  `quick_pin_set_step_one_caption` — onboarding / PIN-setup copy.
* `my_eu_wallet` ("My EU Wallet") — side-menu / navigation title.
* `wallet_is_secured` ("Your wallet is secured!") — success copy.
* `login_caption` / `login_caption_quick_pin_only` ("…access the EUDI Wallet…") — login auth prompts.
* `add_document_subtitle`, `add_documents_to_wallet`, `issuer_want_wallet_addition`,
  `request_data_no_document` — issuance/presentation copy.

Keep the launcher label ([App name](#app-name-and-bundle-identity)) and these in-copy names
consistent.

## Splash screen

There are two distinct pieces:

1. **OS launch screen** — the reference app uses Xcode's generated launch screen
   (`INFOPLIST_KEY_UILaunchScreen_Generation = YES`), which is effectively a blank screen on the
   system background shown before SwiftUI draws. To show a branded launch screen, **set
   `INFOPLIST_KEY_UILaunchScreen_Generation = NO`** and provide your own — either a `UILaunchScreen`
   dictionary (`UIImageName` for a centered image + `UIColorName` for the background) or a launch
   storyboard. While generation stays `YES`, any `UILaunchScreen` keys you add are ignored.

2. **In-app splash** —
   [`StartupView`](../Modules/feature-startup/Sources/UI/StartupView.swift) renders
   `Theme.shared.image.logo` centered (width = `screenWidth / 2.5`) on the
   `Theme.shared.color.background` color (simplified — the real view nests this in a `ZStack` that
   ignores safe-area insets):

   ```swift
   ContentScreenView(padding: .zero, canScroll: false, background: Theme.shared.color.background) {
     Theme.shared.image.logo
       .resizable()
       .aspectRatio(contentMode: .fit)
       .frame(width: screenWidth / 2.5)
   }
   ```

   Rebranding the `logo` imageset and (optionally) adding a `background` colorset updates it
   automatically.

## Status bar and toolbars

The app is SwiftUI-only, so the status bar adapts to light/dark automatically. Per-screen navigation
toolbar backgrounds are theme-driven via a route→color map in
[`ConfigUiLogic`](../Modules/logic-ui/Sources/Config/ConfigUiLogic.swift)
(`backgroundColorForScreenDictionary`, typed as
[`UIConfig.ToolBar`](../Modules/logic-ui/Sources/Config/UIConfig.swift)); the dashboard and document
details use `Theme.shared.color.background`. Add or change entries there to brand a screen's toolbar.

## Sub-SDK theming (RQES)

The remote qualified electronic signature (RQES) flow is provided by a separate UI SDK. It carries
its **own** theme and translations, exposed by the SDK's `EudiRQESUiConfig` protocol and supplied by
the wallet's [`RQESConfig`](../Modules/logic-business/Sources/Config/RQESConfig.swift). Both `theme`
and `translations` are **optional** protocol members with SDK-provided defaults:

```swift
// EudiRQESUiConfig (RQES UI SDK) — theme/translations are optional overrides:
var translations: [String: [LocalizableKey: String]] { get }  // defaults to [:] (English)
var theme: ThemeProtocol { get }                               // defaults to the SDK theme
```

The wallet's `RQESConfig` declares neither, so it inherits both SDK defaults.

The reference app leaves both `theme` and `translations` at their SDK defaults — the RQES flow is
**not** rethemed by the wallet. Consequences:

* As of RQES UI SDK **0.4.2**, the SDK's default theme follows the **same model as the wallet's
  SwiftUI theme** (Layer 1): iOS **system colors** (`primaryLabel`, `secondaryLabel`, `background`,
  `accent`) with only a few brand colors baked into its asset catalog (`success`, `successBackground`,
  `groupedBackground`, `black`), the **system font**, and native prominent buttons tinted with
  `accent` (system blue by default). Out of the box the signing screens match the unmodified wallet's
  system-based look and adapt to light/dark automatically.
* Because the two themes are independent, **rebranding the wallet does not restyle the RQES screens** —
  they keep the SDK default look (notably the system-blue `accent`) until you set `RQESConfig.theme`.

If you want the signing flow to match your brand, set `theme` in `RQESConfig` with a custom
`ThemeProtocol`. Since 0.4.2 its `ColorManagerProtocol` mirrors a subset of the wallet's color
roles — `black`, `white`, `success`, `successBackground`, `groupedBackground`, `primaryLabel`,
`secondaryLabel`, `background`, `accent` — and its `TypographyManagerProtocol` exposes the same type
scale (`displayLarge` … `labelSmall`); point these at the same values your wallet theme uses. If you
also need localized RQES strings, set `translations` as well. See the RQES subsection under
[General configuration](CONFIGURATION.md#general-configuration) for how `RQESConfig` is wired per
variant.

## Advanced: programmatic and white-label theming

**Most integrators don't need this.** Because you own `logic-resources`, the simplest rebrand is to
edit the values in place — colorsets and images in the asset catalogs, fonts via
`WalletFontConfig.plist`, and the constants in `ShapeManager`/`DimensionManager`. Reach for the
programmatic seam below only when the theme must be chosen **at runtime** (e.g. a white-label binary
that switches brand on the fly) or **fetched remotely** at launch.

The theme is swapped through `Theme.config(themeConfiguration:)`, which replaces `Theme.shared`. Build
a [`ThemeConfiguration`](../Modules/logic-resources/Sources/Manager/ThemeConfiguration.swift)
overriding only the managers you want — each parameter defaults to the reference implementation, and
the manager *protocols* (`ColorManagerProtocol`, `TypographyManagerProtocol`, …) are public, so you
pass your own conformances. Register it where `ConfigUiLogic` is constructed in
[`LogicUiAssembly`](../Modules/logic-ui/Sources/DI/LogicUiAssembly.swift):

```swift
// LogicUiAssembly.swift
container.register(ConfigUiLogic.self) { _ in
  ConfigUiLogicImpl(themeConfiguration: .init(color: MyColorManager())) // was: .default
}
```

`ConfigUiLogicImpl.init(themeConfiguration:)` calls `Theme.config(...)`, which runs during
`Application.init()` (resolving `RouterHost` forces `ConfigUiLogic`), so the swap lands before the
first frame. `ThemeConfiguration.init` is `public` for exactly this purpose. This is the iOS analog of
Android's `ThemeManager.Builder`, and is intentionally left at `.default` in the reference app.

> For a fully dynamic swap you can also assign `Theme.shared` directly — it is a `public` settable var
> of the public `ThemeProtocol`. Note that `Application`'s `toolbarConfig` **stored-property
> initializer** ([`Wallet/Application.swift`](../Wallet/Application.swift)) reads `Theme.shared`
> *before* any statement in `Application.init()` runs, so a direct assignment in `init()` cannot beat
> that first read — it's harmless (the initial value is overwritten after the swap), but it means the
> `ThemeConfiguration`/DI path above is preferable: it runs during `Application.init()` (resolving
> `RouterHost` forces `ConfigUiLogic`), so the final `toolbarConfig` and every view body read the
> swapped theme.

## Verifying your rebrand

* **SwiftUI previews.** `ColorManager.swift` ships a `ColorsPreview` that renders every system, brand,
  and semantic role — use it to eyeball your palette. Many components have their own `#Preview`.
* **Run both appearances.** Toggle system dark mode and confirm both colorset appearances look correct.
* **Run both variants.** Build `Dev` and `Demo` and confirm the app icon is correct for each (the
  display name is shared by default).
* **Screenshot the key surfaces:** splash, dashboard/home, a presentation request, the PIN screen,
  document details, and the RQES signing flow.

## Production and accessibility checklist

* [ ] Light **and** dark appearances set for every brand colorset and every system/semantic override.
* [ ] `accent` colorset added (and the app-target `AccentColor` filled in).
* [ ] Text/background color pairs meet contrast guidance (WCAG AA: 4.5:1 for body text).
* [ ] All brand imagesets replaced (`logo`, `EUDI-text`, illustrations); no leftover EUDI artwork.
* [ ] App icon replaced for **every** variant (`AppIcon` and `AppIconDev`); legible at small sizes.
* [ ] App display name set; localized if you ship multiple locales.
* [ ] Brand strings in `Localizable.xcstrings` reviewed (onboarding, side menu, auth prompts).
* [ ] `PRODUCT_BUNDLE_IDENTIFIER` set to an id you own and final before public release; extension id and
      App Group/keychain group aligned.
* [ ] Splash (OS launch + in-app) shows your brand.
* [ ] Fonts: if using a custom font, PostScript names in `WalletFontConfig.plist` are correct and
      Dynamic Type verified; otherwise the system font is a deliberate choice.
* [ ] RQES signing flow reviewed — either matching your brand (if you set `RQESConfig.theme`) or with
      the SDK default deemed acceptable.
* [ ] No demo/dev branding, trust anchors, or endpoints left in the production build — see
      [GO_LIVE.md](GO_LIVE.md).
