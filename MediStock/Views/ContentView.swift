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
            HomeView(
                session: session,
                medicinesVM: medicinesVM,
                addMedicineVM: addMedicineVM,
                aislesVM: aislesVM,
                addAisleVM: addAisleVM
            )
                .navigationDestination(for: AppRoute.self) { route in
                    switch route {
                    case .home:
                        HomeView(
                            session: session,
                            medicinesVM: medicinesVM,
                            addMedicineVM: addMedicineVM,
                            aislesVM: aislesVM,
                            addAisleVM: addAisleVM
                        )
                    case .signIn:
                        LoginView()
                    case .register:
                        RegisterView()
                    case .detail(let medicine):
                        MedicineDetailView(medicine: medicine, medicinesVM: medicinesVM)
                    case .aisleDetail(let aisle):
                        AisleDetailView(aisle: aisle, aisleViewModel: aislesVM, medicinesVM: medicinesVM)
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
