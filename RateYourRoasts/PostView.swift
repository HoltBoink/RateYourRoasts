//
//  PostView.swift
//  RateYourRoasts
//
//  Created by Holt Boink on 4/28/23.
//

import SwiftUI
import Firebase

struct PostView: View {
    @State var review: Review
    @State var post: Post
    @State var postedByThisUser = false
    @Environment(\.dismiss) private var dismiss
    
    @State private var rateOrReviewerString = "Click to Rate:"
    @State private var isEditing = false
    @State private var isEditing2 = false
    @State private var isEditing3 = false
    @State private var isEditing4 = false
    @StateObject var postVM = PostViewModel()
    
    var body: some View {
//        NavigationStack {
            VStack {
                VStack (alignment: .leading){
                    Text(review.name)
                        .font(.title)
                        .bold()
                        .multilineTextAlignment(.leading)
                        .lineLimit(1)
                    
                    Text(review.coffeeName)
                }
                .padding(.horizontal)
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Spacer()
                
                Text(rateOrReviewerString)
                    .font(postedByThisUser ? .title2 : .subheadline)
                    .bold(postedByThisUser)
                    .minimumScaleFactor(0.5)
                    .lineLimit(1)
                    .padding(.horizontal)
                
                HStack {
                    StarSelectionView(rating: $post.rating)
                        .disabled(!postedByThisUser)
                        .overlay {
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(.gray.opacity(0.5), lineWidth: postedByThisUser ? 2 : 0)
                        }
                }
                .padding(.bottom)
                
                VStack (alignment: .leading) {
                    Text("Review Title:")
                        .bold()
                    
                    TextField("title", text: $post.title)
                        .padding(.horizontal, 6)
                        .overlay {
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(.gray.opacity(0.5), lineWidth: postedByThisUser ? 2 : 0)
                        }
                    
                    Text("Review")
                        .bold()
                    
                    TextField("review", text: $post.review, axis: .vertical)
                        .padding(.horizontal, 6)
                        .frame(maxHeight: 100, alignment: .topLeading)
                        .overlay {
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(.gray.opacity(0.5), lineWidth: postedByThisUser ? 2 : 0)
                        }
                    
                    Group {
                        HStack {
                            Text("Aroma:")
                            let rounded = Int(post.aroma)
                            Text("\(rounded)")
                                .foregroundColor(isEditing ? .red : .blue)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        Slider(value: $post.aroma, in: 0...10, step: 1) {
                            Text("Aroma")
                        } minimumValueLabel: {
                            Text("0")
                        } maximumValueLabel: {
                            Text("10")
                        } onEditingChanged: { editing in
                            isEditing = editing
                        }
                        HStack {
                            Text("Flavor:")
                            let rounded = Int(post.flavor)
                            Text("\(rounded)")
                                .foregroundColor(isEditing4 ? .red : .blue)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        Slider(value: $post.flavor, in: 0...10, step: 1) {
                            Text("Body")
                        } minimumValueLabel: {
                            Text("0")
                        } maximumValueLabel: {
                            Text("10")
                        } onEditingChanged: { editing in
                            isEditing4 = editing
                        }
                    }
                    .padding(.horizontal)
                }
                .disabled(!postedByThisUser)
                .padding(.horizontal)
                
                Spacer()
            }
            .onAppear {
                if post.reviewer == Auth.auth().currentUser?.email {
                    postedByThisUser = true
                } else {
                    let reviewPostedOn = post.postedOn.formatted(date: .numeric, time: .omitted)
                    rateOrReviewerString = "by: \(post.reviewer) on: \(reviewPostedOn)"
                }
            }
            .navigationBarBackButtonHidden(postedByThisUser)
        
        .toolbar {
            if postedByThisUser {
                ToolbarItemGroup(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button("Save") {
                        Task {
                            let success = await postVM.savePost(review: review, post: post)
                            if success {
                                dismiss()
                            } else {
                                print("ERROR saving data in PostView")
                            }
                        }
                    }
                }
                if post.id != nil {
                    ToolbarItemGroup (placement: .bottomBar) {
                        Spacer()
                        Button {
                            Task {
                                let success = await postVM.deleteReview(review: review, post: post)
                                if success {
                                    dismiss()
                                }
                            }
                        } label: {
                            Image(systemName: "trash")
                        }
                        
                    }
                }
            }
        }
    }
}

struct PostView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            PostView(review: Review(name: "Counter Culture", coffeeName: "Double Trouble"), post: Post())
        }
    }
}
