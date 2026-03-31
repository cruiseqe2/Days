//
//  Person.swift
//  Days
//
//  Created by Mark Oelbaum on 30/03/2026.
//

import Foundation
import SQLiteData

@Table("people")
struct Person: Identifiable {
    let id: UUID
    var name = ""
    var birthDate: Date?
    var notes = ""
}


