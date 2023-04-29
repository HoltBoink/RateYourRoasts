//
//  StarsSelectionView.swift
//  RateYourRoasts
//
//  Created by Holt Boink on 4/28/23.
//

import SwiftUI

struct StarSelectionView: View {
    @Binding var rating: Int
    let highestRating = 5
    let unselected = Image("bean")
    let selected = Image("beanfill")
    var scaleNum = 40.0
    @State var interactive = true
    
    var body: some View {
        HStack {
            ForEach(1...highestRating, id: \.self) { number in
                showStar(for: number)
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: scaleNum)
                    .onTapGesture {
                        if interactive {
                            rating = number
                        }
                    }
            }
        }
    }
    func showStar( for number: Int) -> Image {
        if number > rating {
            return unselected
        } else {
            return selected
        }
    }
}

struct StarSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        StarSelectionView(rating: .constant(4))
    }
}
