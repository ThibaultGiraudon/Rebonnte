//
//  StorageRepository.swift
//  MediStock
//
//  Created by Thibault Giraudon on 27/08/2025.
//

import Foundation
import FirebaseStorage
import SwiftUI

class StorageRepository {
    let storage: Storage
    let ref: StorageReference
    
    init() {
        storage = Storage.storage()
        ref = storage.reference()
    }
    
    /// Uploads the given image to Firebase Storage.
    ///
    /// - Parameter uiImage: The `UIImage` to be uploaded.
    /// - Returns: a `String` representing the url where the image is saved.
    /// - Throws: an `Error` if an operation fails.
    func uploadImage(_ uiImage: UIImage, to path: String) async throws -> String {
        let newID = UUID().uuidString
        let imageRef = ref.child("\(path)/\(newID).jpg")
        
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        
        guard let data = uiImage.pngData() else {
            throw URLError(.badURL)
        }
        
        _ = try await imageRef.putDataAsync(data, metadata: metaData)
        let downloadURL = try await imageRef.downloadURL()
        
        return downloadURL.absoluteString
    }
    
    /// Deletes the given image in Firebase Storage.
    ///
    /// - Parameter with: The url where the image is saved.
    /// - Throws: an `Error` if delete fails.
    func deleteImage(with url: String) async throws {
        try await storage.reference(forURL: url).delete()
    }
}
