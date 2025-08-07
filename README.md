#  VAUXPrototype

[![License](https://img.shields.io/badge/license-Apache--2.0-blue.svg)](http://www.apache.org/licenses/LICENSE-2.0)
[![Build Status](https://github.com/valexa/VAUXPrototype/actions/workflows/main.yml/badge.svg)]

This is a UI components prototyping tool for to enable on device experimentation with the full nuances and edge cases of every UI piece as well as showcasing whenever possible customisation options available.
It also serves as a code repository for developers to store barebones implementations of common elements and behaviours.

While parts of the app are importing and using the UiKit framework this is largely a SwiftUI app and shuns legacy frameworks like Combine.framework as well in favour of the new async/await and the Observation framework whenever possible.

## License

The codebase unless otherwise noted is covered by the Apache 2.0 license, for full details see the LICENSE.txt and NOTICE.txt files

## Acknowledgements

This codebase contains portions of Apple sample code and freely available code from other source as noted in the respective files

## Web Credentials implementation

This codebase contains a Web Credentials implementation, the relevant settings are inside VAUXPrototype.entitlements and on external apple-app-site-association files

## Multitasking implementation

The main app is enabled for multitasking on iPadOS and MacOS, implicit multitasking window opening is implemented by means of `SwiftUI.OpenWindowAction` and `UIApplication.shared.requestSceneSessionActivation()` with `View.onContinueUserActivity(){}` for center windows 

![multitasking screenshot](https://github.com/valexa/VAUXPrototype/assets/96238834/ff335e24-43ee-44ef-b3e1-5d4cc171d0c4 "Multitasking")

## App clip implementation

Implements a functional App clip target that is referencing the entirety of the main app, the relevant settings are inside VAUXPrototype.entitlements and on external apple-app-site-association files

## App shortcuts implementation

Implements a functional App clip target that is referencing the entirety of the main app, the relevant settings are inside VAUXPrototype.entitlements and on external apple-app-site-association files
![shortcuts screenshot](https://github.com/valexa/VAUXPrototype/assets/96238834/6873ee90-e2e2-47db-9c9e-91b2ae3335fd "Shortcuts")


## SwiftData implementation

Currently just implements the default Apple template 

### Symbols list from: 
https://github.com/SFSafeSymbols/SFSafeSymbols/blob/stable/SymbolsGenerator/Sources/SymbolsGenerator/Resources/symbol_names.txt
#### Updated on November 16 2022

### Apple sample code
The APPLE_LICENSE.txt applies to certain files that are provided by Apple as sample code, this will be noted in the file header top licensing section.

