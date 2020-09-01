//
// Copyright (c) Vatsal Manot
//

import Foundation
import Swift

extension FileManager.SearchPathDirectory: CaseIterable {
    public static let allCases: [Self] = [
        .applicationDirectory,
        .demoApplicationDirectory,
        .developerApplicationDirectory,
        .adminApplicationDirectory,
        .libraryDirectory,
        .developerDirectory,
        .userDirectory,
        .documentationDirectory,
        .documentDirectory,
        .coreServiceDirectory,
        .desktopDirectory,
        .cachesDirectory,
        .applicationSupportDirectory,
        .allLibrariesDirectory,
        .trashDirectory,
        .autosavedInformationDirectory,
        .downloadsDirectory,
        .inputMethodsDirectory,
        .moviesDirectory,
        .musicDirectory,
        .picturesDirectory,
        .printerDescriptionDirectory,
        .sharedPublicDirectory,
        .preferencePanesDirectory,
        .itemReplacementDirectory,
    ]
}
