//
//  Place.swift
//  GoodEats
//
//  Created by Minh Pham on 12/6/23.
//

import Foundation
import MapKit

// Model to store Place struct
struct Place: Identifiable, Equatable, Decodable {
    static func == (lhs: Place, rhs: Place) -> Bool {
        return lhs.id == rhs.id
    }
    
    let id = UUID()
    let name: String
    let latitude: Double
    let longitude: Double
    let score: Double
    let description: String
    
    func hash(into hasher: inout Hasher){
        hasher.combine(id)
        hasher.combine(name)
        hasher.combine(latitude)
        hasher.combine(longitude)
        hasher.combine(score)
        hasher.combine(description)
    }
}
