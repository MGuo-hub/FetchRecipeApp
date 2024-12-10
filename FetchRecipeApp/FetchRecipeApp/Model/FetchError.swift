//
//  FetchError.swift
//  FetchRecipeApp
//
//  Created by Tinghe Guo on 12/10/24.
//
import Foundation


enum FetchError: Error {
    case invalidURL
    case serverError
    case malformedData
    case emptyData
    case unknown(Error)

    var userFriendlyMessage: String {
        switch self {
        case .invalidURL:
            return "We encountered an invalid URL. Please try again."
        case .serverError:
            return "We’re having trouble connecting to the server. Please try again later."
        case .malformedData:
            return "The data received is malformed. We cannot load recipes at this time."
        case .emptyData:
            return "No recipes found. Try refreshing to see if new recipes are available."
        case .unknown(let error):
            return "An unexpected error occurred: \(error.localizedDescription)"
        }
    }
}
