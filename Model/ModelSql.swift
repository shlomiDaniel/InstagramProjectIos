//
//  ModelSql.swift
//  InstagramApplication
//
//  Created by admin on 19/12/2018.
//  Copyright © 2018 SHLOMI. All rights reserved.
//

import Foundation
class ModelSql{
   
    var database: OpaquePointer? = nil
    init() {
        let dbFileName = "database2.db"
        if let dir = FileManager.default.urls(for: .documentDirectory, in:
            .userDomainMask).first{
            let path = dir.appendingPathComponent(dbFileName)
            if sqlite3_open(path.absoluteString, &database) != SQLITE_OK {
                print("Failed to open db file: \(path.absoluteString)")
                return
            }
            //dropTable()
            //creteTable()
            CreateTable()
        }
    }
  
    func CreateTable(){
        
        
    }
    func dropTable(){
        
    }
    
    
}
