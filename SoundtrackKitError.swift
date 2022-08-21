//
//  SoundtrackKitError.swift
//  soundtrack
//
//  Created by Nalin Krishnan on 5/5/22.
//

import Foundation
import MusicKit

public enum SoundtrackKitError: Error, Equatable {
    case notFound(for: String)
    case typeMissing
    case recommendationOverLimit(for: Int)
    case historyOverLimit(limit: Int, overLimit: Int)
}

extension SoundtrackKitError: CustomStringConvertible {
    public var description: String {
        switch self {
            case .notFound(let id):
                return "The specified music item could not be found for \(id)."
            case .typeMissing:
                return "One or more types must be specified for fetching top results in search suggestions."
            case .recommendationOverLimit(let limit):
                return "Value must be an integer less than or equal to 30, but was: \(limit)."
            case .historyOverLimit(let limit, let overLimit):
                return "Value must be an integer less than or equal to \(limit), but was: \(overLimit)."
        }
    }
}

extension SoundtrackKitError: LocalizedError {
    public var errorDescription: String? {
        switch self {
            case .notFound(let id):
                return NSLocalizedString("The specified music item could not be found for \(id).",
                                         comment: "Resource Not Found")
            case .typeMissing:
                return NSLocalizedString("One or more types must be specified for fetching top results in search suggestions.",
                                         comment: "Missing Parameter")
            case .recommendationOverLimit(let limit):
                return NSLocalizedString("Value must be an integer less than or equal to 30, but was: \(limit).",
                                         comment: "Invalid Parameter Value")
            case .historyOverLimit(let limit, let overLimit):
                return NSLocalizedString("Value must be an integer less than or equal to \(limit), but was: \(overLimit).",
                                         comment: "Invalid Parameter Value")
        }
    }
}
