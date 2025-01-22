//
//  APICloudClient.swift
//  Recimazing
//
//  Created by Doug Levin on 1/20/25.
//

import Foundation
import os

/// This class contains the functionality to communicate with the "recipe" cloud API.
public class APICloudClient: BaseCloudClient {
    
    // MARK: Properties
    
    /// The base URL of the cloud API.
    public let baseURL: URL
    
    /// A logger for debugging and logging errors.
    private let logger = Logger()
    
    // MARK: Enums
    
    /// An enum representing the possible errors that can occur within the cloud api client.
    public enum InternalError: Equatable, Error {
        case badResponseData
    }
    
    // MARK: Cloud Response Objects
    
    internal struct ResponseGetRecipes: Codable {
        let recipes: [CloudRecipe]
    }
    
    // MARK: Initializers
    
    /// Initializes a cloud client.
    ///
    /// - Parameter baseURL: The base URL for the cloud API.
    public init(baseURL: URL) {
        self.baseURL = baseURL
        super.init()
    }

    /// Initializes a cloud client and is for internal usage only. Allows dependency injection for easier unit testing.
    ///
    /// - Parameters:
    ///   - baseURL: The base URL for the cloud API.
    ///   - session: The session to use when making URL requests.
    internal init(baseURL: URL, session: URLSessionProtocol = URLSession.shared) {
        self.baseURL = baseURL
        super.init(session: session)
    }
    
    // MARK: GET Requests
    
    /// Performs a GET request to fetch all recipes in the cloud.
    ///
    /// - Returns: An array of cloud recipes.
    /// - Throws:  A `URLError` if a problem occurs.
    public func getRecipes() async throws -> [CloudRecipe] {
        try await getRecipes(withPath: "recipes.json")
    }
    
    /// An internal function to perform a GET request to fetch all recipes in the cloud. Allows dependency injection
    /// for easier unit testing.
    ///
    /// - Parameter path: The path for the api call.
    /// - Returns: An array of cloud recipes.
    /// - Throws:  An `Error` if a problem occurs.
    internal func getRecipes(withPath path: String) async throws -> [CloudRecipe] {
        let fullURL = baseURL.appendingPathComponent(path)
        let data = try await performRequest(withURL: fullURL)
        
        var recipes = [CloudRecipe]()
        do {
            recipes = try JSONDecoder().decode(ResponseGetRecipes.self, from: data).recipes
            logger.debug("getRecipes fetched \(recipes.count) recipes")
        } catch {
            logger.error("\(error)")
            throw InternalError.badResponseData
        }
        
        return recipes
    }
}
