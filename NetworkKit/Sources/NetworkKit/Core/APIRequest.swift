//
//  APIRequest.swift
//  NetworkKit
//
//  Created by Ali FAKIH on 10/8/25.
//


import Foundation


enum HTTPMethod: String {
    case get = "GET"
    case post = "POSTS"
    case put = "PUT"
    case delete = "DELETE"
    case patch = "PATCH"
}

protocol APIRequest {
    var url: String? {get}
    var path: String {get}
    var method: HTTPMethod {get}
    var queryItems: [URLQueryItem]? {get}
    var params: Any? {get}
    var timeoutInterval: TimeInterval {get}
}
extension APIRequest {
    var url: String? {nil}
    var queryItems: [URLQueryItem]? {[]}
    var params: Any? {nil}
    var timeoutInterval: TimeInterval { 10.0 }
}
