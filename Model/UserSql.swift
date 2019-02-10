//
//  UserSql.swift
//  InstagramApplication
//
//  Created by admin on 19/12/2018.
//  Copyright © 2018 SHLOMI. All rights reserved.
//

import Foundation

extension User{
    //init ( _id : String , _name : String , _phone : String , _url : String , _userName : String , _password : String){
    static func createTable (database : OpaquePointer?){
        var errorMsg : UnsafeMutablePointer<Int8>? = nil
        let res = sqlite3_exec(database, "CREATE TABLE IF NOT EXISTS USERS (USER_ID TEXT PRIMARY KEY, NAME TEXT , PHONE TEXT , URL TEXT , USER_NAME TEXT ,  PASSWORD_TEXT)"
            , nil, nil, &errorMsg);
            if(res != 0){
            print("error creating table");
            return
        }
            
        
    }
    
    static func getAllUsers(database : OpaquePointer?)->[User]
    {
        var sqlite_stmt : OpaquePointer? = nil
        var data = [User]()
        if(sqlite3_prepare_v2(database, "SELECT * FROM USERS;", -1, &sqlite_stmt, nil)) == SQLITE_ROW{
            while(sqlite3_step(sqlite_stmt)==SQLITE_ROW){
                let user_id = String(cString: sqlite3_column_text(sqlite_stmt, 0)!)
                let name = String(cString: sqlite3_column_text(sqlite_stmt, 1)!)
                let phone = String(cString: sqlite3_column_text(sqlite_stmt, 2)!)
                let url = String(cString: sqlite3_column_text(sqlite_stmt, 3)!)
                let user_name = String(cString: sqlite3_column_text(sqlite_stmt, 4)!)
                let password = String(cString: sqlite3_column_text(sqlite_stmt,5)!)
                data.append(User(_id: user_id, _name: name, _phone: phone, _url: url, _userName: user_name, _password: password))
            }
            
        }
        sqlite3_finalize(sqlite_stmt)
        return data
        
        
        
    }
    
    static func addNew(database : OpaquePointer? , user : User){
        var sqlite3_stmt : OpaquePointer? = nil
        if(sqlite3_prepare_v2(database, "INSERT OR REPLAVE INTO USERS(USER_ID, NAME, PHONE, URL, USER_NAME, PASSWORD VALUES(?,?,?,?,?,?))", -1, &sqlite3_stmt, nil)==SQLITE_OK){
            let user_id = user.id.cString(using: .utf8)
            let name = user.name.cString(using: .utf8)
            let phone = user.phone.cString(using: .utf8)
            let url = user.url.cString(using: .utf8)
            let user_name = user.userName?.cString(using: .utf8)
            let password = user.Password.cString(using: .utf8)
            
              sqlite3_bind_text(sqlite3_stmt, 1, user_id, -1, nil)
              sqlite3_bind_text(sqlite3_stmt, 2, name, -1, nil)
              sqlite3_bind_text(sqlite3_stmt, 3, phone, -1, nil)
              sqlite3_bind_text(sqlite3_stmt, 4, url, -1, nil)
              sqlite3_bind_text(sqlite3_stmt, 5, user_name, -1, nil)
              sqlite3_bind_text(sqlite3_stmt, 6, password, -1, nil)
            if(sqlite3_step(sqlite3_stmt)==SQLITE_DONE){
                print("new row added seccefully")
            }
            
        }
        sqlite3_finalize(sqlite3_stmt)
        
    }
    static func get(database : OpaquePointer?, byId : String)->User?{
        return nil
    }
   
    
    
    
    
    
    
}
