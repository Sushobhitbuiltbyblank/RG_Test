//
//  UserListRemoteProvider.swift
//  RG_Test
//
//  Created by Sushobhit.Jain on 17/01/21.
//


import Foundation
typealias completionBlock = (Result<(URLResponse, Data), Error>) -> Void

enum HTTPMethod:String {
    case GET
    case POST
    case DELET
    case PUT
}

class HttpClient
{
    public func get(urlRequest: URLRequest, completionBlock: @escaping completionBlock) -> Void {
        var request = urlRequest
        request.httpMethod = HTTPMethod.GET.rawValue
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let httpResponse = response as? HTTPURLResponse {
                let result = self.handleNetworkResponse(response: httpResponse)
                switch result {
                case .success:
                    if let data = data {
                        completionBlock(.success((httpResponse,data)))
                    }
                case .failure(let httpError):
                    completionBlock(.failure(httpError))
                }
            }
            else {
                completionBlock(.failure(error ?? NSError(domain:"", code:1009, userInfo:[ NSLocalizedDescriptionKey: "The Internet connection appears to be offline."])))
            }
        }
        task.resume()
    }
    
    /// Default handler for HTTP response codes.
    func handleNetworkResponse(response: HTTPURLResponse) -> Result<String, NetworkError> {
        switch response.statusCode {
        case 100..<200:
            return .failure(NetworkError.informational)
        case 200...209:
            return .success("Ok")
        case 400...499:
            return .failure(NetworkError.clientError)
        case 500...599:
            return .failure(NetworkError.serverError)
        case 600:
            return .failure(NetworkError.unknown)
        default:
            return .failure(NetworkError.unknown)
        }
    }
}



// other method will describe here same way like above get method defined
