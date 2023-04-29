//
//  ReviewPostRowView.swift
//  RateYourRoasts
//
//  Created by Holt Boink on 4/28/23.
//

import SwiftUI

struct ReviewPostRowView: View {
    @State var post: Post
    
    var body: some View {
        VStack (alignment: .leading) {
            Text(post.title)
                .font(.title2)
                .lineLimit(1)
            HStack {
                StarSelectionView(rating: $post.rating, scaleNum: 25, interactive: false)
                Text(post.review)
                    .font(.callout)
                    .lineLimit(1)
            }
        }
    }
}

struct ReviewPostRowView_Previews: PreviewProvider {
    static var previews: some View {
        ReviewPostRowView(post: Post(title: "Stumptown Coffee Roaster", review: "Really tasty and bright. It had hints of blueberry!", rating: 4, aroma: 9, flavor: 6))
    }
}
