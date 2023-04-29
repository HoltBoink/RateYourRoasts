//
//  ReviewDetailView.swift
//  RateYourRoasts
//
//  Created by Holt Boink on 4/27/23.
//

import SwiftUI
import FirebaseFirestoreSwift
import PhotosUI

struct ReviewDetailView: View {
    enum ButtonPressed {
        case post, photo
    }
    
    @EnvironmentObject var reviewVM: ReviewViewModel
    @FirestoreQuery(collectionPath: "reviews") var posts: [Post]
    @State var review: Review
    @Environment(\.dismiss) private var dismiss
    @State private var showingAsSheet = false
    @State private var showCoffeeLookupSheet = false
    @State private var showPostViewSheet = false
    @State private var showSaveAlert = false
    @State private var showPhotoViewSheet = false
    @State private var buttonPressed = ButtonPressed.post
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var uiImageSelected = UIImage()
    
    var previewRunning = false
    var avgRating: String {
        guard posts.count != 0 else {
            return "-.-"
        }
        let averageValue = Double(posts.reduce(0) {$0 + $1.rating}) / Double(posts.count)
        return String(format: "%.1f", averageValue)
    }
    
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
            
            
            HStack {
                Group {
                    Text("Avg. Rating:")
                        .font(.title2)
                        .bold()
                    Text(avgRating)
                        .font(.title)
                        .fontWeight(.black)
                        .foregroundColor(.brown)
                }
                .lineLimit(1)
                .minimumScaleFactor(0.5)
                
                Spacer()
                
                Group {
                    PhotosPicker(selection: $selectedPhoto, matching: .images, preferredItemEncoding: .automatic) {
                        Image(systemName: "photo")
                        Text("Photo")
                    }
                    .onChange(of: selectedPhoto) { newValue in
                        Task {
                            do {
                                if let data = try await newValue?.loadTransferable(type: Data.self) {
                                    if let uiImage = UIImage(data: data) {
                                        uiImageSelected = uiImage
                                        print("Successfully selected Image!")
//                                        newPhoto = Photo()
                                        buttonPressed = .photo
                                        if review.id == nil {
                                            showSaveAlert.toggle()
                                        } else {
                                            showPhotoViewSheet.toggle()
                                        }
                                    }
                                }
                            } catch {
                                print("ERROR: selecting image failed \(error.localizedDescription)")
                            }
                        }
                    }
                    Button("Rate This Roast") {
                        buttonPressed = .post
                        if review.id == nil {
                            showSaveAlert.toggle()
                        } else {
                            showPostViewSheet.toggle()
                        }
                    }
                }
                .font(Font.caption)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
                .buttonStyle(.borderedProminent)
                .tint(.brown)
            }
            .padding(.horizontal)
            
            List {
                Section {
                    ForEach(posts) { post in
                        NavigationLink {
                            PostView(review: review, post: post)
                        } label: {
                            ReviewPostRowView(post: post)
                        }
                        
                    }
                }
            }
            .listStyle(.plain)
            
            Spacer()
            
        }
        .onAppear {
            if !previewRunning && review.id != nil {
                $posts.path = "reviews/\(review.id ?? "")/posts"
                print("posts.path = \($posts.path)")
            } else {
                showingAsSheet = true
            }
        }
        
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(review.id == nil)
        .toolbar {
            if showingAsSheet {
                if review.id == nil && showingAsSheet {
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
                } else if showingAsSheet && review.id != nil {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Done") {
                            dismiss()
                        }
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
        .sheet(isPresented: $showPhotoViewSheet) {
            NavigationStack {
                PhotoView(uiImage: uiImageSelected, review: review)
            }
        }
        .alert("Cannot Rate a Coffee Unless It is Saved", isPresented: $showSaveAlert) {
            Button("Cancel", role: .cancel) {}
            Button("Save", role: .none) {
                Task {
                    let success = await reviewVM.saveReview(review: review)
                    review = reviewVM.review
                    if success {
                        $posts.path = "reviews/\(review.id ?? "")/posts"
//                        $photos.path = "reviews/\(review.id ?? "")/photso"
                        switch buttonPressed {
                        case .post:
                            showPostViewSheet.toggle()
                        case .photo:
                            showPhotoViewSheet.toggle()
                        }
                        showPostViewSheet.toggle()
                    } else {
                        print("Error saving review!")
                    }
                }
            }
        } message: {
            Text("Would you like to save this alert first so that you can enter a review?")
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
