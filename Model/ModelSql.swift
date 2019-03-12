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
        } // while
        
        user = User(_id: FB_id, _userName: userName, _password: Password, _email: email, profile_image_url: profile_image_url);
        return user;
        
    } //getUser
    
    
    func sign_Out() -> Bool {
       //update IsCurrentUser = 0 return true else return false
        
        let updateStatementString = "UPDATE users set isCurrentUser = 0 WHERE isCurrentUser = 1;";
        var updateStatement: OpaquePointer? = nil;
        //print ("DEBUG: UPDATE statement: \(updateStatementString)");
        
        if sqlite3_prepare(sqliteDB, updateStatementString, -1, &updateStatement, nil) == SQLITE_OK {
            if sqlite3_step(updateStatement) == SQLITE_DONE {
                //print ("DEBUG: SQLITE3: Successfully update row in USERS with  \(localFileName)");
                return(true);
            }  else {
                print ("DEBUG: SQLITE3: could not update row -= UPDATE users set isCurrentUser = 0 WHERE isCurrentUser = 1; =-")
                return false;
            }
        }   else {
            print ("DEBUG: SQLITE3: UPDATE Statement could not be prepared");
            return false;
        }
    } //sign_Out
    

    func checkIfSignIn() -> Bool {
        
        var count: Int = 0;
        
        let sqlite3_query = "SELECT COUNT (*) FROM users where IsCurrentUser = 1";
        var sqlite3_stmt : OpaquePointer? = nil
        
        if sqlite3_prepare(sqliteDB, sqlite3_query, -1, &sqlite3_stmt, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(sqliteDB)!)
            print("SQLITE3: Error preparing -=SELECT FB_id FROM users where IsCurrentUser = 1=- with error: \(errmsg)");
            return false;
        }
        
        while(sqlite3_step(sqlite3_stmt) == SQLITE_ROW) {
            count = Int(sqlite3_column_int(sqlite3_stmt, 0));
        } // while
        
        if count == 1 {
            return true
        } else
        {
            return false;
        }
    } //checkIfSignIn
    
    
    
    func signInByEmailAndPass(email: String, pass: String, callback: @escaping (Bool?)->Void) {
        
        // check user and password
        //if correct, update this user as signed\
        //callback true or false

        let sqlite3_query = "SELECT pass FROM users where email = '" + email + "'";
        var sqlite3_stmt : OpaquePointer? = nil
        
        if sqlite3_prepare(sqliteDB, sqlite3_query, -1, &sqlite3_stmt, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(sqliteDB)!)
            print("SQLITE3: Error preparing -=SELECT FB_id FROM users where IsCurrentUser = 1=- with error: \(errmsg)");
            callback(false);
        }
        
        while(sqlite3_step(sqlite3_stmt) == SQLITE_ROW) {
            let DBPassword = String(cString: sqlite3_column_text(sqlite3_stmt, 0));
            if ((DBPassword.elementsEqual(pass)) == true)
            {
                let updateStatementString = "UPDATE users set isCurrentUser = 1 WHERE email = '" + email + "';";
                print ("Debug: \(updateStatementString)");
                var updateStatement: OpaquePointer? = nil;
                //print ("DEBUG: UPDATE statement: \(updateStatementString)");
                
                if sqlite3_prepare(sqliteDB, updateStatementString, -1, &updateStatement, nil) == SQLITE_OK {
                    if sqlite3_step(updateStatement) == SQLITE_DONE {
                        //print ("DEBUG: SQLITE3: Successfully update row in USERS with  \(localFileName)");
                        callback(true);
                    }  else {
                        print ("DEBUG: SQLITE3: could not update row \(email)")
                        callback(false);
                    }
                }   else {
                    print ("DEBUG: SQLITE3: UPDATE Statement could not be prepared");
                    callback(false);
                }
            }
            else
            {
                callback(false)
            }
        } // while
    }//signInByEmailAndPass
    
    
    
    func loadPost(table_view: UITableView) {
        
        Model.instance.modelFirebase.posts.removeAll();
        
        var id: String = "";
        var likeCount: Int = 0;
        var image_url: String = "";
        var text_share: String = "";
        
        let sqlite3_query = "SELECT FB_id, likeCount, localImageFile, text_share FROM posts";
        print ("DEBUG: POSTS: \(sqlite3_query)");
        var sqlite3_stmt : OpaquePointer? = nil
        
        if sqlite3_prepare(sqliteDB, sqlite3_query, -1, &sqlite3_stmt, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(sqliteDB)!)
            print("SQLITE3: Error preparing -=SELECT FB_id, likeCount, localImageFile, text_share FROM posts=- with error: \(errmsg)");
            //return false;
        }
        
        while(sqlite3_step(sqlite3_stmt) == SQLITE_ROW) {
            id = String(cString: sqlite3_column_text(sqlite3_stmt, 0));
            likeCount = Int(sqlite3_column_int(sqlite3_stmt, 1));
            image_url = String(cString: sqlite3_column_text(sqlite3_stmt, 2));
            text_share = String(cString: sqlite3_column_text(sqlite3_stmt, 3));
            let post = Post(_id: id, _likeCount: likeCount, _image_url: image_url, _text_share: text_share);
            Model.instance.modelFirebase.posts.append(post);
        } // while
        table_view.reloadData();

    }//loadPost
    
    
    func loadUser() {
        
        Model.instance.modelFirebase.users.removeAll();
        
        var id: String = "";
        var email: String = "";
        var pass: String = "";
        var url_profile_image: String = "";
        var userName: String = "";
        
        let sqlite3_query = "SELECT FB_id, email, pass, localImageFile, userName  FROM users";
        print ("DEBUG: POSTS: \(sqlite3_query)");
        var sqlite3_stmt : OpaquePointer? = nil
        
        if sqlite3_prepare(sqliteDB, sqlite3_query, -1, &sqlite3_stmt, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(sqliteDB)!)
            print("SQLITE3: Error preparing -=SELECT FB_id, email, pass, localImageFile, userName  FROM users=- with error: \(errmsg)");
            //return false;
        }
        
        while(sqlite3_step(sqlite3_stmt) == SQLITE_ROW) {
            id = String(cString: sqlite3_column_text(sqlite3_stmt, 0));
            email = String(cString: sqlite3_column_text(sqlite3_stmt, 1));
            pass = String(cString: sqlite3_column_text(sqlite3_stmt, 2));
            url_profile_image = String(cString: sqlite3_column_text(sqlite3_stmt, 3));
            userName = String(cString: sqlite3_column_text(sqlite3_stmt, 4));
            
            let user = User(_id: id, _userName: userName, _password: pass, _email: email, profile_image_url: url_profile_image);
            Model.instance.modelFirebase.users.append(user);
        } // while
        
    }//loadUser
    
    
} //class

