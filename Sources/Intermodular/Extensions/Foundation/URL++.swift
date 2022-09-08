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
    public subscript(keys: Set<URLResourceKey>) -> Result<URLResourceValues, Error> {
        .init(try resourceValues(forKeys: keys))
    }
    
    public subscript(key: URLResourceKey) -> Result<URLResourceValues, Error> {
        self[[key]]
    }

    public mutating func setResourceValues(_ body: (inout URLResourceValues) throws -> Void) throws {
        var values = URLResourceValues()
        
        try body(&values)
        
        try setResourceValues(values)
    }
}

extension URL {
    public static var userDocuments: URL! {
        try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask)
    }

    public static func securityAppGroupContainer(for identifier: String) throws -> URL {
        try FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: identifier).unwrap()
    }
}
