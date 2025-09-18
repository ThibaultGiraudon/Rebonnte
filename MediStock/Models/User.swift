//
//  User.swift
//  MediStock
//
//  Created by Thibault Giraudon on 04/09/2025.
//

import Foundation

struct User: Equatable {
    var uid: String
    var email: String
    var fullname: String
    var imageURL: String
    
    init() {
        self.uid = UUID().uuidString
        self.email = ""
        self.fullname = ""
        self.imageURL = ""
    }
    
    init(uid: String, email: String, fullname: String, imageURL: String = "") {
        self.uid = uid
        self.email = email
        self.fullname = fullname
        self.imageURL = imageURL
    }
    
    init?(_ data: [String: Any]?) {
        guard let data, let email = data["email"] as? String,
              let uid = data["uid"] as? String,
              let fullname = data["fullname"] as? String,
              let imageURL = data["imageURL"] as? String
        else {
            return nil
        }
        
        self.uid = uid
        self.email = email
        self.fullname = fullname
        self.imageURL = imageURL
    }
    
    func data() -> [String: Any] {
        let data: [String: Any] = [
            "uid": self.uid,
            "email": self.email,
            "fullname": self.fullname,
            "imageURL": self.imageURL
        ]
        
        return data
    }
    
}
