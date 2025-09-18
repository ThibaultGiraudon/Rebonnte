//
//  StockLinearIndicatorView.swift
//  MediStock
//
//  Created by Thibault Giraudon on 16/09/2025.
//

import SwiftUI

struct StockLinearIndicatorView: View {
    var stock: Int
    var normalStock: Int
    var waringStock: Int
    var alertStock: Int
    
    var body: some View {
        HStack {
            GeometryReader { geo in
                let width = geo.size.width
                ZStack(alignment: .leading) {
                        Capsule()
                            .frame(width: width, height: 10)
                            .foregroundStyle(.gray.opacity(0.2))
                        Capsule()
                            .fill(LinearGradient(stops: gradient.stops, startPoint: .leading, endPoint: .trailing))
                            .frame(width: min(width, width * (Double(stock) / Double(normalStock))), height: 10)
                    }
            }
            .frame(maxHeight: 10)
            .scrollDisabled(true)
        }
    }
    
    var gradient: Gradient {
        switch stock {
            case 0...alertStock:
                return .init(colors: [.red, .orange])
            case 0...waringStock:
                return .init(colors: [.orange, .yellow])
            case 0...normalStock:
                return .init(colors: [.green, .teal])
            default:
                return .init(colors: [.green, .teal])
        }
    }
}

#Preview {
    StockLinearIndicatorView(stock: 60, normalStock: 30, waringStock: 10, alertStock: 3)
}
