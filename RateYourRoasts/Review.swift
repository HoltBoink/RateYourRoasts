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
    
    var dictionary: [String: Any] {
        return["name": name, "coffeeName": coffeeName]
    }
}
