//
//  Review.swift
//  RateYourRoasts
//
//  Created by Holt Boink on 4/27/23.
//

import Foundation
import FirebaseFirestoreSwift

struct Review: Identifiable, Codable {
    @DocumentID var id: String?
    var name = ""
    var coffeeName = ""
    var bodyRating = 0.0
    var aroma = 0.0
    var acidity = 0.0
    var flavor = 0.0
    
    var dictionary: [String: Any] {
        return["name": name, "coffeeName": coffeeName, "bodyRating": bodyRating, "aroma": aroma, "acidity": acidity, "flavor": flavor]
    }
}
