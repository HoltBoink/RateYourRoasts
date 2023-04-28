//
//  ReviewViewModel.swift
//  RateYourRoasts
//
//  Created by Holt Boink on 4/27/23.
//

import Foundation
import FirebaseFirestore

class ReviewViewModel: ObservableObject {
    @Published var review = Review()
    
    func saveReview(review: Review) async -> Bool {
        let db = Firestore.firestore()
        
        if let id = review.id {
            do {
                try await db.collection("reviews").document(id).setData(review.dictionary)
                print("Data updated successfully")
                return true
            } catch {
                print("ERROR: Could not update data in 'reviews' \(error.localizedDescription)")
                return false
            }
        } else {
            do {
                _ = try await db.collection("reviews").addDocument(data: review.dictionary)
                print("Data added successfully")
                return true
            } catch {
                print("ERROR: Could not create a new review in 'reviews' \(error.localizedDescription)")
                return false
            }
        }
    }
}
