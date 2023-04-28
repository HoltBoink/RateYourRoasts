//
//  ReviewDetailView.swift
//  RateYourRoasts
//
//  Created by Holt Boink on 4/27/23.
//

import SwiftUI
import FirebaseFirestoreSwift

struct ReviewDetailView: View {
    @EnvironmentObject var reviewVM: ReviewViewModel
    @FirestoreQuery(collectionPath: "reviews") var posts: [Post]
    @State var review: Review
    @Environment(\.dismiss) private var dismiss
    @State private var showCoffeeLookupSheet = false
    @State private var showPostViewSheet = false
    var previewRunning = false
    
    var body: some View {
        VStack {
            Group {
                TextField("Roaster", text: $review.name)
                    .font(.title)
                TextField("Coffee Name", text: $review.coffeeName)
                    .font(.title2)
            }
            .disabled(review.id == nil ? false : true)
            .textFieldStyle(.roundedBorder)
            .overlay {
                RoundedRectangle(cornerRadius: 5)
                    .stroke(.gray.opacity(0.5), lineWidth: review.id == nil ? 2 : 0)
            }
            .padding(.horizontal)
            
            List {
                Section {
                    ForEach(posts) { post in
                        NavigationLink {
                            PostView(review: review, post: post)
                        } label: {
                            Text(post.title)
                        }

                    }
                } header: {
                    HStack {
                        Text("Avg. Rating:")
                            .font(.title2)
                            .bold()
                        Text("4.5")
                            .font(.title)
                            .fontWeight(.black)
                            .foregroundColor(.brown)
                        Spacer()
                        Button("Rate This Roast") {
                            showPostViewSheet.toggle()
                        }
                        .buttonStyle(.borderedProminent)
                        .bold()
                        .tint(.brown)
                    }
                }
            }
            .headerProminence(.increased)
            .listStyle(.plain)
            
            Spacer()
            
        }
        .onAppear {
            if !previewRunning && review.id != nil {
                $posts.path = "reviews/\(review.id ?? "")/posts"
                print("posts.path = \($posts.path)")
            }
        }
        
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(review.id == nil)
        .toolbar {
            if review.id == nil {
                ToolbarItem (placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem (placement: .navigationBarTrailing) {
                    Button("Save") {
                        Task {
                            let success = await reviewVM.saveReview(review: review)
                            if success {
                                dismiss()
                            } else {
                                print("ERROR Saving Spot!")
                            }
                        }
                        dismiss()
                    }
                }
                ToolbarItemGroup (placement: .bottomBar) {
                    Spacer()
                    
                    Button {
                        showCoffeeLookupSheet.toggle()
                    } label: {
                        Image(systemName: "magnifyingglass")
                        Text("Lookup Roaster")
                    }
                }
            }
        }
        .sheet(isPresented: $showCoffeeLookupSheet) {
            NavigationStack {
                CoffeeLookupView(review: $review)
            }
        }
        .sheet(isPresented: $showPostViewSheet) {
            NavigationStack {
                PostView(review: review, post: Post())
            }
        }
    }
}

struct ReviewDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ReviewDetailView(review: Review(), previewRunning: true)
                .environmentObject(ReviewViewModel())
        }
    }
}
