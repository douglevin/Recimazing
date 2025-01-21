//
//  CloudRecipe.swift
//  Recimazing
//
//  Created by Doug Levin on 1/20/25.
//

import Foundation

/// This structure represents a recipe as it is represented in the cloud API.
public struct CloudRecipe: Codable {
    
    // MARK: Properties
    
    /// The type of cuisine (e.g, American, Mexican, etc..)
    public let cuisine: String
    
    /// The name of the recipe.
    public let name: String
    
    /// The large photo URL for the recipe. This may be `nil` if the URL was not provided.
    public let photoURLLarge: URL?
    
    /// The small photo URL for the recipe. This may be `nil` if the URL was not provided.
    public let photoURLSmall: URL?
    
    /// The source URL of the recipe. This may be `nil` if the URL was not provided.
    public let sourceURL: URL?
    
    /// The unique identifier for the recipe.
    public let uuid: UUID
    
    /// The YouTube video URL for the recipe. This may be `nil` if the URL was not provided.
    public let youtubeURL: URL?
    
    // MARK: Enums
    
    /// The coding keys mapped to the cloud API JSON keys.
    enum CodingKeys: String, CaseIterable, CodingKey {
        case cuisine = "cuisine"
        case name = "name"
        case photoURLLarge = "photo_url_large"
        case photoURLSmall = "photo_url_small"
        case sourceURL = "source_url"
        case uuid = "uuid"
        case youtubeURL = "youtube_url"
    }
}
