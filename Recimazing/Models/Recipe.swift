//
//  Recipe.swift
//  Recimazing
//
//  Created by Doug Levin on 1/20/25.
//

import os
import Foundation
import SwiftData

/// Represents a recipe in the local database.
@Model
final class Recipe {
    
    // MARK: Properties
    
    /// The type of cuisine. (e.g, American, Mexican, etc..)
    var cuisine: String
    
    /// The name of the recipe.
    var name: String
    
    /// The URL of the large photo of the recipe. This may be `nil` if the URL was not provided.
    var photoURLLarge: URL?
    
    /// The URL of the small photo of the recipe. This may be `nil` if the URL was not provided.
    var photoURLSmall: URL?
    
    /// The source URL of the recipe. This may be `nil` if the URL was not provided.
    var sourceURL: URL?
    
    /// The unique identifier for the recipe.
    @Attribute(.unique) var uuid: UUID
    
    /// The URL of the YouTube video for the recipe. This may be `nil` if the URL was not provided.
    var youtubeURL: URL?
    
    // MARK: Properties - Static
    
    /// A logger for debugging purposes
    static let logger = Logger()
    
    // MARK: Initializers
    
    /// Initialize a recipe.
    ///
    /// - Parameters:
    ///   - cuisine: The type of cuisine. (e.g, American, Mexican, etc..)
    ///   - name: The name of the recipe
    ///   - photoURLLarge: The URL of the large photo of the recipe.
    ///   - photoURLSmall: The URL of the small photo of the recipe.
    ///   - sourceURL: The source URL of the recipe.
    ///   - uuid: The unique identifier for the recipe.
    ///   - youtubeURL: The URL of the YouTube video for the recipe.
    init(cuisine: String,
         name: String,
         photoURLLarge: URL?,
         photoURLSmall: URL?,
         sourceURL: URL?,
         uuid: UUID,
         youtubeURL: URL?) {
        self.cuisine = cuisine
        self.name = name
        self.photoURLLarge = photoURLLarge
        self.photoURLSmall = photoURLSmall
        self.sourceURL = sourceURL
        self.uuid = uuid
        self.youtubeURL = youtubeURL
    }
    
    // MARK: Static Helpers
    
    @MainActor
    static func fetchRecipes(in context: ModelContext) -> [Recipe] {
        var recipes = [Recipe]()
        let descriptor = FetchDescriptor<Recipe>(sortBy: [SortDescriptor(\.name)])
        do {
            recipes = try context.fetch(descriptor)
        } catch {
            Recipe.logger.error("Failed to fetch recipes: \(error.localizedDescription)")
        }
        
        return recipes
    }
}
