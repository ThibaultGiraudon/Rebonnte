//
//  StockCircleIndicatorView.swift
//  MediStock
//
//  Created by Thibault Giraudon on 16/09/2025.
//

import SwiftUI

struct StockCircleIndicatorView: View {
    var stock: Int
    var normalStock: Int
    var waringStock: Int
    var alertStock: Int
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 15)
                .frame(width: 100)
                .foregroundStyle(.gray.opacity(0.2))
            Circle()
                .trim(from: 0.0, to: CGFloat(Double(stock) / Double(normalStock)))
                .stroke(style: StrokeStyle(lineWidth: 15, lineCap: .round))
                .fill(AngularGradient(gradient: gradient, center: .center, startAngle: .zero, endAngle: .init(degrees: 360.0 * CGFloat(Double(stock) / Double(normalStock)))))
                .frame(width: 100)
                .rotationEffect(Angle(degrees: 270.0))
            Text("\(stock)")
                .font(.largeTitle)
                .foregroundStyle(gradient)
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Stock indicator")
        .accessibilityValue("\(stock) medicines available out of \(normalStock),  warning level: \(waringStock), alert level: \(alertStock)")
    }
    
    var gradient: Gradient {
        switch stock {
        case 0:
            return .init(colors: [.red])
            case 0...alertStock:
                return .init(colors: [.orange, .red])
            case 0...waringStock:
                return .init(colors: [.yellow, .orange])
            case 0...normalStock:
                return .init(colors: [.green, .teal])
            default:
                return .init(colors: [.green, .teal])
        }
    }
}

#Preview {
    StockCircleIndicatorView(stock: 5, normalStock: 25, waringStock: 10, alertStock: 5)
}
