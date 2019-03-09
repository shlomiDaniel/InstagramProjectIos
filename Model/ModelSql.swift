//
//  ModelSql.swift
//  InstagramApplication
//
//  Created by admin on 19/12/2018.
//  Copyright © 2018 SHLOMI. All rights reserved.
//

import Foundation

class ModelSql{
   
    var sqliteDB: OpaquePointer? = nil
    init() {
        let dbFileName = "database2.db"
        if let dir = FileManager.default.urls(for: .documentDirectory, in:
            .userDomainMask).first{
            let path = dir.appendingPathComponent(dbFileName)
            if sqlite3_open(path.absoluteString, &sqliteDB) != SQLITE_OK {
                print("SQLITE3: Failed to open db file: \(path.absoluteString)...")
                return
            }
            else {
                print ("SQLITE3: Successfully connected to SQLite database...");
                print ("SQLITE3: Database path: \(path.absoluteString)");
            }
            //dropTable()
            //creteTable()
            CreateDatabaseStructure()
        }
    }
  
    func CreateDatabaseStructure(){
        print ("SQLITE3: Create Database Structure...");
        
        let createUsersTableString = """
        CREATE TABLE IF NOT EXISTS users(
        id INT PRIMARY KEY NOT NULL,
        FB_id CHAR(255),
        email CHAR(255),
        pass CHAR(255),
        url_profile_image CHAR(255),
        userName CHAR(255),
        user_name_lower_case CHAR(255)
        );
        """;
        
        
        var createUsersTableStatement: OpaquePointer? = nil
        if sqlite3_prepare(sqliteDB, createUsersTableString, -1, &createUsersTableStatement, nil) == SQLITE_OK {
            if sqlite3_step(createUsersTableStatement) == SQLITE_DONE {
                print ("SQLITE3: users table created...")
            } else {
                print ("SQLITE3: users table can't be created...")
            }
        } else {
            print("SQLITE3: CREATE TABLE users statement can't be prepared...")
        }
        
      
        
        
        
    }
    func dropTable(){
        
    }
    
    
}
