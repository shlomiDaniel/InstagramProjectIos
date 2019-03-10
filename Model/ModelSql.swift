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
            CopyTablesFromFirebaseDBIntoSQLiteDB();
        }
    } //init
  
    func CreateDatabaseStructure(){
        print ("SQLITE3: Create Database Structure...");
        
        let createUsersTableString = """
        CREATE TABLE IF NOT EXISTS users(
        
        FB_id CHAR(255),
        email CHAR(255),
        pass CHAR(255),
        url_profile_image CHAR(255),
        userName CHAR(255),
        user_name_lower_case CHAR(255)
        );
        """;
        //id INT PRIMARY KEY NOT NULL,
        
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
   } // CreateDBStructure
    
    func CopyTablesFromFirebaseDBIntoSQLiteDB() {
        CopyUsersTable();
        CopyPostsTable();
        //copy other tables;
    
    } //CopyTablesFromFirebaseDBIntoSQLiteDB();
    
    func CopyUsersTable() {
        
        print ("DEBUG: Starting reading user table...");
        //var usersArr = [User]();
        Model.instance.modelFirebase.ref.child("users").observe(.childAdded, with: {(snapshot) in

            let proObject = snapshot.value as! NSDictionary;
            let id = "abcd";
            let email = proObject["email"] as! String;
            let pass = proObject["pass"] as! String;
            let url = proObject["url_profile_image"] as! String;
            let userName = proObject["userName"] as! String;
            
            //print ("DEBUG: id = \(id), email = \(email), pass = \(pass), url = \(url), userName = \(userName)");
            
            let user = User(_id: id, _userName: userName, _password: pass, _email: email, profile_image_url: url);
            //print ("DEBUG: user for appending is: \(user.userName!)");
            //usersArr.append(user);
            self.AddUserToSQLiteDB(user: user);
                
                /*
                let value = snapshot.value as! [String : Any]
                //print("DEBUG: Snapshot.key: \(snapshot.key)")
                for
                for(_ , json) in value {
                    //print("DEBUG: Translating user into JSON...");
                    print("DEBUG: json in value: \(json)");
                    print("DEBUG: value.first in value:\(String(describing: value.first?.key))");
                    let id = String;
                    print(" ");
                    print("Printing VALUE");
                    
                    print(value);
                    jason
                    users.append(User(jason: json as! [String : Any]))
                */
                
        })

        
        
    } //CopyUsersTable
    
    func CopyPostsTable() {
        
    } //CopyPostsTable
    
    
    func AddUserToSQLiteDB(user: User) {
        
        var sqlite3_stmt : OpaquePointer? = nil
        
        print("DEBUG: user for adding: FB_id = \(user.id), email = \(String(describing: user.email)), pass = \(user.Password), url = \(String(describing: user.profile_image_url)), username = \(user.userName!), userName_lowercase = \(String(describing: user.userName?.lowercased()))"  );
        
        if(sqlite3_prepare_v2(sqliteDB, "INSERT OR REPLACE INTO users (FB_id, email, pass, url_profile_image, userName, user_name_lower_case) VALUES(?,?,?,?,?,?);", -1, &sqlite3_stmt, nil)==SQLITE_OK){
            let user_id = user.id.cString(using: .utf8)
            let email = user.email!.cString(using: .utf8)
            let pass = user.Password.cString(using: .utf8)
            let url = user.profile_image_url!.cString(using: .utf8)
            let user_name = user.userName?.cString(using: .utf8)
            let user_name_lower_case = user.userName?.lowercased().cString(using: .utf8)
            
            //print("\(user_id!), \(email), \(pass), \(url), \(user_name), \(user_name_lower_case)");
            
            sqlite3_bind_text(sqlite3_stmt, 1, user_id, -1, nil)
            sqlite3_bind_text(sqlite3_stmt, 2, email, -1, nil)
            sqlite3_bind_text(sqlite3_stmt, 3, pass, -1, nil)
            sqlite3_bind_text(sqlite3_stmt, 4, url, -1, nil)
            sqlite3_bind_text(sqlite3_stmt, 5, user_name, -1, nil)
            sqlite3_bind_text(sqlite3_stmt, 6, user_name_lower_case, -1, nil)
            if(sqlite3_step(sqlite3_stmt)==SQLITE_DONE){
                print("new row added seccefully")
            }
            else {
                print ("Error adding row \(String(describing: user_name))")
            }
            
        } //
        else {
            print ("SQLITE NOT OK")
        }
        sqlite3_finalize(sqlite3_stmt)
        
        
        
        
        
        /*
        print("DEBUG: user for adding: FB_id = \(user.id), email = \(String(describing: user.email)), pass = \(user.Password), url = \(String(describing: user.profile_image_url)), username = \(user.userName!), userName_lowercase = \(String(describing: user.userName?.lowercased()))"  );
        let insertStatementString =
        "INSERT INTO users (id, FB_id, email, pass, url_profile_image, userName, user_name_lower_case) VALUES (?, ?, ?, ?, ?, ?, ?);"
            
        var insertStatement: OpaquePointer? = nil;
            
        if sqlite3_prepare_v2(sqliteDB, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
            let id: Int32 = 1;
            let FB_id = user.id;
            let email = user.email;
            let pass = user.Password;
            let url_profile_image = user.profile_image_url;
            let userName = user.userName;
            let user_name_lower_case = user.userName?.lowercased();
        
            
            sqlite3_bind_int(insertStatement, 1, id);
            sqlite3_bind_text(insertStatement, 2, FB_id, -1, nil);
            sqlite3_bind_text(insertStatement, 3, email, -1, nil);
            sqlite3_bind_text(insertStatement, 4, pass, -1, nil);
            sqlite3_bind_text(insertStatement, 5, url_profile_image, -1, nil);
            sqlite3_bind_text(insertStatement, 6, userName, -1, nil);
            sqlite3_bind_text(insertStatement, 7, user_name_lower_case, -1, nil);
            
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print ("SQLITE3: Successfully inserted user \(userName ?? "userName"), \(email ?? "email")");
            } else {
                print("SQLITE3: Could not insert row - user \(userName ?? "userName"), \(email ?? "email")");
            }
            
        } //if sqlite3_prepare_v2
        else {
            print ("SQLITE3: INSERT statement caould not be prepared - AddUserToSQLiteDB...");
        }
 */
    } //AddUserToSQLiteDB
        
        
        
        
    func dropTable(){
        
    } //dropTable
    
    
} // class
