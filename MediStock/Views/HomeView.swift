//
//  HomeView.swift
//  MediStock
//
//  Created by Thibault Giraudon on 02/09/2025.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var session: SessionStore
    @ObservedObject var medicinesVM: MedicineStockViewModel
    var body: some View {
        VStack {
            switch session.authenticationState {
            case .signingIn:
                ProgressView()
            case .signedIn:
                MainTabView()
            case .signedOut:
                LoginView()
            }
        }
    }
}

#Preview {
    HomeView(session: SessionStore(), medicinesVM: MedicineStockViewModel())
}
