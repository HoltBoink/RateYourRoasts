//
//  Recipe.swift
//  RateYourRoasts
//
//  Created by Holt Boink on 4/28/23.
//

import Foundation

struct Recipe: Codable, Identifiable {
    let id: Int
    var title: String
    var description: String
    var ingredients: [String]
    
//    enum CodingKeys: CodingKey {
//        case title, description, ingredients
//    }
}
