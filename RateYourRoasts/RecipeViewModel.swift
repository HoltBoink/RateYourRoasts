//
//  RecipeViewModel.swift
//  RateYourRoasts
//
//  Created by Holt Boink on 4/29/23.
//

import Foundation
@MainActor

class RecipeViewModel: ObservableObject {
    @Published var recipeArray: [Recipe] = []
    @Published var urlString = "https://api.sampleapis.com/coffee/hot"
    
    func getData() async {
        print("Accessing the url \(urlString)")
        guard let url = URL(string: urlString) else {
            print("ERROR: Could not create url from \(urlString)")
            return
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            guard let returned = try? JSONDecoder().decode([Recipe].self, from: data) else {
                print("JSON ERROR: could not decode returned JSON data")
                return
            }
            self.recipeArray = self.recipeArray + returned
        } catch {
            print("ERROR: could not use URL at \(urlString) to get data and response")
        }
    }
    
//    func loadNextIfNeeded(recipe: Recipe) async {
//        guard let lastSpecies = speciesArray.last else {
//            return
//        }
//        if species.id == lastSpecies.id && urlString.hasPrefix("http") {
//            Task {
//                await getData()
//            }
//        }
//    }
//    
//    func loadAll() async {
//        guard urlString.hasPrefix("http") else {return}
//        await getData()
//        await loadAll()
//    }
    
}
