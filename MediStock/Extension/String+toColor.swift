//
//  String+toColor.swift
//  MediStock
//
//  Created by Thibault Giraudon on 16/09/2025.
//

import Foundation
import SwiftUI

extension String {
    func toColor() -> Color {
        if self.count != 6 && self.count != 8 {
            return .black
        }
        
        var hex: UInt64 = 0
        
        guard Scanner(string: self).scanHexInt64(&hex) else {
            return .black
        }
        
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 1.0
        
        if self.count == 8 {
            r = CGFloat((hex >> 24) & 0xff) / 255.0
            g = CGFloat((hex >> 16) & 0x00ff) / 255.0
            b = CGFloat((hex >> 8) & 0x00ff) / 255.0
            a = CGFloat(hex & 0x000000ff) / 255.0
        } else {
            r = CGFloat((hex >> 16) & 0xff) / 255.0
            g = CGFloat((hex >> 8) & 0x00ff) / 255.0
            b = CGFloat(hex & 0x00ff) / 255.0
        }
        
        return Color(red: r, green: g, blue: b, opacity: a)
    }
}
