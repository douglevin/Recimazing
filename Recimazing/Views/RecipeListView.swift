//
//  RecipeListView.swift
//  Recimazing
//
//  Created by Doug Levin on 1/20/25.
//

import SwiftData
import SwiftUI

struct RecipeListView: View {
    @State private var viewModel: ViewModel

    var body: some View {
        NavigationSplitView {
            List {
                if viewModel.recipes.isEmpty {
                    Text("No recipes are available")
                        .frame(maxWidth: .infinity, alignment: .center)
                        .foregroundColor(.secondary)
                        .padding()
                } else {
                    ForEach(viewModel.groupedRecipes.keys.sorted(), id: \.self) { cuisine in
                        Section(header: Text("\(cuisine) Recipes").font(.headline)) {
                            ForEach(viewModel.groupedRecipes[cuisine] ?? []) { recipe in
                                RecipeRowView(recipe: recipe)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Recimazing")
            .overlay {
                if viewModel.isRefreshing && viewModel.recipes.count == 0 {
                    ProgressView("Fetching Recipes...")
                }
            }
            .toolbar {
                ToolbarItem {
                    Button(action: {
                        Task {
                            await viewModel.refreshRecipes()
                        }
                    }, label: {
                        Label("Refresh", systemImage: "arrow.clockwise")
                    })
                }
            }
        } detail: {
            Text("Select a recipe")
        }
        .task {
            await viewModel.refreshRecipes()
        }
    }
    
    init(modelContext: ModelContext, apiCloudClient: APICloudClient) {
        let viewModel = ViewModel(modelContext: modelContext, apiCloudClient: apiCloudClient)
        _viewModel = State(initialValue: viewModel)
    }
}

#Preview {
    let mockContainer = MockContainer.createMockContainer()
    let mainContext = mockContainer.mainContext
    for recipe in MockContainer.sampleRecipes {
        mainContext.insert(recipe)
    }

    let mockURLSession = MockURLSession()
    let mockAPICloudClient = APICloudClient(baseURL: URL(string: "https://example.com")!, session: mockURLSession)
    
    return RecipeListView(modelContext: mainContext, apiCloudClient: mockAPICloudClient)
}
