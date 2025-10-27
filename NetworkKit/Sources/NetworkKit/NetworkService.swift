//
//  NetworkService.swift
//  NetworkKit
//
//  Created by Ali FAKIH on 10/8/25.
//

import Foundation

actor NetworkService {
    private let session: URLSession
    
    public init(session: URLSession = .shared) {
        self.session = session
    }
    
    func request<T: Decodable>(
        from request: APIRequest
    ) async throws -> T {
        do {
            let networkRequest = NetworkRequest(apiRequest: request)
            let (data, response) = try await session.data(for: networkRequest.request)

            try ErrorMapper.validateHTTPResponse(response, data: data)

            guard !data.isEmpty else {
                throw NetworkError.noData
            }
            do {
                return try JSONDecoder().decode(T.self, from: data)
            } catch {
                throw NetworkError.emptyResponse
            }
        }
        catch let error as NetworkError {
            throw error
        } catch let decodingError as DecodingError {
            throw NetworkError.decodingError(decodingError)
        } catch let urlError as URLError {
            throw ErrorMapper.mapURLError(urlError)
        } catch {
            throw NetworkError.networkError(error)
        }
    }
}
