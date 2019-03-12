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
    } // init
    
    
    func getUserInfo(userId:String, callback:@escaping ([User])->Void){
 
        
        
        /*
        ref.child("users").observe(.value, with:
            {
                (snapshot) in
                var data = [User]()
                let value = snapshot.value as! [String : Any]
                for(_ , json) in value {
                    data.append(User(jason: json as! [String : Any]))
                }
                callback(data)
        })
         */
    } //getUserInfo
    
    
    
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
        } // while
        
        return FB_id;
        
        //return Auth.auth().currentUser!.uid
    } // getUserID
   
    
    
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
        } // while
        
         return email;
        //return Auth.auth().currentUser!.uid
        //return Auth.auth().currentUser?.email
    } //getUserName()
   
    
    
    func getUser(byId : String)->Void{
        
        
        /*
        getUserInfo(userId: byId, callback: { (data) in
            print(data)
        })
        */
    }
    
    
} //class

