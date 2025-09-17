import SwiftUI

struct ContentView: View {
    @EnvironmentObject var session: SessionStore
    @EnvironmentObject var coordinator: AppCoordinator
    @StateObject var medicinesVM = MedicineStockViewModel()
    @StateObject var addMedicineVM = AddMedicineViewModel()
    @StateObject var aislesVM = AislesViewModel()
    @StateObject var addAisleVM = AddAisleViewModel()
    
    var body: some View {
        NavigationStack(path: $coordinator.path) {
            VStack {
                switch session.authenticationState {
                case .signedIn:
                    MainTabView(
                        medicinesVM: medicinesVM,
                        addMedicinesVM: addMedicineVM,
                        aislesVM: aislesVM,
                        addAisleVM: addAisleVM
                    )
                case .signedOut:
                    LoginView()
                }
            }
                .navigationDestination(for: AppRoute.self) { route in
                    switch route {
                    case .home:
                        VStack {
                            switch session.authenticationState {
                            case .signedIn:
                                MainTabView(
                                    medicinesVM: medicinesVM,
                                    addMedicinesVM: addMedicineVM,
                                    aislesVM: aislesVM,
                                    addAisleVM: addAisleVM
                                )
                            case .signedOut:
                                LoginView()
                            }
                        }
                    case .signIn:
                        LoginView()
                    case .register:
                        RegisterView()
                    case .detail(let medicine):
                        MedicineDetailView(medicine: medicine, medicinesVM: medicinesVM)
                    case .aisleDetail(let aisle):
                        AisleDetailView(aisle: aisle, aisleViewModel: aislesVM, medicinesVM: medicinesVM)
                    case .addMedicine:
                        AddMedicineView(addMedicinesVM: addMedicineVM)
                    }
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(SessionStore())
            .environmentObject(AppCoordinator())
    }
}
