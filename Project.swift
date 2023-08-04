import ProjectDescription
import ProjectDescriptionHelpers
let eudiGitUrl = "https://github.com/eu-digital-identity-wallet/"
let packNames = ["eudi-lib-ios-iso18013-data-model", "eudi-lib-ios-iso18013-security", "eudi-lib-ios-iso18013-data-transfer"]
let products = ["MdocDataModel18013", "MdocSecurity18013", "MdocDataTransfer18013"]
// example call: TUIST_IS_CI=false tuist generate -n

// MARK: - Packages
let packages: [Package] 
if Environment.isCI.getBoolean(default: true) {
       packages = packNames.map { Package.remote(url: "\(eudiGitUrl)\($0)", requirement: .branch("develop")) }
} else {
        // for local development, use local packages
        packages = products.map { Package.local(path: .relativeToManifest("../\($0)")) }
}


// Creates our project using a helper function defined in ProjectDescriptionHelpers
let project = Project.app(name: "Iso18013HolderDemo", platform: .iOS, additionalTargets: [], packages: packages, products: products)
