//
//  RecipeTests.swift
//  RecimazingTests
//
//  Created by Doug Levin on 1/20/25.
//

import Foundation
@testable import Recimazing
import SwiftData
import Testing

struct RecipeTests {
    let cuisine = "American"
    let name = "Pumpkin Pie"
    let photoURLLarge = URL(string: "https://pumpkinpie.com/large.jpg")!
    let photoURLSmall = URL(string: "https://pumpkinpie.com/small.jpg")!
    let sourceURL = URL(string: "https://pumpkinpie.com/recipe")!
    let uuid = UUID(uuidString: "23fb89ed-00ec-407e-8802-d0a510973df9")!
    let youtubeURL = URL(string: "https://youtube.com/pumpkinpie")!
    let mockContainer: ModelContainer
    let mockContext: ModelContext
    
    @MainActor
    init() throws {
        mockContainer = MockContainer.createMockContainer()
        mockContext = try #require(mockContainer.mainContext)
        
    }
    
    @Test func initializeRequiredProperties() async throws {
        let recipe = Recipe(cuisine: cuisine,
                            name: name,
                            photoURLLarge: nil,
                            photoURLSmall: nil,
                            sourceURL: nil,
                            uuid: uuid,
                            youtubeURL: nil)
        #expect(cuisine == recipe.cuisine)
        #expect(name == recipe.name)
        #expect(recipe.photoURLLarge == nil)
        #expect(recipe.photoURLSmall == nil)
        #expect(recipe.sourceURL == nil)
        #expect(uuid == recipe.uuid)
        #expect(recipe.youtubeURL == nil)
    }
    
    @Test func initializeAllProperties() async throws {
        let recipe = Recipe(cuisine: cuisine,
                            name: name,
                            photoURLLarge: photoURLLarge,
                            photoURLSmall: photoURLSmall,
                            sourceURL: sourceURL,
                            uuid: uuid,
                            youtubeURL: youtubeURL)
        #expect(cuisine == recipe.cuisine)
        #expect(name == recipe.name)
        #expect(photoURLLarge == recipe.photoURLLarge)
        #expect(photoURLSmall == recipe.photoURLSmall)
        #expect(sourceURL == recipe.sourceURL)
        #expect(uuid == recipe.uuid)
        #expect(youtubeURL == recipe.youtubeURL)
    }
    
    @MainActor
    @Test func fetchRecipes() async throws {
        var recipes = Recipe.fetchRecipes(in: mockContext)
        #expect(recipes.count == 0)
        
        let recipe = Recipe(cuisine: cuisine,
                            name: name,
                            photoURLLarge: photoURLLarge,
                            photoURLSmall: photoURLSmall,
                            sourceURL: sourceURL,
                            uuid: uuid,
                            youtubeURL: youtubeURL)
        
        mockContext.insert(recipe)
        recipes = Recipe.fetchRecipes(in: mockContext)
        #expect(recipes.count == 1)
        
        #expect(cuisine == recipe.cuisine)
        #expect(name == recipe.name)
        #expect(photoURLLarge == recipe.photoURLLarge)
        #expect(photoURLSmall == recipe.photoURLSmall)
        #expect(sourceURL == recipe.sourceURL)
        #expect(uuid == recipe.uuid)
        #expect(youtubeURL == recipe.youtubeURL)
    }
}
