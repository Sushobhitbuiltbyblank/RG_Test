//
//  UserListRemoteProvider.swift
//  RG_Test
//
//  Created by Sushobhit.Jain on 17/01/21.
//


import Foundation

enum NetworkError: Error {
    case invalidURL
    case decodingFailed
    case informational
    case redirection
    case clientError
    case serverError
    case unknown
    
    func errordescription() -> String {
        switch self {
        case .invalidURL:
            return "Invalid Url"
        case .decodingFailed:
            return "Decoding fail"
        case .informational:
            return "Information provided not correct"
        case .redirection:
            return "Wrong Api redirection"
        case .clientError:
            return "Client side issue"
        case .serverError:
            return "Server not response"
        default:
            return "operation not able to perform at this time"
        }
    }
}
