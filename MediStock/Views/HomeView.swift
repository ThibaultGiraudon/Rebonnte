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
    @ObservedObject var addMedicineVM: AddMedicineViewModel
    var body: some View {
        VStack {
            switch session.authenticationState {
            case .signedIn:
                MainTabView(medicinesVM: medicinesVM, addMedicinesVM: addMedicineVM)
            case .signedOut:
                LoginView()
            }
        }
    }
}

#Preview {
    HomeView(session: SessionStore(), medicinesVM: MedicineStockViewModel(), addMedicineVM: AddMedicineViewModel())
}
