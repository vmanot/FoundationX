//
// Copyright (c) Vatsal Manot
//

import Foundation
import Swallow

/// Shorthands for notable file locations.
///
/// Written to improve API ergonomics.
public enum NotableFileLocation {
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
