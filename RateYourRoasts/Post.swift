//
//  Post.swift
//  RateYourRoasts
//
//  Created by Holt Boink on 4/28/23.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

struct Post: Identifiable, Codable {
    @DocumentID var id: String?
    var title = ""
    var review = ""
    var rating = 0
    var aroma = 0.0
    var flavor = 0.0
    var reviewer = Auth.auth().currentUser?.email ?? ""
    var postedOn = Date()
    
    var dictionary: [String: Any] {
        return["title": title, "review": review, "rating": rating, "aroma": aroma, "flavor": flavor, "reviewer": reviewer, "postedOn": Timestamp(date: Date())]
    }
}
