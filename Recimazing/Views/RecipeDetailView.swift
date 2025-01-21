//
//  RecipeDetailView.swift
//  Recimazing
//
//  Created by Doug Levin on 1/20/25.
//

import AVKit
import SwiftUI

struct RecipeDetailView: View {
    @State private var showSourceWebView = false
    @State private var showVideoWebView = false
    @State var viewModel: ViewModel
    
    var body: some View {
        ScrollView {
            VStack(spacing: 10) {
                Text("\(viewModel.recipe.name)")
                    .font(.title)
                Text("\(viewModel.recipe.cuisine) Cuisine")
                    .font(.title2)
                    
                Image(uiImage: viewModel.image)
                    .resizable()
                    .aspectRatio(1, contentMode: .fit)
                    .containerRelativeFrame([.horizontal]) { dimension, _ in
                        dimension * 0.8
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .padding(.top, 10)
                
                if let url = viewModel.recipe.sourceURL {
                    Button("View Recipe Website") {
                        showSourceWebView = true
                    }
                    .font(.title2)
                    .foregroundColor(.blue)
                    .padding(.top, 20)
                    .sheet(isPresented: $showSourceWebView) {
                        ModalWebView(title: viewModel.recipe.name, url: url, isPresented: $showSourceWebView)
                            .presentationDetents([.large])
                            .presentationDragIndicator(.visible)
                    }
                }
                
                if let url = viewModel.recipe.youtubeURL {
                    Button("Watch Video") {
                        showVideoWebView = true
                    }
                    .font(.title2)
                    .foregroundColor(.blue)
                    .padding(.top, 20)
                    .sheet(isPresented: $showVideoWebView) {
                        ModalWebView(title: viewModel.recipe.name, url: url, isPresented: $showVideoWebView)
                            .presentationDetents([.large])
                            .presentationDragIndicator(.visible)
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal)
        }
        .scrollIndicators(.hidden)
        .task {
            await viewModel.loadImage()
        }
    }
    
    init(recipe: Recipe) {
        let viewModel = ViewModel(recipe: recipe, imageCloudClient: AppManager.shared.imageCloudClient)
        _viewModel = State(initialValue: viewModel)
    }
}

#Preview {
    let largePhotoURL = "https://d3jbb8n5wk0qxi.cloudfront.net/photos/93e50ff1-bf1d-4f88-8978-e18e01d3231d/large.jpg"
    let sourceURL = "https://www.bbcgoodfood.com/recipes/1742633/pumpkin-pie"
    let youtubeURL = "https://www.youtube.com/watch?v=hpapqEeb36k"
    let recipe = Recipe(
        cuisine: "American",
        name: "Pumpkin Pie",
        photoURLLarge: URL(string: largePhotoURL)!,
        photoURLSmall: URL(string: "https://pumpkinpie.com/small.jpg")!,
        sourceURL: URL(string: sourceURL),
        uuid: UUID(),
        youtubeURL: URL(string: youtubeURL)
    )

    return RecipeDetailView(recipe: recipe)
}
