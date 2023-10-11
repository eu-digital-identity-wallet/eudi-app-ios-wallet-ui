# EUDI iOS Wallet reference application

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://www.apache.org/licenses/LICENSE-2.0)

## Table of contents

* [Overview](#overview)
* [Disclaimer](#disclaimer)
* [How to contribute](#how-to-contribute)
* [Creating a new feature module](#creating-a-new-feature-module)
* [SwiftUI Previews](#swiftui-previews)
* [License](#license)

## Overview

Comming soon...

## Disclaimer

The released software is a initial development release version: 
-  The initial development release is an early endeavor reflecting the efforts of a short timeboxed period, and by no means can be considered as the final product.  
-  The initial development release may be changed substantially over time, might introduce new features but also may change or remove existing ones, potentially breaking compatibility with your existing code.
-  The initial development release is limited in functional scope.
-  The initial development release may contain errors or design flaws and other problems that could cause system or other failures and data loss.
-  The initial development release has reduced security, privacy, availability, and reliability standards relative to future releases. This could make the software slower, less reliable, or more vulnerable to attacks than mature software.
-  The initial development release is not yet comprehensively documented. 
-  Users of the software must perform sufficient engineering and additional testing in order to properly evaluate their application and determine whether any of the open-sourced components is suitable for use in that application.
-  We strongly recommend to not put this version of the software into production use.
-  Only the latest version of the software will be supported

## How to contribute

We welcome contributions to this project. To ensure that the process is smooth for everyone
involved, follow the guidelines found in [CONTRIBUTING.md](CONTRIBUTING.md).

## Creating a new feature module

1. Create a new Swift package library in the Modules subdirectory. Please use the _feature-*{new-addition}*_ format; e.g. **feature-dashboard**
2. Add this package to the project by dragging it to the Packages directory in the project navigator in xcode.
3. Add **feature-common** as a dependency so you can take advantage of the existing codebase in your new feature.
4. Make sure the path in your target points to **./Sources**; **./Tests** for your test target.

If you want to gain access to the entire apps mock infrastructure (classes and structs), so you can leverage it in your unit tests, you can:

1. Add your new package to swiftlint to be ignored:
    - "Modules/feature-*new-addition*/Tests/*"
    - "Modules/feature-*new-addition*/.build/*"
2. Under your Test folder in you package add a Mock folder and place an empty file called GeneratedMocks.swift therein.
3. Edit *root*/Mock/GenerateMocks.sh, and append your package name to the FEATURE_MODULES variable.
4. run **./Mock/GenerateMocks.sh** from the project root.

## SwiftUI previews

As of xcode 15.0 preview for SwiftUI view that are located in local swift packages are not reliable.

We recommend using the main target for previews. Please Check **Previewer.swift** for an example that utilises our local package infrastructure to achieve previewing.

## License

### Third-party component

Coming soon....

### License details

Copyright (c) 2023 European Commission

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.