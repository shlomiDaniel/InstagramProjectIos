//
//  Model.swift
//  InstagramApplication
//
//  Created by admin on 20/12/2018.
//  Copyright © 2018 SHLOMI. All rights reserved.
//
import UIKit
import Foundation
class ModelNotification{
    
    static let usersListNotification = MyNotification<[User]>("app.InstagramApplication.userlist")
   // static let studentsListNotification = MyNotification<[Student]>("com.menachi.studentlist")
    
    class MyNotification<T>{
        let name:String
        var count = 0;
        
        init(_ _name:String) {
            name = _name
        }
        func observe(cb:@escaping (T)->Void)-> NSObjectProtocol{
            count += 1
            return NotificationCenter.default.addObserver(forName: NSNotification.Name(name),
                                                          object: nil, queue: nil) { (data) in
                                                            if let data = data.userInfo?["data"] as? T {
                                                                cb(data)
                                                            }
            }
        }
        
        func notify(data:T){
            NotificationCenter.default.post(name: NSNotification.Name(name),
                                            object: self,
                                            userInfo: ["data":data])
        }
        
        func remove(observer: NSObjectProtocol){
            count -= 1
            NotificationCenter.default.removeObserver(observer, name: nil, object: nil)
        }
        
        
    }
    
}


class Model {
    static let instance:Model = Model()
    
    
    //var modelSql:ModelSql?
    var modelFirebase = ModelFireBase();
    
 
    
    private init(){
        //modelSql = ModelSql()
    }
    
    
    
    func getAllUsers() {
        modelFirebase.getAllUsers(callback: {(data:[User]) in
            ModelNotification.usersListNotification.notify(data: data)
            
        })
    }
    
    func getAllUsers(callback:@escaping ([User])->Void){
        modelFirebase.getAllUsers(callback: callback);
    }
    
    func addNewStudent(user : User){
        modelFirebase.addNewUser(user: user)
    }
       
    
    func saveImage(image : UIImage, name:(String),child:(String),text:(String),callback:@escaping (String?)->Void){
        modelFirebase.saveImage(image: image, name: name,child: child,text: text, callback: callback)
    }
    
    func getImage(url:String, callback:@escaping (UIImage?)->Void){
        modelFirebase.getImage(url: url, callback: callback)
    }
    
}
