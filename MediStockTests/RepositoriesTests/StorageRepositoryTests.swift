//
//  StorageRepositoryTests.swift
//  MediStockTests
//
//  Created by Thibault Giraudon on 04/09/2025.
//

import XCTest
@testable import MediStock
import FirebaseAuth

final class StorageRepositoryTests: XCTestCase {

    func testUploadAndDeleteImageShouldSucceed() async {
        let repository = StorageRepository()
        
        guard let image = loadImage(named: "charles-leclerc.jpg") else {
            XCTFail("Failed to get UIImage")
            return
        }
        
        do {
            try await Auth.auth().createUser(withEmail: "test@test.app", password: "12345678")
            let url = try await repository.uploadImage(image, to: "profils_image")
            XCTAssert(!url.isEmpty, "URL should not be empty")
            try await repository.deleteImage(with: url)
        } catch {
            XCTFail("Upload or delete image failed with: \(error)")
        }
    }
    
    func testUploadImageShouldFailed() async {
        let repository = StorageRepository()
        let image = UIImage()
        
        do {
            _ = try await repository.uploadImage(image, to: "profils_image")
            XCTFail("Uploading image should fails.")
        } catch {
            XCTAssertEqual(error.localizedDescription, URLError(.badURL).localizedDescription)
        }
    }
    
    func loadImage(named name: String) -> UIImage? {
        let bundle = Bundle(for: type(of: self))
        guard let url = bundle.url(forResource: name, withExtension: nil),
              let data = try? Data(contentsOf: url),
              let image = UIImage(data: data) else {
            return nil
        }
        return image
    }
}
