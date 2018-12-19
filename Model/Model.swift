//
//  Model.swift
//  InstagramApplication
//
//  Created by admin on 20/12/2018.
//  Copyright © 2018 SHLOMI. All rights reserved.
//

import Foundation
class Model{
    
    static let instance : Model = Model()
    
    var modelSql : ModelSql?
    
    private init(){
        modelSql = ModelSql()
    }
    func getAllUsers()->[User]{
        return User.getAllUsers(database: modelSql?.database)
        
        
    }
    func addNewUser(user : User){
        User.addNew(database: modelSql!.database, user: user)
        
    }
    func getUser(byId : String)->User?{
      return  User.get(database: modelSql!.database, byId: byId)
    }
    
}
