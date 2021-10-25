//
// Copyright (c) Vatsal Manot
//

import Foundation
import Swift

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
