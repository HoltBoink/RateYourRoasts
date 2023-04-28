//
//  ListView.swift
//  RateYourRoasts
//
//  Created by Holt Boink on 4/26/23.
//

import SwiftUI
import Firebase
import FirebaseFirestoreSwift

struct ListView: View {
    @FirestoreQuery(collectionPath: "reviews") var reviews: [Review]
    @State private var showReviewDetailView = false
    @State private var showRecipeView = false
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            List(reviews) { review in
                NavigationLink {
                    ReviewDetailView(review: review)
                } label: {
                    Text(review.name)
                        .font(.title2)
                }
                
            }
            .listStyle(.plain)
            .navigationTitle("Coffee Brews")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showReviewDetailView.toggle()
                    } label: {
                        Image(systemName: "plus")
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Sign Out") {
                        do {
                            try Auth.auth().signOut()
                            print("Log out successful")
                            dismiss()
                        } catch {
                            print("ERROR: Could not sign out")
                        }
                    }
                }
                ToolbarItem(placement: .bottomBar) {
                    Button {
                        showRecipeView.toggle()
                    } label: {
                        Text("Recipes")
                        Image(systemName: "cup.and.saucer.fill")
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
            .sheet(isPresented: $showReviewDetailView) {
                NavigationStack {
                    ReviewDetailView(review: Review())
                }
            }
            .fullScreenCover(isPresented: $showRecipeView) {
                NavigationStack {
                    RecipesView()
                }
            }
        }
    }
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ListView()
        }
    }
}
