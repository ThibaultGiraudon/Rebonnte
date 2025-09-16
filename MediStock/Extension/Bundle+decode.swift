//
//  Bundle+decode.swift
//  MediStock
//
//  Created by Thibault Giraudon on 16/09/2025.
//

import Foundation

extension Bundle {
    func decode(_ fileName: String) -> [String] {
        if let url = Bundle.main.url(forResource: fileName, withExtension: "txt") {
            if let data = try? String(contentsOf: url) {
                let datas = data.components(separatedBy: "\n")
                
                return datas
            }
        }
        return []
    }
}
