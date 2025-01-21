//
//  MockContainer.swift
//  Recimazing
//
//  Created by Doug Levin on 1/20/25.
//

import Foundation
import SwiftData

struct MockContainer {
    static func createMockContainer() -> ModelContainer {
        let schema = Schema([Recipe.self])
        let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
        do {
            return try ModelContainer(for: schema, configurations: [configuration])
        } catch {
            fatalError("Failed to create ModelContainer: \(error)")
        }
    }
    
    static let sampleRecipes = [
        Recipe(
            cuisine: "American",
            name: "Pumpkin Pie",
            photoURLLarge: URL(string: "https://pumpkinpie.com/large.jpg")!,
            photoURLSmall: URL(string: "https://pumpkinpie.com/small.jpg")!,
            sourceURL: URL(string: "https://pumpkinpie.com/small.jpg"),
            uuid: UUID(),
            youtubeURL: URL(string: "https://youtube.com/pumpkinpie")
        ),
        Recipe(
            cuisine: "American",
            name: "Banana Pancakes",
            photoURLLarge: URL(string: "https://pancakes.com/large.jpg")!,
            photoURLSmall: URL(string: "https://pancakes.com/small.jpg")!,
            sourceURL: URL(string: "https://pancakes.com/small.jpg"),
            uuid: UUID(),
            youtubeURL: URL(string: "https://youtube.com/pancakes")
        ),
        Recipe(
            cuisine: "Malaysian",
            name: "Apam Balik",
            photoURLLarge: URL(string: "https://apambalik.com/large.jpg")!,
            photoURLSmall: URL(string: "https://apambalik.com/small.jpg")!,
            sourceURL: URL(string: "https://apambalik.com/small.jpg"),
            uuid: UUID(),
            youtubeURL: URL(string: "https://youtube.com/apambalik")
        )
    ]
}
