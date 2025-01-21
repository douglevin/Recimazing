//
//  RecimazingApp.swift
//  Recimazing
//
//  Created by Doug Levin on 1/20/25.
//

import SwiftUI
import SwiftData

@main
struct RecimazingApp: App {
    
    /// Shared instance of the app manager.
    let appManager = AppManager.shared
    
    /// Shared model container
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Recipe.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    var body: some Scene {
        WindowGroup {
            RecipeListView(modelContext: sharedModelContainer.mainContext, apiCloudClient: appManager.apiCloudClient)
        }
        .modelContainer(sharedModelContainer)
    }
}
