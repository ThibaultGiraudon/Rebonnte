//
//  StorageRepositoryProtocol.swift
//  MediStock
//
//  Created by Thibault Giraudon on 02/09/2025.
//

import Foundation
import SwiftUI

protocol StorageRepositoryInterface {
    func uploadImage(_ uiImage: UIImage, to path: String) async throws -> String
    func deleteImage(with url: String) async throws
}
