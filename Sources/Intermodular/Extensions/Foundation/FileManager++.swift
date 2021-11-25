//
// Copyright (c) Vatsal Manot
//

import Foundation
import Swift

extension FileManager {
    public func fileExists(at url: URL) -> Bool {
        fileExists(atPath: url.path)
    }

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
    
    public func contents(of url: URL) throws -> Data {
        try contents(atPath: url.path).unwrap()
    }
    
    public func setContents(
        of url: URL,
        to data: Data,
        createDirectoriesIfNecessary: Bool = true
    ) throws {
        if createDirectoriesIfNecessary {
            if fileExists(atPath: url.deletingLastPathComponent().path) {
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
