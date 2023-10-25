import ProjectDescription
import ProjectDescriptionHelpers
let eudiGitUrl = "https://github.com/eu-digital-identity-wallet/"
let packNames = ["eudi-lib-ios-wallet-kit"]
let products = ["EudiWalletKit", "CodeScanner"]
// example call: TUIST_IS_CI=false tuist generate -n
let thirdPartyPackages = ["https://github.com/twostraws/CodeScanner.git"]
let testPackages = [Package.remote(url: "https://github.com/birdrides/mockingbird.git", requirement: .branch("master"))] 
// MARK: - Packages
var packages: [Package] 
if Environment.isCI.getBoolean(default: true) {
       packages = packNames.map { Package.remote(url: "\(eudiGitUrl)\($0)", requirement: .branch("develop")) } + thirdPartyPackages.map { Package.remote(url: $0, requirement: .branch("main"))}  + testPackages 
} else {
        // for local development, use local packages
        packages = products.map { Package.local(path: .relativeToManifest("../\($0)")) } + testPackages
}

// Creates our project using a helper function defined in ProjectDescriptionHelpers
let project = Project.app(name: "Iso18013HolderDemo", platform: .iOS, additionalTargets: [], packages: packages, products: products, testProducts: ["Mockingbird"])
