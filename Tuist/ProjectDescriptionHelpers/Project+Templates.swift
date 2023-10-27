import ProjectDescription

/// Project helpers are functions that simplify the way you define your project.
/// Share code to create targets, settings, dependencies,
/// Create your own conventions, e.g: a func that makes sure all shared targets are "static frameworks"
/// See https://docs.tuist.io/guides/helpers/

// MARK: - Private
let bundleIdPrefix = Environment.bundleIdPrefix.getString(default: "org.eudiw")
let organization = Environment.organization.getString(default: "EUDIW")
let env = Environment.environment.getString(default: "dev")
let teamIDs = ["dev": "5T7UHW36CL", "prod": "5T7UHW36CL"]
let iOSDeploymentTarget = Environment.iOSDeploymentTarget.getString(default: "16.0") 

extension Project {
    /// Helper function to create the Project for this ExampleApp
    public static func app(name: String, platform: Platform, additionalTargets: [String], packages: [Package], products: [String], testProducts: [String]) -> Project {
        var targets = makeAppTargets(name: name, platform: platform, dependencies: additionalTargets.map { TargetDependency.target(name: $0) } + products.map { TargetDependency.package(product: $0) }, testDependencies: testProducts.map { TargetDependency.package(product: $0) })
        targets += additionalTargets.flatMap({ makeFrameworkTargets(name: $0, platform: platform) })
        return Project(name: name, organizationName: organization, packages: packages, settings: projSett(), targets: targets, resourceSynthesizers: [])
    }
    static func projSett() -> Settings { Settings.settings(base:["ASSETCATALOG_COMPILER_APPICON_NAME": "AppIcon", "DEVELOPMENT_TEAM": .string(teamIDs[env]!)]) }
    static func targetSett(_ name: String) -> Settings { Settings.settings(base:["INFOPLIST_FILE": "\(name)/Info.plist", "STRIP_STYLE": "debugging"]) }
 
    /// Helper function to create a framework target and an associated unit test target
    private static func makeFrameworkTargets(name: String, platform: Platform) -> [Target] {
        let sources = Target(name: name,platform: platform, product: .framework, bundleId: "\(bundleIdPrefix).\(name)",
                deploymentTarget: .iOS(targetVersion: iOSDeploymentTarget,  devices: [.iphone]), 
                infoPlist: .default, sources: ["\(name)/Sources/**"], resources: [], dependencies: [])
        let tests = Target(name: "\(name)Tests", platform: platform, product: .unitTests,
                bundleId: "\(bundleIdPrefix).\(name)Tests", infoPlist: .default,
                sources: ["\(name)/Tests/**"], resources: [], dependencies: [.target(name: name)])
        return [sources, tests]
    }

    /// Helper function to create the application target and the unit test target.
    private static func makeAppTargets(name: String, platform: Platform, dependencies: [TargetDependency], testDependencies: [TargetDependency]) -> [Target] {
        let platform: Platform = platform
   
        let mainTarget = Target(
            name: name,
            platform: platform,
            product: .app,
            bundleId: "\(bundleIdPrefix).\(name)",
            deploymentTarget: .iOS(targetVersion: iOSDeploymentTarget,  devices: [.iphone]), 
            infoPlist: .file(path: "\(name)/Info.plist"),
            sources: ["\(name)/Sources/**"],
            resources: ["\(name)/Resources/**"],
            dependencies: dependencies,
            settings: targetSett(name)
        )

        let testTarget = Target(
            name: "\(name)Tests",
            platform: platform,
            product: .uiTests,
            bundleId: "\(bundleIdPrefix).\(name)Tests",
            infoPlist: .file(path: "\(name)/Tests/Info.plist"),
            sources: ["\(name)/Tests/Sources/**"],
            dependencies: testDependencies + [
                .target(name: "\(name)")
        ])

        let uiTestTarget = Target(
            name: "\(name)UITests",
            platform: platform,
            product: .uiTests,
            bundleId: "\(bundleIdPrefix).\(name)UITests",
            infoPlist: .file(path: "\(name)/UITests/Info.plist"),
            sources: ["\(name)/UITests/Sources/**"],
            dependencies: [
                .target(name: "\(name)")
        ])
        return [mainTarget, testTarget, uiTestTarget]
    }
}
