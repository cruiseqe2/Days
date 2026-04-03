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
        migrator.registerMigration("Create table and index for 'gifts'") { db in
            try #sql(
                """
                CREATE TABLE "gifts" (
                   "id" TEXT PRIMARY KEY NOT NULL ON CONFLICT REPLACE DEFAULT (uuid()),
                    "name" TEXT NOT NULL DEFAULT '',
                    "price" REAL,
                    "isPurchased" INTEGER NOT NULL DEFAULT 0,
                    "personID" TEXT NOT NULL REFERENCES "people"("id") ON DELETE CASCADE
                ) STRICT
                """
            )
            .execute(db)
            try #sql(
                """
                CREATE INDEX "index_gifts_on_personID" ON "gifts"("personID")
                """
            )
            .execute(db)
        }
        try migrator.migrate(database)
        defaultDatabase = database
    }
}
