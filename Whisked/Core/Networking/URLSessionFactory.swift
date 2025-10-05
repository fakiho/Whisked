//
//  URLSessionFactory.swift
//  Whisked
//
//  Created by Ali FAKIH on 10/5/25.
//

import Foundation

/// Factory for creating configured URLSession instances
enum URLSessionFactory {
    
    /// Creates a URLSession optimized for the Whisked app's network requirements
    /// - Returns: Configured URLSession with timeouts and connectivity settings
    nonisolated static func createOptimizedSession() -> URLSession {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30.0
        configuration.timeoutIntervalForResource = 60.0
        configuration.waitsForConnectivity = true
        configuration.requestCachePolicy = .useProtocolCachePolicy
        
        return URLSession(configuration: configuration)
    }
    
    /// Creates a URLSession for testing with shorter timeouts
    /// - Returns: Configured URLSession optimized for testing
    nonisolated static func createTestSession() -> URLSession {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 5.0
        configuration.timeoutIntervalForResource = 10.0
        configuration.waitsForConnectivity = false
        
        return URLSession(configuration: configuration)
    }
    
    /// Creates a URLSession with no caching for fresh data requests
    /// - Returns: Configured URLSession that bypasses cache
    nonisolated static func createNoCacheSession() -> URLSession {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30.0
        configuration.timeoutIntervalForResource = 60.0
        configuration.requestCachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        configuration.urlCache = nil
        
        return URLSession(configuration: configuration)
    }
}