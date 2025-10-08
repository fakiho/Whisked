//
//  NetworkRequest.swift
//  NetworkKit
//
//  Created by Ali FAKIH on 10/8/25.
//


import Foundation

struct NetworkRequest {
    
    var request: URLRequest
    
    init(apiRequest: APIRequest) {
        var urlcomponents = URLComponents(string: apiRequest.url?.description ?? Constants.baseURL) // if there is nothing inside api.url than send me the base url
        
        let path = urlcomponents?.path.appending(apiRequest.path) ?? ""
        
        urlcomponents?.path = path
        
        if let queryItem = apiRequest.queryItems {
            urlcomponents?.queryItems =  queryItem
        }
        guard let fullUrl = urlcomponents?.url else {
            assertionFailure("Did not load the url")
            request = URLRequest(url: URL(string: "")!)
            return
        }
        request = URLRequest(url: fullUrl)
        request.httpMethod = apiRequest.method.rawValue
        request.timeoutInterval = apiRequest.timeoutInterval
    }
}
