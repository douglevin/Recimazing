//
//  RecipeListView+ViewModel.swift
//  Recimazing
//
//  Created by Doug Levin on 1/20/25.
//

import os
import SwiftData
import SwiftUI

extension RecipeListView {
 
    /// A view model responsible for fetching and storing recipes from the cloud.
    @Observable
    class ViewModel {
        
        // MARK: Properties - Published
        
        var recipes = [Recipe]()
        var isRefreshing = false
        
        // MARK: Properties - Computed
        
        var groupedRecipes: [String: [Recipe]] {
            Dictionary(grouping: recipes) { $0.cuisine }
        }
        var cuisines: [String] {
            groupedRecipes.keys.sorted()
        }
        
        // MARK: Properties - Constants
        
        let apiCloudClient: APICloudClient
        let modelContext: ModelContext
        private let logger = Logger()
        
        // MARK: Initializers
        
        @MainActor
        init(modelContext: ModelContext, apiCloudClient: APICloudClient) {
            self.modelContext = modelContext
            self.apiCloudClient = apiCloudClient
            self.recipes = Recipe.fetchRecipes(in: modelContext)
        }
        
        // MARK: Refreshing
        
        @MainActor
        func refreshRecipes() async {
            isRefreshing = true
            defer { isRefreshing = false }
            
            // If there are no recipes, delay for 1 second so the user can see the progress indicator,
            // otherwise it's too fast for the user to see.
            if recipes.count == 0 {
                try? await Task.sleep(nanoseconds: 1_000_000_000)
            }
            
            do {
                let path = "recipes.json" // "recipes-malformed.json" "recipes-empty.json"
                let cloudRecipes = try await apiCloudClient.getRecipes(withPath: path)
                try modelContext.transaction {
                    
                    // Delete old data. This could be optimized in the future
                    let oldRecipes = Recipe.fetchRecipes(in: modelContext)
                    for recipe in oldRecipes {
                        modelContext.delete(recipe)
                    }
                    
                    // Convert each cloud recipe into a SwiftData recipe and insert into the context
                    cloudRecipes.forEach { rec in
                        let recipe = Recipe(cuisine: rec.cuisine,
                                            name: rec.name,
                                            photoURLLarge: rec.photoURLLarge,
                                            photoURLSmall: rec.photoURLSmall,
                                            sourceURL: rec.sourceURL,
                                            uuid: rec.uuid,
                                            youtubeURL: rec.youtubeURL)
                        modelContext.insert(recipe)
                    }
                                        
                    self.recipes = Recipe.fetchRecipes(in: modelContext)
                }
                
                logger.debug("There are \(self.recipes.count) recipes")
            } catch {
                logger.error("Error refreshing recipes: \(error.localizedDescription)")
            }
        }
    }
}
