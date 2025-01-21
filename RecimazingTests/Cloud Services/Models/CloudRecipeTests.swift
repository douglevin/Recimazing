//
//  CloudRecipeTests.swift
//  RecimazingTests
//
//  Created by Doug Levin on 1/20/25.
//

import Foundation
@testable import Recimazing
import Testing

struct CloudRecipeTests {
    @Test func initialize() async throws {
        let cuisine = "American"
        let name = "Pumpkin Pie"
        let photoURLLarge = try #require(URL(string: "https://pumpkinpie.com/large.jpg"))
        let photoURLSmall = try #require(URL(string: "https://pumpkinpie.com/small.jpg"))
        let sourceURL = try #require(URL(string: "https://pumpkinpie.com/recipe"))
        let uuid = try #require(UUID(uuidString: "23fb89ed-00ec-407e-8802-d0a510973df9"))
        let youtubeURL = try #require(URL(string: "https://youtube.com/pumpkinpie"))
        
        let cloudRecipe = CloudRecipe(cuisine: cuisine,
                                      name: name,
                                      photoURLLarge: photoURLLarge,
                                      photoURLSmall: photoURLSmall,
                                      sourceURL: sourceURL,
                                      uuid: uuid,
                                      youtubeURL: youtubeURL)
        #expect(cuisine == cloudRecipe.cuisine)
        #expect(name == cloudRecipe.name)
        #expect(photoURLLarge == cloudRecipe.photoURLLarge)
        #expect(photoURLSmall == cloudRecipe.photoURLSmall)
        #expect(sourceURL == cloudRecipe.sourceURL)
        #expect(uuid == cloudRecipe.uuid)
        #expect(youtubeURL == cloudRecipe.youtubeURL)
    }

    @Test func codingKeys() async throws {
        let expected = ["cuisine", "name", "photo_url_large", "photo_url_small", "source_url", "uuid", "youtube_url"]
        let actual = CloudRecipe.CodingKeys.allCases.map { $0.rawValue }
        #expect(Set(expected) == Set(actual))
    }
}
