//
//  RecipeListView+ViewModelTests.swift
//  RecimazingTests
//
//  Created by Doug Levin on 1/20/25.
//

import Foundation
@testable import Recimazing
import SwiftData
import Testing

class RecipeListViewViewModelTests {
    let mockURL: URL
    let mockSession = MockURLSession()
    let mockAPICloudClient: APICloudClient
    let viewModel: RecipeListView.ViewModel
    let mockContainer: ModelContainer
    let mockContext: ModelContext
    let sampleCloudRecipes = MockURLSession.sampleCloudRecipes
    
    @MainActor
    init() throws {
        mockURL = try #require(URL(string: "https://example.com"))
        mockContainer = MockContainer.createMockContainer()
        mockContext = mockContainer.mainContext
        
        let response = APICloudClient.ResponseGetRecipes(recipes: sampleCloudRecipes)
        mockSession.mockData = try JSONEncoder().encode(response)
        mockSession.mockResponse = HTTPURLResponse(url: mockURL,
                                                   statusCode: 200,
                                                   httpVersion: nil,
                                                   headerFields: nil)
        mockAPICloudClient = APICloudClient(baseURL: mockURL, session: mockSession)
        viewModel = RecipeListView.ViewModel(modelContext: mockContext, apiCloudClient: mockAPICloudClient)
    }
    
    @MainActor  
    @Test func initializing() throws {
        #expect(viewModel.modelContext == mockContext)
        #expect(viewModel.apiCloudClient.session as? MockURLSession != nil)
        #expect(viewModel.recipes.isEmpty)
    }
    
    @MainActor
    @Test func refreshRecipes() async {
        await viewModel.refreshRecipes()
        #expect(sampleCloudRecipes.count == viewModel.recipes.count)
        
        let expectedCuisines = Set(sampleCloudRecipes.map { $0.cuisine }).sorted()
        #expect(expectedCuisines == viewModel.cuisines)
    }
    
    @MainActor
    @Test func refreshRecipesDelete() async throws {
        let recipe = try #require(MockContainer.sampleRecipes.first)
        mockContext.insert(recipe)
        var recipes = Recipe.fetchRecipes(in: mockContext)
        #expect(recipes.count == 1)
        
        let response = APICloudClient.ResponseGetRecipes(recipes: [])
        mockSession.mockData = try JSONEncoder().encode(response)
        await viewModel.refreshRecipes()
        #expect(viewModel.recipes.count == 0)
        
        recipes = Recipe.fetchRecipes(in: mockContext)
        #expect(recipes.count == 0)
    }
}
