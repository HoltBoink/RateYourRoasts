//
//  PostViewModel.swift
//  RateYourRoasts
//
//  Created by Holt Boink on 4/28/23.
//

import Foundation
import FirebaseFirestore

class PostViewModel: ObservableObject {
    @Published var post = Post()
    
    func savePost(review: Review, post: Post) async -> Bool {
        let db = Firestore.firestore()
        
        guard let reviewID = review.id else {
            print("ERROR: review.id = nil")
            return false
        }
        let path = "reviews/\(reviewID)/posts"
        
        if let id = post.id {
            do {
                try await db.collection(path).document(id).setData(post.dictionary)
                print("Data updated successfully")
                return true
            } catch {
                print("ERROR: Could not update data in 'post' \(error.localizedDescription)")
                return false
            }
        } else {
            do {
                _ = try await db.collection(path).addDocument(data: post.dictionary)
                print("Data added successfully")
                return true
            } catch {
                print("ERROR: Could not create a new post in 'post' \(error.localizedDescription)")
                return false
            }
        }
    }
    func deleteReview(review: Review, post: Post) async -> Bool {
        let db = Firestore.firestore()
        guard let reviewID = review.id, let postID = post.id else {
            print("😡ERROR: review.id = \(review.id ?? "nil"), post.id = \(post.id ?? "nil"). This should not have happened.")
            return false
        }
        do {
            let _ = try await db.collection("reviews").document(reviewID).collection("posts").document(postID).delete()
            print("🗑️ Document successfully deleted!")
            return true
        } catch {
            print("😡 EROOR: removing document \(error.localizedDescription)")
            return false
        }
    }
}
