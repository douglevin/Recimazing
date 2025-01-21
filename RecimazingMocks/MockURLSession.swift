//
//  MockURLSession.swift
//  Recimazing
//
//  Created by Doug Levin on 1/20/25.
//

import Foundation

class MockURLSession: URLSessionProtocol {
    var mockData: Data?
    var mockResponse: URLResponse?
    var mockError: Error?
    
    func data(from url: URL) async throws -> (Data, URLResponse) {
        if let error = mockError {
            throw error
        }
        
        guard let data = mockData, let response = mockResponse else {
            throw URLError(.badURL)
        }
        
        return (data, response)
    }
    
    static var sampleCloudRecipes: [CloudRecipe] = {
        let cloudRecipe1 = CloudRecipe(cuisine: "American",
                                       name: "Pumpkin Pie",
                                       photoURLLarge: nil,
                                       photoURLSmall: nil,
                                       sourceURL: nil,
                                       uuid: UUID(),
                                       youtubeURL: nil)
        let cloudRecipe2 = CloudRecipe(cuisine: "American",
                                       name: "Banana Pancakes",
                                       photoURLLarge: nil,
                                       photoURLSmall: nil,
                                       sourceURL: nil,
                                       uuid: UUID(),
                                       youtubeURL: nil)
        let cloudRecipe3 = CloudRecipe(cuisine: "Malaysian",
                                       name: "Apam Balik",
                                       photoURLLarge: nil,
                                       photoURLSmall: nil,
                                       sourceURL: nil,
                                       uuid: UUID(),
                                       youtubeURL: nil)
        
        return [cloudRecipe1, cloudRecipe2, cloudRecipe3]
    }()
}
