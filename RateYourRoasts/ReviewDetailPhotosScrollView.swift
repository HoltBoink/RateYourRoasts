//
//  ReviewDetailPhotosScrollView.swift
//  RateYourRoasts
//
//  Created by Holt Boink on 4/28/23.
//

import SwiftUI

struct ReviewDetailPhotosScrollView: View {
    @State private var showPhotoViewerView = false
    @State private var uiImage = UIImage()
    @State private var selectedPhoto = Photo()
    var photos: [Photo]
    var review: Review
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: true) {
            HStack (spacing: 4) {
                ForEach(photos) { photo in
                    let imageURL = URL(string:  photo.imageURLString) ?? URL(string: "")
                    
                    AsyncImage(url: imageURL) { image in
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: 80, height: 80)
                            .clipped()
                            .onTapGesture {
                                let renderer = ImageRenderer(content: image)
                                selectedPhoto = photo
                                uiImage = renderer.uiImage ?? UIImage()
                                showPhotoViewerView.toggle()
                            }
                    } placeholder: {
                        ProgressView()
                            .frame(width: 80, height: 80)
                    }

                }
            }
        }
        .frame(height: 80)
        .padding(.horizontal, 4)
        .sheet(isPresented: $showPhotoViewerView) {
            PhotoView(photo: $selectedPhoto, uiImage: uiImage, review: review)
        }
    }
}


struct ReviewDetailPhotosScrollView_Previews: PreviewProvider {
    static var previews: some View {
        ReviewDetailPhotosScrollView(photos: [Photo(imageURLString: "https://firebasestorage.googleapis.com:443/v0/b/rateyourroasts-985be.appspot.com/o/2evGaesW27alMGGDvlCe%2FB0626E89-4445-4807-B529-F0E2562F1BB7.jpeg?alt=media&token=ae1422d6-4de3-4761-bec5-770582615075" )], review: Review(id: "2evGaesW27alMGGDvlCe"))
    }
}
