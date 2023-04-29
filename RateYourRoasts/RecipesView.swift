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
                List (recipeVM.recipeArray) { recipe in
                    HStack (alignment: .top) {
                        AsyncImage(url: URL(string: recipe.image)) {phase in
                            if let image = phase.image {
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .cornerRadius(15)
                                    .shadow(radius: 15)
                                    .animation(.default, value: image)
                            } else if phase.error != nil {
                                Image(systemName: "photo")
                                    .resizable()
                                    .scaledToFit()
                            }
                        }
                        .frame(maxWidth: 90, maxHeight: 90)
                        VStack (alignment: .leading) {
                            Text(recipe.title)
                                .font(.title)
                                .bold()
                            Text(recipe.description)
                            
                            Text("Ingredients:")
                                .padding(.top)
                                .bold()
                                .font(.title2)
                            
                            ForEach(recipe.ingredients, id: \.self) { ingredient in
                                Text(" -\(ingredient)")
                            }
                        }
                    }
                }
                .listStyle(.plain)
            }
            .navigationTitle("☕️ Recipes")
            .navigationBarTitleDisplayMode(.automatic)
        }
        .toolbar {
            ToolbarItem (placement: .cancellationAction) {
                Button("Cancel") {
                    dismiss()
                }
            }
        }
        .task {
            await recipeVM.getData()
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
