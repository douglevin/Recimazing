//
//  RecipeRowView+ViewModelTests.swift
//  RecimazingTests
//
//  Created by Doug Levin on 1/20/25.
//

@testable import Recimazing
import SwiftData
import SwiftUI
import Testing

class RecipeRowViewViewModelTests {
    let mockURL: URL
    let mockSession = MockURLSession()
    let mockImageCloudClient: ImageCloudClient
    let mockContainer: ModelContainer
    let mockContext: ModelContext
    let sampleCloudRecipes = MockURLSession.sampleCloudRecipes
    let viewModel: RecipeRowView.ViewModel
    let recipe: Recipe
    
    @MainActor
    init() throws {
        mockURL = try #require(URL(string: "https://example.com"))
        mockContainer = MockContainer.createMockContainer()
        mockContext = mockContainer.mainContext
        
        mockImageCloudClient = ImageCloudClient(session: mockSession)
        recipe = MockContainer.sampleRecipes[0]
        viewModel = RecipeRowView.ViewModel(recipe: recipe, imageCloudClient: mockImageCloudClient)
    }
    
    @MainActor
    @Test func initializing() throws {
        #expect(recipe == viewModel.recipe)
        #expect(recipe.name == viewModel.name)
        #expect(recipe.uuid.uuidString == viewModel.cacheKey)
        #expect(viewModel.imageCloudClient.session as? MockURLSession != nil)
        let expectedUIImage = try #require(UIImage(systemName: "photo"))
        #expect(expectedUIImage == viewModel.image)
    }
    
    @MainActor
    @Test func loadImage() async throws {
        let defaultImage = try #require(UIImage(systemName: "photo"))
        let newImage = try #require(UIImage(systemName: "iphone"))
        #expect(defaultImage.size != newImage.size)
        
        let imageData = newImage.jpegData(compressionQuality: 1.0)
        mockSession.mockData = imageData
        mockSession.mockResponse = HTTPURLResponse(url: mockURL,
                                                   statusCode: 200,
                                                   httpVersion: nil,
                                                   headerFields: nil)
        let cachedImage = mockImageCloudClient.cachedImage(forKey: viewModel.cacheKey)
        #expect(cachedImage == nil)
        
        await viewModel.loadImage()
        let cachedImage2 = try #require(mockImageCloudClient.cachedImage(forKey: viewModel.cacheKey))
        #expect(cachedImage2 != nil)
        #expect(cachedImage2.size == viewModel.image.size)
    }
}
