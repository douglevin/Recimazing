//
//  RecipeDetailView+ViewModel.swift
//  Recimazing
//
//  Created by Doug Levin on 1/20/25.
//

import os
import SwiftUI

extension RecipeDetailView {
    
    /// A view model responsible for fetching and caching images for `RecipeDetailView`.
    @Observable
    class ViewModel {
        
        // MARK: Properties - Published
        
        var image: UIImage
        
        // MARK: Properties - Constants
        
        let recipe: Recipe
        let cacheKey: String
        let imageCloudClient: ImageCloudClient
        private let logger = Logger()
        
        // MARK: Initializers
        
        init(recipe: Recipe, imageCloudClient: ImageCloudClient) {
            self.recipe = recipe
            self.cacheKey = recipe.uuid.uuidString
            self.imageCloudClient = imageCloudClient
            self.image = UIImage(systemName: "photo")!
        }
        
        // MARK: Loading Images
        
        @MainActor
        func loadImage() async {
            if let imageURL = recipe.photoURLLarge {
                do {
                    image = try await imageCloudClient.getImage(from: imageURL, cacheKey: cacheKey)
                } catch {
                    logger.error("Failed to load image: \(error)")
                }
            }
        }
    }
    
}
