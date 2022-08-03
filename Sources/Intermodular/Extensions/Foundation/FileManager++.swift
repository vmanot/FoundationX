//
// Copyright (c) Vatsal Manot
//

import Foundation
import System
import Swift

extension FileManager {
    /// Returns a Boolean value that indicates whether a file or directory exists at a specified URL.
    public func fileExists(at url: URL) -> Bool {
        fileExists(atPath: url.path)
    }

    /// Returns a Boolean value that indicates whether a directory exists at a specified URL.
    public func directoryExists(at url: URL) -> Bool {
        var isFolder: ObjCBool = false

        fileExists(atPath: url.path, isDirectory: &isFolder)

        if isFolder.boolValue {
            return true
        } else {
            return false
        }
    }
}

extension FileManager {
    public func contents(of url: URL) throws -> Data {
        try contents(atPath: url.path).unwrap()
    }

    public func contentsOfDirectory(at url: URL) throws -> [URL] {
        try contentsOfDirectory(at: url, includingPropertiesForKeys: [])
    }

    @available(macOS 11.0, iOS 14.0, watchOS 7.0, tvOS 14.0, *)
    public func contentsOfDirectory(at path: FilePath) throws -> [URL] {
        try contentsOfDirectory(at: URL(path).unwrap(), includingPropertiesForKeys: [])
    }

    public func setContents(
        of url: URL,
        to data: Data,
        createDirectoriesIfNecessary: Bool = true
    ) throws {
        if createDirectoriesIfNecessary {
            if directoryExists(at: url.deletingLastPathComponent()) {
                try data.write(to: url)
            } else {
                try createDirectory(at: url.deletingLastPathComponent(), withIntermediateDirectories: true, attributes: [:])
                
                try data.write(to: url)
            }
        } else {
            try data.write(to: url)
        }
    }
}

extension FileManager {
    public func url(
        for directory: SearchPathDirectory,
        in domainMask: SearchPathDomainMask
    ) throws -> URL {
        enum ResolutionError: Error {
            case noURLFound
            case foundMultipleURLs
        }

        let urls = urls(for: directory, in: domainMask)

        guard let result = urls.first else {
            throw ResolutionError.noURLFound
        }

        guard urls.count == 1 else {
            throw ResolutionError.foundMultipleURLs
        }

        return result
    }
}
