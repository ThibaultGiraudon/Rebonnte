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
                    case .medicinesList(let aisle):
                        MedicineListView(medicinesVM: medicinesVM, aisle: aisle)
                            .navigationTitle(aisle)
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
