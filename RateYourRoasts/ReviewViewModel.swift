//
//  ReviewViewModel.swift
//  RateYourRoasts
//
//  Created by Holt Boink on 4/27/23.
//

import Foundation
import FirebaseFirestore
import UIKit
import FirebaseStorage
@MainActor

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
                let documentRef = try await db.collection("reviews").addDocument(data: review.dictionary)
                self.review = review
                self.review.id = documentRef.documentID
                print("Data added successfully")
                return true
            } catch {
                print("ERROR: Could not create a new review in 'reviews' \(error.localizedDescription)")
                return false
            }
        }
    }
    func saveImage(review: Review, photo: Photo, image: UIImage) async -> Bool {
        guard let reviewID = review.id else {
            print("ERROR: spot.id == nil")
            return false
        }
        
        var photoName = UUID().uuidString
        if photo.id != nil {
            photoName = photo.id!
        }
        let storage = Storage.storage()
        let storageRef = storage.reference().child("\(reviewID)/\(photoName).jpeg")
        
        guard let resizedImage = image.jpegData(compressionQuality: 0.2) else {
            print("ERROR: Could not resize image")
            return false
        }
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpg"
        
        var imageURLString = ""
        
        do {
            let _ = try await storageRef.putDataAsync(resizedImage, metadata: metadata)
            print("Image saved!")
            do {
                let imageURL = try await storageRef.downloadURL()
                imageURLString = "\(imageURL)"
            } catch {
                print("ERROR: Could not get imageURL after saving image")
                return false
            }
        } catch {
            print("ERROR: uploading image to FirebaseStorage")
            return false
        }
        let db = Firestore.firestore()
        let collectionString = "reviews/\(reviewID)/photos"
        
        do {
            var newPhoto = photo
            newPhoto.imageURLString = imageURLString
            try await db.collection(collectionString).document(photoName).setData(newPhoto.dictionary)
            print("Data updated successfully!")
            return true
        } catch {
            print("ERROR: Could not update data in 'photos' \(reviewID)")
            return false
        }
    }
}
