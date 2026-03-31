//
//  PersonListView.swift
//  Days
//
//  Created by Mark Oelbaum on 29/03/2026.
//

import SQLiteData
import SwiftUI

struct PersonListView: View {
//    @FetchAll private var people: [Person]
    @FetchAll(Person.order(by: \.name)) private var people
    
    var body: some View {
        NavigationStack {
            Group {
                if people.isEmpty {
                    ContentUnavailableView("No People", systemImage: "person.2")
                } else {
                    List(people) { person in
                        VStack(alignment: .leading) {
                            HStack {
                                Text(person.name)
                                    .font(.headline)
                                Spacer()
                                if let birthDate = person.birthDate {
                                    Text(birthDate, format: .dateTime.month(.abbreviated).day().year())
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                }
                            }
                            Text(person.notes)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("People")
        }
    }
}

#Preview {
    let _ = prepareDependencies {
        do {
            try $0.bootstrapDatabase()
            try $0.seedDatabaseForPreviews()
        } catch {
            fatalError("Failed to bootstrap database for previews: \(error)")
        }
    }
    PersonListView()
}
