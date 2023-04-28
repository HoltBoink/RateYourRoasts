//
//  PostView.swift
//  RateYourRoasts
//
//  Created by Holt Boink on 4/28/23.
//

import SwiftUI

struct PostView: View {
    @State var review: Review
    @State var post: Post
    @Environment(\.dismiss) private var dismiss
    
    @State private var isEditing = false
    @State private var isEditing2 = false
    @State private var isEditing3 = false
    @State private var isEditing4 = false
    
    var body: some View {
        NavigationStack {
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
                
                Text("Click to Rate:")
                    .font(.title2)
                    .bold()
                
                HStack {
                    StarSelectionView(rating: post.rating)
                        .overlay {
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(.gray.opacity(0.5), lineWidth: 2)
                        }
                }
                .padding(.bottom)
                
                VStack (alignment: .leading) {
                    Text("Review Title:")
                        .bold()
                    
                    TextField("title", text: $post.title)
                        .textFieldStyle(.roundedBorder)
                        .overlay {
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(.gray.opacity(0.5), lineWidth: 2)
                        }
                    
                    Text("Review")
                        .bold()
                    
                    TextField("review", text: $post.review, axis: .vertical)
                        .padding(.horizontal, 6)
                        .frame(maxHeight: 100, alignment: .leading)
                        .overlay {
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(.gray.opacity(0.5), lineWidth: 2)
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
                            Text("Acidity:")
                            let rounded = Int(post.acidity)
                            Text("\(rounded)")
                                .foregroundColor(isEditing2 ? .red : .blue)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        Slider(value: $post.acidity, in: 0...10, step: 1) {
                            Text("Acidity")
                        } minimumValueLabel: {
                            Text("0")
                        } maximumValueLabel: {
                            Text("10")
                        } onEditingChanged: { editing in
                            isEditing2 = editing
                        }
                        HStack {
                            Text("Body:")
                            let rounded = Int(post.bodyRating)
                            Text("\(rounded)")
                                .foregroundColor(isEditing3 ? .red : .blue)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        Slider(value: $post.bodyRating, in: 0...10, step: 1) {
                            Text("Body")
                        } minimumValueLabel: {
                            Text("0")
                        } maximumValueLabel: {
                            Text("10")
                        } onEditingChanged: { editing in
                            isEditing3 = editing
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
                .padding(.horizontal)
                
                Spacer()
            }
        }
        .toolbar {
            ToolbarItemGroup(placement: .cancellationAction) {
                Button("Cancel") {
                    dismiss()
                }
            }
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button("Save") {
                    //TODO: Save code
                    dismiss()
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
