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
    @Dependency(\.defaultDatabase) var database
//    @State private var newPerson = false
    @State private var person: Person.Draft?
    
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
                        .swipeActions(edge: .leading) {
                            Button {
                                self.person = Person.Draft(person)
                            } label: {
                                Label("Edit", systemImage: "pencil")
                            }
                            .tint(.yellow)
                        }
                        .swipeActions(edge: .trailing) {
                            Button(role: .destructive) {
                                withErrorReporting {
                                    try database.write { db in
                                        try Person
                                            .delete(person)
                                            .execute(db)
                                    }
                                }
                            }
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("People")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
//                        newPerson = true
                        person = Person.Draft()
                    } label: {
                        Image(systemName: "plus.circle.fill")
                    }
                }
            }
//            .sheet(isPresented: $newPerson) {
//                PersonForm()
//            }
            .sheet(item: $person) { person in
                PersonForm(person: person)
            }
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
