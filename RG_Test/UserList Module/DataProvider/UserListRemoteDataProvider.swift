//
//  UserListRemoteProvider.swift
//  RG_Test
//
//  Created by Sushobhit.Jain on 17/01/21.
//

import Foundation
//https://reqres.in/api/users?page=1
// API client
struct Reqres {
    static let scheme = "https"
    static let host = "reqres.in"
    static let path = "/api"
}

class UserListRemoteDataProvider {
    
    let method = "/users"
    private func makeReqUserListComponent(queries:Dictionary<String,Any>,method:String)-> URLComponents {
        var components = URLComponents()
        components.scheme = Reqres.scheme
        components.host = Reqres.host
        components.path = Reqres.path + method
        var queriesItem:[URLQueryItem]? = queries.count > 0 ? [URLQueryItem]() : nil
        for query in queries {
            let item = URLQueryItem(name: query.key, value: "\(query.value)")
            queriesItem?.append(item)
        }
        components.queryItems = queriesItem
        return components
    }
    
    
    
    func getUserListData(param:Dictionary<String,Any>,completionBlock: @escaping (UserListResponse?,Bool,String)->Void) {
        let urlComponent = self.makeReqUserListComponent(queries:param,method: self.method)
        guard let url = urlComponent.url else {
            completionBlock(nil,false,NetworkError.invalidURL.errordescription())
            return
        }
        let urlRequest = URLRequest(url: url)
        HttpClient().get(urlRequest: urlRequest) { (result) in
            switch result {
            case .success(( _, let data)):
                do{
                    let analyticRes = try JSONDecoder().decode(UserListResponse.self, from: data)
                    completionBlock(analyticRes,true,"")
                }
                catch {
                    completionBlock(nil,false,NetworkError.decodingFailed.errordescription())
                }
            case .failure(let error):
                completionBlock(nil,false,error.localizedDescription)
                break
                
            }
        }
    }
    
}
