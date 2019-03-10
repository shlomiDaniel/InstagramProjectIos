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
        
        let createPostsTableString = """
        CREATE TABLE IF NOT EXISTS posts(
        FB_id CHAR(255),
        likeCount INT,
        photo_url CHAR(255),
        text_share CHAR(255)
        );
        """;
        
        var createPostsTableStatement: OpaquePointer? = nil
        if sqlite3_prepare(sqliteDB, createPostsTableString, -1, &createPostsTableStatement, nil) == SQLITE_OK {
            if sqlite3_step(createPostsTableStatement) == SQLITE_DONE {
                print ("SQLITE3: posts table created...")
            } else {
                print ("SQLITE3: posts table can't be created...")
            }
        } else {
            print("SQLITE3: CREATE TABLE posts statement can't be prepared...")
        }

        
        let createCommentsTableString = """
        CREATE TABLE IF NOT EXISTS comments(
        FB_id CHAR(255),
        comment_text CHAR(255)
        );
        """;
        
        var createCommentsTableStatement: OpaquePointer? = nil
        if sqlite3_prepare(sqliteDB, createCommentsTableString, -1, &createCommentsTableStatement, nil) == SQLITE_OK {
            if sqlite3_step(createCommentsTableStatement) == SQLITE_DONE {
                print ("SQLITE3: comments table created...")
            } else {
                print ("SQLITE3: comments table can't be created...")
            }
        } else {
            print("SQLITE3: CREATE TABLE comments statement can't be prepared...")
        }

        let createPost_CommentsTableString = """
        CREATE TABLE IF NOT EXISTS post_comments(
        post_id CHAR(255),
        comment_id CHAR(255)
        );
        """;
        
        var createPost_CommentsTableStatement: OpaquePointer? = nil
        if sqlite3_prepare(sqliteDB, createPost_CommentsTableString, -1, &createPost_CommentsTableStatement, nil) == SQLITE_OK {
            if sqlite3_step(createPost_CommentsTableStatement) == SQLITE_DONE {
                print ("SQLITE3: post_comments table created...")
            } else {
                print ("SQLITE3: post_comments table can't be created...")
            }
        } else {
            print("SQLITE3: CREATE TABLE post_comments statement can't be prepared...")
        }

        let createMyPostsTableString = """
        CREATE TABLE IF NOT EXISTS myPosts(
        user_id CHAR(255),
        post_id CHAR(255)
        );
        """;
        
        var createMyPostsTableStatement: OpaquePointer? = nil
        if sqlite3_prepare(sqliteDB, createMyPostsTableString, -1, &createMyPostsTableStatement, nil) == SQLITE_OK {
            if sqlite3_step(createMyPostsTableStatement) == SQLITE_DONE {
                print ("SQLITE3: myPosts table created...")
            } else {
                print ("SQLITE3: myPosts table can't be created...")
            }
        } else {
            print("SQLITE3: CREATE TABLE myPosts statement can't be prepared...")
        }

        
        
   } // CreateDBStructure
    
    func CopyTablesFromFirebaseDBIntoSQLiteDB() {
        CopyUsersTable();
        CopyPostsTable();
        CopyPost_CommentsTable();
        CopyMyPostsTable();
        CopyCommentsTable();
        
        //copy other tables;
    
    } //CopyTablesFromFirebaseDBIntoSQLiteDB();
    
    func CopyUsersTable() {
        
        //print ("DEBUG: Starting reading user table...");
        //var usersArr = [User]();
        Model.instance.modelFirebase.ref.child("users").observe(.childAdded, with: {(snapshot) in
            
            //print ("DEBUG: snapshot: \(snapshot)");
            let id = snapshot.key;
            let proObject = snapshot.value as! NSDictionary;
            let email = proObject["email"] as! String;
            let pass = proObject["pass"] as! String;
            let url = proObject["url_profile_image"] as! String;
            let userName = proObject["userName"] as! String;
            
            //print ("DEBUG: id = \(id), email = \(email), pass = \(pass), url = \(url), userName = \(userName)");
            
            let user = User(_id: id, _userName: userName, _password: pass, _email: email, profile_image_url: url);
            self.AddUserToSQLiteDB(user: user);
        })
     
    } //CopyUsersTable
    
    func CopyPostsTable() {
        Model.instance.modelFirebase.ref.child("posts").observe(.childAdded, with: {(snapshot) in
            
            //print ("DEBUG: snapshot: \(snapshot)");
            let id = snapshot.key;
            let proObject = snapshot.value as! NSDictionary;
            let likeCount = proObject["likeCount"] as! Int;
            let photo_url = proObject["photo_url"] as! String;
            let text_share = proObject["text_share"] as! String;
            
            //print ("DEBUG: id = \(id), likeCount = \(likeCount), photo_url = \(photo_url), url = \(text_share)");
            
            let post = Post(_id: id, _likeCount: likeCount, _image_url: photo_url, _text_share: text_share);
            self.AddPostToSQLiteDB(post: post);
        })
    } //CopyPostsTable
    
    func CopyCommentsTable() {
        Model.instance.modelFirebase.ref.child("comments").observe(.childAdded, with: {(snapshot) in
            
            //print ("DEBUG: snapshot: \(snapshot)");
            let id = snapshot.key;
            let proObject = snapshot.value as! NSDictionary;
            let comment_text = proObject["comment_text"] as! String;
            
            //print ("DEBUG: id = \(id), comment_text = \(comment_text)");
            
            let comment = Comment(_uid: id, _comment_text: comment_text);
            self.AddCommentToSQLiteDB(comment: comment);
        })
    } //CopyCommentsTable
    

    func CopyPost_CommentsTable() {
        Model.instance.modelFirebase.ref.child("post_comments").observe(.childAdded, with: {(snapshot) in
            
            //print ("DEBUG: snapshot: \(snapshot)");
            let post_id = snapshot.key;
            let proObject = snapshot.value as! NSDictionary;
            
           
            for key in proObject.allKeys {
                let comment_id = key as! String;
                self.AddPost_CommentToSQLiteDB(_post_id: post_id, _comment_id: comment_id);
                
                //print("DEBUG: post_comments: \(post_id) \(comment_id)");
            }
           
        })
    } //CopyPost_CommentsTable

    
    
    func CopyMyPostsTable() {
        Model.instance.modelFirebase.ref.child("myPosts").observe(.childAdded, with: {(snapshot) in
            
            //print ("DEBUG: snapshot: \(snapshot)");
            let user_id = snapshot.key;
            let proObject = snapshot.value as! NSDictionary;
            
            
            for key in proObject.allKeys {
                let post_id = key as! String;
                self.AddMyPostsToSQLiteDB(_user_id: user_id, _post_id: post_id);
                
                //print("DEBUG: myPosts: \(user_id) \(post_id)");
            }
            
        })
    } //CopyMyPostsTable
    
    
    
    func AddUserToSQLiteDB(user: User) {
        
        var sqlite3_stmt : OpaquePointer? = nil
        
        //print("DEBUG: user for adding: FB_id = \(user.id), email = \(String(describing: user.email)), pass = \(user.Password), url = \(String(describing: user.profile_image_url)), username = \(user.userName!), userName_lowercase = \(String(describing: user.userName?.lowercased()))"  );
        
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
                //print("New user row added seccefully")
            }
            else {
                print ("Error adding user row \(String(describing: user_name))")
            }
        } //
        else {
            print ("Users: SQLITE NOT OK")
        }
        sqlite3_finalize(sqlite3_stmt)
        
    } //AddUserToSQLiteDB
        
        
    func AddPostToSQLiteDB(post: Post) {
        
        var sqlite3_stmt : OpaquePointer? = nil
        
        //print("DEBUG: post for adding: FB_id = \(String(describing: post.id)), likeCount = \(String(describing: post.numberOfLikes)), photo_url = \(String(describing: post.image_url)), text_share = \(String(describing: post.text_share))");
        
        if(sqlite3_prepare_v2(sqliteDB, "INSERT OR REPLACE INTO posts (FB_id, likeCount, photo_url, text_share) VALUES(?,?,?,?);", -1, &sqlite3_stmt, nil)==SQLITE_OK){
            let post_id = post.id!.cString(using: .utf8);
            //let likeCount = post.numberOfLikes as! Int32;
            let likeCount = Int32(post.numberOfLikes!);
            let photo_url = post.image_url!.cString(using: .utf8);
            let text_share = post.text_share!.cString(using: .utf8);
            
            //print("DEBUG: \(post_id!), \(String(describing: likeCount)), \(String(describing: photo_url)), \(String(describing: text_share))");
            
            sqlite3_bind_text(sqlite3_stmt, 1, post_id, -1, nil)
            sqlite3_bind_int(sqlite3_stmt, 2, likeCount);
            sqlite3_bind_text(sqlite3_stmt, 3, photo_url, -1, nil)
            sqlite3_bind_text(sqlite3_stmt, 4, text_share, -1, nil)
            if(sqlite3_step(sqlite3_stmt)==SQLITE_DONE){
                //print("new post row added seccefully")
            }
            else {
                print ("Error adding post row \(String(describing: text_share))")
            }
            
        } //
        else {
            print ("Posts: SQLITE NOT OK")
        }
        sqlite3_finalize(sqlite3_stmt)
        
    } //AddPostToSQLiteDB

    
    func AddCommentToSQLiteDB(comment: Comment) {
        
        var sqlite3_stmt : OpaquePointer? = nil
        
        //print("DEBUG: post for adding: FB_id = \(String(describing: post.id)), likeCount = \(String(describing: post.numberOfLikes)), photo_url = \(String(describing: post.image_url)), text_share = \(String(describing: post.text_share))");
        
        if(sqlite3_prepare_v2(sqliteDB, "INSERT OR REPLACE INTO comments (FB_id, comment_text) VALUES(?,?);", -1, &sqlite3_stmt, nil)==SQLITE_OK){
            let comment_id = comment.uid!.cString(using: .utf8);
            let comment_text = comment.comment_text!.cString(using: .utf8);
            
            //print("DEBUG: comment: \(comment_id!), \(comment_text)");
            
            sqlite3_bind_text(sqlite3_stmt, 1, comment_id, -1, nil)
            sqlite3_bind_text(sqlite3_stmt, 2, comment_text, -1, nil)
            if(sqlite3_step(sqlite3_stmt)==SQLITE_DONE){
                //print("new comment row added seccefully")
            }
            else {
                print ("Error adding comment row \(String(describing: comment_text))")
            }
            
        } //
        else {
            print ("Comments: SQLITE NOT OK")
        }
        sqlite3_finalize(sqlite3_stmt)
        
    } //AddCommentToSQLiteDB

    
    
    func AddPost_CommentToSQLiteDB(_post_id: String, _comment_id: String) {
        
        var sqlite3_stmt : OpaquePointer? = nil
        
        //print("DEBUG: post for adding: FB_id = \(String(describing: post.id)), likeCount = \(String(describing: post.numberOfLikes)), photo_url = \(String(describing: post.image_url)), text_share = \(String(describing: post.text_share))");
        
        if(sqlite3_prepare_v2(sqliteDB, "INSERT OR REPLACE INTO post_comments (post_id, comment_id) VALUES(?,?);", -1, &sqlite3_stmt, nil)==SQLITE_OK){
            let post_id = _post_id.cString(using: .utf8);
            let comment_id = _comment_id.cString(using: .utf8);
            
            //print("DEBUG: comment: \(comment_id!), \(comment_text)");
            
            sqlite3_bind_text(sqlite3_stmt, 1, post_id, -1, nil)
            sqlite3_bind_text(sqlite3_stmt, 2, comment_id, -1, nil)
            if(sqlite3_step(sqlite3_stmt)==SQLITE_DONE){
                //print("new post_comment row added seccefully")
            }
            else {
                print ("Error adding post_comment row \(String(describing: comment_id))")
            }
            
        } //
        else {
            print ("Post_comments: SQLITE NOT OK")
        }
        sqlite3_finalize(sqlite3_stmt)
        
    } //AddPost_CommentToSQLiteDB
    
    
    func AddMyPostsToSQLiteDB(_user_id: String, _post_id: String) {
        
        var sqlite3_stmt : OpaquePointer? = nil
        
        //print("DEBUG: post for adding: FB_id = \(String(describing: post.id)), likeCount = \(String(describing: post.numberOfLikes)), photo_url = \(String(describing: post.image_url)), text_share = \(String(describing: post.text_share))");
        
        if(sqlite3_prepare_v2(sqliteDB, "INSERT OR REPLACE INTO myPosts (user_id, post_id) VALUES(?,?);", -1, &sqlite3_stmt, nil)==SQLITE_OK){
            let user_id = _user_id.cString(using: .utf8);
            let post_id = _post_id.cString(using: .utf8);
            
            //print("DEBUG: comment: \(comment_id!), \(comment_text)");
            
            sqlite3_bind_text(sqlite3_stmt, 1, user_id, -1, nil)
            sqlite3_bind_text(sqlite3_stmt, 2, post_id, -1, nil)
            if(sqlite3_step(sqlite3_stmt)==SQLITE_DONE){
                //print("new MyPosts row added seccefully")
            }
            else {
                print ("Error adding myPosts row \(String(describing: post_id))")
            }
            
        } //
        else {
            print ("myPosts: SQLITE NOT OK")
        }
        sqlite3_finalize(sqlite3_stmt)
        
    } //AddMyPostToSQLiteDB

    
    func dropTable(){
        
    } //dropTable
    
    
} // class
