//
//  APICloudClientTests.swift
//  RecimazingTests
//
//  Created by Doug Levin on 1/20/25.
//

import Foundation
@testable import Recimazing
import Testing

struct APICloudClientTests {
    
    struct MockTests {
        let baseURL: URL
        let mockSession = MockURLSession()
        let mockAPICloudClient: APICloudClient
        let recipe1 = CloudRecipe(cuisine: "American",
                                  name: "Pumpkin Pie",
                                  photoURLLarge: nil,
                                  photoURLSmall: nil,
                                  sourceURL: nil,
                                  uuid: UUID(uuidString: "23fb89ed-00ec-407e-8802-d0a510973df9")!,
                                  youtubeURL: nil)
        
        let recipe2 = CloudRecipe(cuisine: "Malaysian",
                                  name: "Apam Balik",
                                  photoURLLarge: URL(string: "https://apambalik.com/large.jpg")!,
                                  photoURLSmall: URL(string: "https://apambalik.com/small.jpg")!,
                                  sourceURL: URL(string: "https://apambalik.com/recipe"),
                                  uuid: UUID(uuidString: "0c6ca6e7-e32a-4053-b824-1dbf749910d8")!,
                                  youtubeURL: URL(string: "https://youtube.com/apambalik")!)
        
        init() throws {
            baseURL = try #require(URL(string: "https://example.com"))
            mockAPICloudClient = APICloudClient(baseURL: baseURL, session: mockSession)
        }
        
        @Test func initializing() throws {
            #expect(mockAPICloudClient.session as? MockURLSession != nil)
            #expect(mockAPICloudClient.session as? URLSession == nil)
        }
        
        @Test func getRecipesSuccess() async throws {
            let jsonData = """
        {
            "recipes": [
                {
                    "cuisine": "\(recipe1.cuisine)",
                    "name": "\(recipe1.name)",                                        
                    "uuid": "\(recipe1.uuid)",                    
                }, 
                {
                    "cuisine": "\(recipe2.cuisine)",
                    "name": "\(recipe2.name)",
                    "photo_url_large": "\(recipe2.photoURLLarge!)",
                    "photo_url_small": "\(recipe2.photoURLSmall!)",
                    "source_url": "\(recipe2.sourceURL!)",
                    "uuid": "\(recipe2.uuid)",
                    "youtube_url": "\(recipe2.youtubeURL!)"
                }
            ]
        }
        """.data(using: .utf8)!
            
            let mockResponse = HTTPURLResponse(url: baseURL.appendingPathComponent("recipes.json"),
                                               statusCode: 200,
                                               httpVersion: nil,
                                               headerFields: nil)
            
            mockSession.mockData = jsonData
            mockSession.mockResponse = mockResponse
            
            let recipes = try await mockAPICloudClient.getRecipes()
            #expect(recipes.count == 2)
            
            for (index, recipe) in recipes.enumerated() {
                #expect(recipe.cuisine == recipes[index].cuisine)
                #expect(recipe.name == recipes[index].name)
                #expect(recipe.photoURLLarge == recipes[index].photoURLLarge)
                #expect(recipe.photoURLSmall == recipes[index].photoURLSmall)
                #expect(recipe.sourceURL == recipes[index].sourceURL)
                #expect(recipe.uuid == recipes[index].uuid)
                #expect(recipe.youtubeURL == recipes[index].youtubeURL)
            }
        }
        
        @Test func getRecipesMalformedData() async throws {
            let jsonData = """
        {
            "recipes": [
                {
                    "cuisine": "\(recipe1.cuisine)",                
                    "uuid": "\(recipe1.uuid)"
                }, 
                {
                    "cuisine": "\(recipe2.cuisine)",
                    "name": "\(recipe2.name)",
                    "uuid": "\(recipe2.uuid)"
                }
            ]
        }
        """.data(using: .utf8)!
            
            let mockResponse = HTTPURLResponse(url: baseURL.appendingPathComponent("recipes.json"),
                                               statusCode: 200,
                                               httpVersion: nil,
                                               headerFields: nil)
            
            mockSession.mockData = jsonData
            mockSession.mockResponse = mockResponse
            
            await #expect(throws: APICloudClient.InternalError.badResponseData) {
                try await mockAPICloudClient.getRecipes()
            }
        }
        
        @Test func getRecipesEmptyData() async throws {
            let jsonData = try #require("{ \"recipes\": [] }".data(using: .utf8))            
            let mockResponse = HTTPURLResponse(url: baseURL.appendingPathComponent("recipes.json"),
                                               statusCode: 200,
                                               httpVersion: nil,
                                               headerFields: nil)
            
            mockSession.mockData = jsonData
            mockSession.mockResponse = mockResponse
            
            let recipes = try await mockAPICloudClient.getRecipes()
            #expect(recipes.count == 0)
        }
        
        @Test func getRecipesBadResponseData() async throws {
            let jsonData = try #require("{ }: [] }".data(using: .utf8))
            let mockResponse = HTTPURLResponse(url: baseURL.appendingPathComponent("recipes.json"),
                                               statusCode: 200,
                                               httpVersion: nil,
                                               headerFields: nil)
            
            mockSession.mockData = jsonData
            mockSession.mockResponse = mockResponse
            
            await #expect(throws: APICloudClient.InternalError.badResponseData) {
                try await mockAPICloudClient.getRecipes()
            }
        }
    }
    
    struct IntegrationTests {
        let baseURL: URL
        let apiCloudClient: APICloudClient
        
        init() throws {
            baseURL = try #require(URL(string: "https://d3jbb8n5wk0qxi.cloudfront.net"))
            apiCloudClient = APICloudClient(baseURL: baseURL)
        }
        
        @Test func initializing() throws {
            #expect(apiCloudClient.session as? URLSession != nil)
            #expect(apiCloudClient.session as? MockURLSession == nil)
        }
        
        @Test func getRecipesSuccess() async throws {
            let recipes = try await apiCloudClient.getRecipes()
            #expect(recipes.count == 63)
        }
        
        @Test func getRecipesMalformedData() async throws {
            await #expect(throws: APICloudClient.InternalError.badResponseData) {
                try await apiCloudClient.getRecipes(withPath: "recipes-malformed.json")
            }
        }
        
        @Test func getRecipesEmptyData() async throws {
            let recipes = try await apiCloudClient.getRecipes(withPath: "recipes-empty.json")
            #expect(recipes.count == 0)
        }
        
        @Test func getRecipesWithBadStatusCode() async throws {
            let baseURL = try #require(URL(string: "https://httpstat.us"))
            let apiCloudClient = APICloudClient(baseURL: baseURL)
            await #expect(throws: URLError(.badServerResponse)) {
                try await apiCloudClient.getRecipes(withPath: "500")
            }
        }
        
        @Test func getRecipesBadResponseData() async throws {
            let baseURL = try #require(URL(string: "https://httpstat.us"))
            let apiCloudClient = APICloudClient(baseURL: baseURL)
            await #expect(throws: APICloudClient.InternalError.badResponseData) {
                try await apiCloudClient.getRecipes(withPath: "200")
            }
        }
    }
}
