//
//  BaseCloudClient.swift
//  Recimazing
//
//  Created by Doug Levin on 1/20/25.
//

import os
import Foundation

/// This class serves as the base class for other cloud clients.
public class BaseCloudClient {
    
    // MARK: Properties
    
    /// The session to use when making URL requests.
    internal let session: URLSessionProtocol
    
    /// A logger for debugging and logging errors.
    private let logger = Logger()
    
    // MARK: Initializers
    
    /// Initializes a cloud client.
    ///
    /// - Parameter baseURL: The base URL for the cloud API.
    public init() {
        self.session = URLSession.shared
    }
    
    /// Initializes a cloud client and is for internal usage only. Allows dependency injection for easier unit testing.
    ///
    /// - Parameters:
    ///   - baseURL: The base URL for the cloud API.
    ///   - session: The session to use when making URL requests.
    internal init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }
    
    /// An internal function to perform a request to the cloud.
    ///
    /// - Parameter path: The path for the api call.
    /// - Returns: An array of cloud recipes.
    /// - Throws:  A `URLError` if a problem occurs.
    internal func performRequest(withURL url: URL) async throws -> Data {
        let (data, response) = try await session.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            logger.error("Response was not the expected type HTTPURLResponse: \(response)")
            throw URLError(.badServerResponse)
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            logger.error("Server returned bad status code: \(httpResponse.statusCode)")
            throw URLError(.badServerResponse)
        }
        
        return data
    }
}
