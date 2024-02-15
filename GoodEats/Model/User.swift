//
//  User.swift
//  GoodEats
//
//  Created by Minh Pham on 12/5/23.
//

import Foundation

struct User: Hashable {
    var email: String
    var firstName: String
    var lastName: String
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(email)
    }
}
