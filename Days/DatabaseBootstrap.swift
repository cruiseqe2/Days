//
//  DatabaseBootstrap.swift
//  Days
//
//  Created by Mark Oelbaum on 30/03/2026.
//

import Foundation
import SQLiteData

extension DependencyValues {
    mutating func bootstrapDatabase() throws {
        let database = try SQLiteData.defaultDatabase()
        var migrator = DatabaseMigrator()
        
        #if DEBUG
        migrator.eraseDatabaseOnSchemaChange = true
        #endif
        
        migrator.registerMigration("Create the 'people' table") { db in
            try #sql(
                 """
                 CREATE TABLE "people" (
                    "id" TEXT PRIMARY KEY NOT NULL ON CONFLICT REPLACE DEFAULT (uuid()),
                    "name" TEXT NOT NULL DEFAULT '',
                    "birthDate" TEXT,
                    "notes" TEXT NOT NULL DEFAULT ''
                 ) STRICT
                 """
            )
            .execute(db)
        }
        try migrator.migrate(database)
        defaultDatabase = database
    }
}
