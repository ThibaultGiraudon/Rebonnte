//
//  StorageRepositoryProtocol.swift
//  MediStock
//
//  Created by Thibault Giraudon on 02/09/2025.
//

import Foundation
import SwiftUI

/// Interface for managing images in Firebase Storage.
/// This protocol allows injection of real or mock repository for testing.
protocol StorageRepositoryInterface {
    
    /// Uploads a new image in Storage.
    ///
    /// - Parameters:
    ///   - uiImage: The image to save.
    ///   - path: The UID from which build the path.
    /// - Returns: A `String` representing the location of the image.
    /// - Throws: An `Error` if the operation fails.
    func uploadImage(_ uiImage: UIImage, to path: String) async throws -> String
    
    /// Deletes an image from Firebase
    ///
    /// - Parameter url: The location of the image to delete
    /// - Throws: An `Error` if the operation fails.
    func deleteImage(with url: String) async throws
}
