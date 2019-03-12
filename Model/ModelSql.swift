//
//  ModelSql.swift
//  InstagramApplication
//
//  Created by admin on 19/12/2018.
//  Copyright © 2018 SHLOMI. All rights reserved.
//

import Foundation
import Firebase

class ModelSql{
    
    var sqliteDB: OpaquePointer? = nil;
    
    init () {
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
                print ("SQLITE3: Local Cache Database path: \(path.absoluteString)");
                }
            }
    }
    
    
    func getUserInfo(userId:String, callback:@escaping ([User])->Void){
 
    }
    
    
    
    func getUserId()->String{
        
        var FB_id: String = "";
        let sqlite3_query = "SELECT FB_id FROM users where IsCurrentUser = 1;";
        var sqlite3_stmt : OpaquePointer? = nil
        
        if sqlite3_prepare(sqliteDB, sqlite3_query, -1, &sqlite3_stmt, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(sqliteDB)!)
            print("SQLITE3: Error preparing -=SELECT FB_id FROM users where IsCurrentUser = 1=- with error: \(errmsg)");
            return "";
        }
        
        while(sqlite3_step(sqlite3_stmt) == SQLITE_ROW) {
            FB_id = String(cString: sqlite3_column_text(sqlite3_stmt, 0));
        }
        
        return FB_id;
    }
   
    
    
    func getUserName()->String?{

        var email: String = "";
        let sqlite3_query = "SELECT email FROM users where IsCurrentUser = 1;";
        var sqlite3_stmt : OpaquePointer? = nil
        
        if sqlite3_prepare(sqliteDB, sqlite3_query, -1, &sqlite3_stmt, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(sqliteDB)!)
            print("SQLITE3: Error preparing -=SELECT FB_id FROM users where IsCurrentUser = 1=- with error: \(errmsg)");
            return "";
        }
        
        while(sqlite3_step(sqlite3_stmt) == SQLITE_ROW) {
            email = String(cString: sqlite3_column_text(sqlite3_stmt, 0));
        }
        
         return email;
    }
   
    
    
    func getUser()->User{
        
        var user = User();
        var FB_id: String = "";
        var email: String = "";
        var Password: String = "";
        var profile_image_url: String = "";
        var userName: String = "";
        
        
        let sqlite3_query = "SELECT FB_id, email, pass, url_profile_image, userName where IsCurrentUser = 1;";
        var sqlite3_stmt : OpaquePointer? = nil
        
        if sqlite3_prepare(sqliteDB, sqlite3_query, -1, &sqlite3_stmt, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(sqliteDB)!)
            print("SQLITE3: Error preparing -=SELECT FB_id, email, pass, url_profile_image, userName where IsCurrentUser = 1;=- with error: \(errmsg)");
            return user;
        }
        
        while(sqlite3_step(sqlite3_stmt) == SQLITE_ROW) {
            FB_id = String(cString: sqlite3_column_text(sqlite3_stmt, 0));
            email = String(cString: sqlite3_column_text(sqlite3_stmt, 1));
            Password = String(cString: sqlite3_column_text(sqlite3_stmt, 2));
            profile_image_url = String(cString: sqlite3_column_text(sqlite3_stmt, 3));
            userName = String(cString: sqlite3_column_text(sqlite3_stmt, 4));
        }
        
        user = User(_id: FB_id, _userName: userName, _password: Password, _email: email, profile_image_url: profile_image_url);
        return user;
    }
    
 
    func sign_Out() -> Bool {
        
        return true;
    } //sign_Out
    
    
    //Model Firebase has 2 arrays: Users and Posts
    func loadPost () {
        
    }
    
    func checkIfSignIn() -> Bool {
       
        return true;
    } //checkIfSignIn
    
    func signInByEmailAndPass(email: String, pass: String, callback: @escaping (Bool?)->Void) {
    
        callback (true);
        callback (false);
    }
    
    
    
    
    
} //class

