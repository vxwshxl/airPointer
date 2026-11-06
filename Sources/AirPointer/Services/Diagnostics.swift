import CoreMotion
import os

enum Diagnostics {
    /// View with: log stream --level info --predicate 'subsystem == "com.vxwshxl.airPointer"'
    static let log = Logger(subsystem: "com.vxwshxl.airPointer", category: "app")
}

extension CMAuthorizationStatus {
    var label: String {
        switch self {
        case .notDetermined: "not asked yet"
        case .restricted: "restricted"
        case .denied: "denied"
        case .authorized: "allowed"
        @unknown default: "unknown"
        }
    }
}
