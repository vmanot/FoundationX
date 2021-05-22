//
// Copyright (c) Vatsal Manot
//

import Foundation
import Swallow

extension URL {
    public init?(bundle: Bundle, fileName: String, extension: String?) {
        guard let url = bundle.url(forResource: fileName, withExtension: `extension`) else {
            return nil
        }
        
        self = url
    }
    
    public init?(bundle: Bundle, fileName: String, withOrWithoutExtension `extension`: String) {
        guard let url = URL(bundle: bundle, fileName: fileName, extension: `extension`) ?? URL(bundle: bundle, fileName: fileName, extension: nil) else {
            return nil
        }
        
        self = url
    }
}

extension URL {
    /// The portion of a URL relative to a given base URL.
    public func relativeString(relativeTo baseURL: URL) -> String {
        TODO.whole(.addressEdgeCase, .refactor)

        if absoluteString.hasPrefix(baseURL.absoluteString) {
            return absoluteString
                .dropPrefixIfPresent(baseURL.absoluteString)
                .dropPrefixIfPresent("/")
        } else if let host = baseURL.url.host, absoluteString.hasPrefix(host) {
            return absoluteString
                .dropPrefixIfPresent(host)
                .dropPrefixIfPresent("/")
        } else {
            return relativeString
        }
    }
}

extension URL {
    public func appendingDirectoryPathComponent(_ pathComponent: String) -> URL {
        appendingPathComponent(pathComponent, isDirectory: true)
    }
}

extension URL {
    public mutating func setResourceValues(_ body: (inout URLResourceValues) throws -> Void) throws {
        var values = URLResourceValues()
        
        try body(&values)
        
        try setResourceValues(values)
    }
}
