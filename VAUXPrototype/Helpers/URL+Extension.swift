/*
See APPLE_LICENSE.txt for licensing information.

Abstract:
URL Extension to fetch location of files and folders used to persist App data
*/

import Foundation

/// The various files managed in the app.
enum FileType: String {
    /// Filename for saving Bookmarks data in the App
    case bookmark = "Bookmarks.data"
    /// Filename for saving Tags in the App
    case tag = "Tags.data"
    /// Filename for App Settings
    case setting = "Settings.data"
}

enum FolderType: String {
    case image = "Images"
    case pdf = "PDF"
}

extension URL {
    static func fileURL(for type: FileType) -> URL {
        return URL.documentsDirectory.appending(path: type.rawValue)
    }

    static func folderURL(for type: FolderType) throws -> URL {
        let fileManager = FileManager.default
        var url: URL

        let offlineDataDir = URL.documentsDirectory.appending(path: type.rawValue)

        try fileManager.createDirectory(
            at: offlineDataDir,
            withIntermediateDirectories: true,
            attributes: nil
        )
        url = offlineDataDir
        return url
    }
}
