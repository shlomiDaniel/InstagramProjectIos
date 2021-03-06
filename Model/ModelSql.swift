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
                //print ("SQLITE3: Successfully connected to SQLite database...");
                //print ("SQLITE3: Local Cache Database path: \(path.absoluteString)");
            }
        }
    } // init
    
  
    func getUser(uid: String) -> User {
        
        var user = User();
        var FB_id: String = "";
        var email: String = "";
        var Password: String = "";
        var localImageFile: String = "";
        var userName: String = "";
        
        let sqlite3_query = "SELECT FB_id, email, pass, localImageFile, userName from users where FB_id = '" + uid + "'";
        var sqlite3_stmt : OpaquePointer? = nil
        //print (sqlite3_query)
        
        if sqlite3_prepare(sqliteDB, sqlite3_query, -1, &sqlite3_stmt, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(sqliteDB)!)
            print("SQLITE3: Error preparing \(sqlite3_query) with error: \(errmsg)");
            return user;
        }
        
        while(sqlite3_step(sqlite3_stmt) == SQLITE_ROW) {
            FB_id = String(cString: sqlite3_column_text(sqlite3_stmt, 0));
            email = String(cString: sqlite3_column_text(sqlite3_stmt, 1));
            Password = String(cString: sqlite3_column_text(sqlite3_stmt, 2));
            localImageFile = String(cString: sqlite3_column_text(sqlite3_stmt, 3));
            userName = String(cString: sqlite3_column_text(sqlite3_stmt, 4));
        } // while

        user = User(_id: FB_id, _userName: userName, _password: Password, _email: email, profile_image_url: localImageFile);
        //print ("DEBUG: 'user = User' : \(user.userName!)");
        return user;
    } //getUser
    
    
    
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
        var localImageFile: String = "";
        var userName: String = "";
        
        
        let sqlite3_query = "SELECT FB_id, email, pass, localImageFile, userName from users where IsCurrentUser = 1;";
        var sqlite3_stmt : OpaquePointer? = nil
        
        if sqlite3_prepare(sqliteDB, sqlite3_query, -1, &sqlite3_stmt, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(sqliteDB)!)
            print("SQLITE3: Error preparing \(sqlite3_query) with error: \(errmsg)");
            return user;
        }
        
        while(sqlite3_step(sqlite3_stmt) == SQLITE_ROW) {
            FB_id = String(cString: sqlite3_column_text(sqlite3_stmt, 0));
            email = String(cString: sqlite3_column_text(sqlite3_stmt, 1));
            Password = String(cString: sqlite3_column_text(sqlite3_stmt, 2));
            localImageFile = String(cString: sqlite3_column_text(sqlite3_stmt, 3));
            userName = String(cString: sqlite3_column_text(sqlite3_stmt, 4));
        } // while
        
        user = User(_id: FB_id, _userName: userName, _password: Password, _email: email, profile_image_url: localImageFile);
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
        var uid: String = "";
        
        let sqlite3_query = "SELECT FB_id, likeCount, localImageFile, text_share, uid FROM posts";
        //print ("DEBUG: POSTS: \(sqlite3_query)");
        var sqlite3_stmt : OpaquePointer? = nil
        
        if sqlite3_prepare(sqliteDB, sqlite3_query, -1, &sqlite3_stmt, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(sqliteDB)!)
            print("SQLITE3: Error preparing \(sqlite3_query) with error: \(errmsg)");
            //return false;
        }
        
        while(sqlite3_step(sqlite3_stmt) == SQLITE_ROW) {
            id = String(cString: sqlite3_column_text(sqlite3_stmt, 0));
            likeCount = Int(sqlite3_column_int(sqlite3_stmt, 1));
            image_url = String(cString: sqlite3_column_text(sqlite3_stmt, 2));
            text_share = String(cString: sqlite3_column_text(sqlite3_stmt, 3));
            uid = String(cString: sqlite3_column_text(sqlite3_stmt, 4));
            let post = Post(_id: id, _likeCount: likeCount, _image_url: image_url, _text_share: text_share, _uid: uid);
            Model.instance.modelFirebase.posts.append(post);
        } // while
        table_view.reloadData();

    }//loadPost
    
    
    func loadUser() {
        
        Model.instance.modelFirebase.users.removeAll();
        
        var id: String = "";
        var email: String = "";
        var pass: String = "";
        var localImageFile: String = "";
        var userName: String = "";
        
        let sqlite3_query = "SELECT FB_id, email, pass, localImageFile, userName  FROM users";
        //print ("DEBUG: USERS: \(sqlite3_query)");
        var sqlite3_stmt : OpaquePointer? = nil
        
        if sqlite3_prepare(sqliteDB, sqlite3_query, -1, &sqlite3_stmt, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(sqliteDB)!)
            print("SQLITE3: Error preparing \(sqlite3_query) with error: \(errmsg)");
            //return false;
        }
        
        while(sqlite3_step(sqlite3_stmt) == SQLITE_ROW) {
            id = String(cString: sqlite3_column_text(sqlite3_stmt, 0));
            email = String(cString: sqlite3_column_text(sqlite3_stmt, 1));
            pass = String(cString: sqlite3_column_text(sqlite3_stmt, 2));
            localImageFile = String(cString: sqlite3_column_text(sqlite3_stmt, 3));
            userName = String(cString: sqlite3_column_text(sqlite3_stmt, 4));
            
            let user = User(_id: id, _userName: userName, _password: pass, _email: email, profile_image_url: localImageFile);
            Model.instance.modelFirebase.users.append(user);
        } // while
        
    }//loadUser
    
    func getPostComments(post_id: String) -> [Comment] {
        var comments = [Comment]();
        var FB_id: String = "";
        var uid: String = "";
        var comment_text: String = "";
        
        
        let sqlite3_query = "select FB_id, comment_text, uid from comments where Fb_id  in (select comment_id from post_comments where post_id = '" + post_id + "')";
        
        print ("DEBUG: POSTS: \(sqlite3_query)");
        var sqlite3_stmt : OpaquePointer? = nil
        
        if sqlite3_prepare(sqliteDB, sqlite3_query, -1, &sqlite3_stmt, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(sqliteDB)!)
            print("SQLITE3: Error preparing \(sqlite3_query) with error: \(errmsg)");
            //return false;
        }
        
        while(sqlite3_step(sqlite3_stmt) == SQLITE_ROW) {
            FB_id = String(cString: sqlite3_column_text(sqlite3_stmt, 0));
            comment_text = String(cString: sqlite3_column_text(sqlite3_stmt, 1));
            uid = String(cString: sqlite3_column_text(sqlite3_stmt, 2));
            print ("DEBUG: Comment = \(FB_id), \(comment_text), \(uid)");
            let comment = Comment(_FB_id: FB_id, _comment_text: comment_text, _uid: uid);
            comments.append(comment);
        } // while
        return comments;
    }
    
} //class

