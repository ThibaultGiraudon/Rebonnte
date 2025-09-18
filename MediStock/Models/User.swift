//
//  User.swift
//  MediStock
//
//  Created by Thibault Giraudon on 04/09/2025.
//

import Foundation

/// Represents a user objext
///
/// Each `User` is identified with its unique id, email, fullname and imageURL
struct User: Equatable {
    
    // MARK: - Propeties
    
    /// The unique identifier of the user.
    var uid: String
    
    /// The user's email.
    var email: String
        
    /// The user's fullname.
    var fullname: String

    /// The user's image location..
    var imageURL: String
    
    // MARK: - Initializers
    
    /// Creates a new empty `User`
    init() {
        self.uid = UUID().uuidString
        self.email = ""
        self.fullname = ""
        self.imageURL = ""
    }
    
    
    /// Creates a new `User` with provided information.
    ///
    /// - Parameters:
    ///   - uid: The unique identifer of the user.
    ///   - email: The email of the user.
    ///   - fullname: The fullname of the user
    ///   - imageURL: The image location.
    init(uid: String, email: String, fullname: String, imageURL: String = "") {
        self.uid = uid
        self.email = email
        self.fullname = fullname
        self.imageURL = imageURL
    }
    
    /// Creates a new `User` from a dictionary.
    ///
    /// This failable initializer attempts to build an `User` using the values
    /// provided in the given dictionary. If any required key is missing or
    /// contains an invalid type, initialization will fail and return `nil`.
    ///
    /// - Parameter data: A dictionary containing the aisle's properties.
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
    
    // MARK: - Methods
    
    /// Converts the `User` into a dictionary representation.
    ///
    /// Useful when saving the user in a database.
    ///
    /// - Returns: A `[String: Any]` dictionary containing all the aisle properties.
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
