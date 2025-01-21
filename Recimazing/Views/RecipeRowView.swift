//
//  RecipeRowView.swift
//  Recimazing
//
//  Created by Doug Levin on 1/20/25.
//

import os
import SwiftUI

struct RecipeRowView: View {
    @State var viewModel: ViewModel
    
    var body: some View {
        NavigationLink(destination: RecipeDetailView(recipe: viewModel.recipe)) {
            HStack {
                Image(uiImage: viewModel.image)
                    .resizable()
                    .frame(width: 35, height: 35)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .padding(.vertical, 2)
                    .padding(.trailing, 5)
                
                Text(viewModel.name)
                    .font(.title3)
                
                Spacer()
            }
            .task {
                await viewModel.loadImage()
            }
        }
    }
    
    init(recipe: Recipe) {
        let viewModel = ViewModel(recipe: recipe, imageCloudClient: AppManager.shared.imageCloudClient)
        _viewModel = State(initialValue: viewModel)
    }
}
