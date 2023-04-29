//
//  RecipesView.swift
//  RateYourRoasts
//
//  Created by Holt Boink on 4/27/23.
//

import SwiftUI


struct RecipesView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject var recipeVM = RecipeViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                List {
                    ForEach(recipeVM.recipeArray) { recipe in
                        Text(recipe.title)
                    }
                }
                .navigationTitle("☕️ Recipes")
                .navigationBarTitleDisplayMode(.automatic)
            }
        }
        .toolbar {
            ToolbarItem (placement: .cancellationAction) {
                Button("Cancel") {
                    dismiss()
                }
            }
        }
    }
}

struct RecipesView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            RecipesView()
        }
    }
}
