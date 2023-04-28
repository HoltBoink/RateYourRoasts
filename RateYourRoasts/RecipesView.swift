//
//  RecipesView.swift
//  RateYourRoasts
//
//  Created by Holt Boink on 4/27/23.
//

import SwiftUI

struct RecipesView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            Text("Hello")
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
