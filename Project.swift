import ProjectDescription
import ProjectDescriptionHelpers
let eudiPackageGitUrl = "https://github.com/eu-digital-identity-wallet/eudi-lib-ios-iso18013-data-transfer"
let packNames = [eudiPackageGitUrl]
let products = ["MdocDataTransfer18013"]

// MARK: - Packages
let packages: [Package] 
if Environment.isCI.getBoolean(default: true) {
       packages = packNames.map { Package.remote(url: "\($0)", requirement: .branch("develop")) }
} else {
        // for local development, use local packages
        packages = packNames.map { Package.local(path: .relativeToManifest("../\($0)")) }
}


// Creates our project using a helper function defined in ProjectDescriptionHelpers
let project = Project.app(name: "Iso18013HolderDemo", platform: .iOS, additionalTargets: [], packages: packages, products: products)
