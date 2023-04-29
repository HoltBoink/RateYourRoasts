//
//  PhotoView.swift
//  RateYourRoasts
//
//  Created by Holt Boink on 4/28/23.
//

import SwiftUI
import Firebase

struct PhotoView: View {
    
    @Binding var photo: Photo
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var reviewVM: ReviewViewModel
    var uiImage: UIImage
    var review: Review
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                
                Spacer()
                
                TextField("Description", text: $photo.description)
                    .textFieldStyle(.roundedBorder)
                    .disabled(Auth.auth().currentUser?.email != photo.reviewer)
                
                Text("by: \(photo.reviewer) on: \(photo.postedOn.formatted(date: .numeric, time: .omitted))")
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                
            }
            .padding()
            .toolbar {
                if Auth.auth().currentUser?.email == photo.reviewer {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") {
                            dismiss()
                        }
                    }
                    ToolbarItem(placement: .automatic) {
                        Button("Save") {
                            Task {
                                let success = await reviewVM.saveImage(review: review, photo: photo, image: uiImage)
                                if success {
                                    dismiss()
                                }
                            }
                        }
                    }
                } else {
                    ToolbarItem(placement: .automatic) {
                        Button("Done") {
                            dismiss()
                        }
                    }
                }
                
            }
        }
    }
}

struct PhotoView_Previews: PreviewProvider {
    static var previews: some View {
        PhotoView(photo: .constant(Photo()), uiImage: UIImage(named: "stumptown") ?? UIImage(), review: Review())
            .environmentObject(ReviewViewModel())
    }
}
