//
//  Gift.swift
//  Days
//
//  Created by Mark Oelbaum on 03/04/2026.
//

import Foundation
import SQLiteData

@Table
struct Gift: Identifiable {
    let id: UUID
    var name = ""
    var price: Double?
    var isPurchased = false
    var personID: Person.ID
}
