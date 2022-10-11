//
// Copyright (c) Vatsal Manot
//

import Foundation
import Swallow

/// Shorthands for standard file directories.
///
/// Written to improve API ergonomics.
public enum CanonicalFileDirectory {
    case iCloudDriveDocuments(ubiquityContainerIdentifier: String)
    case securityApplicationGroup(String)
    case ubiquityContainer(String)
    case userDocuments
    
    public func toURL() throws -> URL {
        switch self {
            case .iCloudDriveDocuments(let identifier):
                return try FileManager.default.url(forUbiquityContainerIdentifier: identifier).unwrap().appendingDirectoryPathComponent("Documents")
            case .securityApplicationGroup(let identifier):
                return try FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: identifier).unwrap()
            case .ubiquityContainer(let identifier):
                return try FileManager.default.url(forUbiquityContainerIdentifier: identifier).unwrap()
            case .userDocuments:
                return try FileManager.default.url(for: .documentDirectory, in: .userDomainMask)
        }
    }
}

extension CanonicalFileDirectory {
    /// Returns the first valid location of the two given operands.
    public static func || (lhs: Self, rhs: Self) -> Self {
        do {
            _ = try lhs.toURL()
            
            return lhs
        } catch {
            return rhs
        }
    }
}
