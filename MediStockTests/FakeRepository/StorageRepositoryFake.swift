//
//  StorageRepositoryFake.swift
//  MediStockTests
//
//  Created by Thibault Giraudon on 02/09/2025.
//

import Foundation
import SwiftUI
@testable import MediStock

class StorageRepositoryFake: StorageRepositoryInterface {
    var imageURL: String = ""
    var error: Error?
    func uploadImage(_ uiImage: UIImage, to path: String) async throws -> String {
        if let error {
            throw error
        }
        return imageURL
    }
    
    func deleteImage(with url: String) async throws {
        if let error {
            throw error
        }
    }
    
    
}
