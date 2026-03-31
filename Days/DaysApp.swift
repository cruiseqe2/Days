//
//  DaysApp.swift
//  Days
//
//  Created by Mark Oelbaum on 29/03/2026.
//

import SQLiteData
import SwiftUI

@main
struct DaysApp: App {
    init() {
        prepareDependencies {
            do {
                try $0.bootstrapDatabase()
            } catch {
                fatalError("Failed to bootstrap database: \(error)")
            }
        }
    }
    
    var body: some Scene {
        WindowGroup {
            PersonListView()
                .onAppear {
                    print("Database:\n\(URL.applicationSupportDirectory.path(percentEncoded: false))")
                }
        }
    }
}
