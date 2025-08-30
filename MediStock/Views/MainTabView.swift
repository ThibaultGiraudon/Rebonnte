import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var session: SessionStore
    @StateObject var medicinesVM = MedicineStockViewModel()
    @StateObject var addMedicinesVM = AddMedicineViewModel()
    
    @State private var activeError: String?
    
    var body: some View {
        VStack {
            if let error = activeError {
                ErrorView(error: error) {
                    Task {
                        await medicinesVM.fetchMedicines()
                        activeError = nil
                    }
                }
            } else {
                TabView {
                    AisleListView(medicinesVM: medicinesVM, addMedicinesVM: addMedicinesVM)
                        .tabItem {
                            Image(systemName: "list.dash")
                            Text("Aisles")
                        }
                    
                    AllMedicinesView(medicinesVM: medicinesVM, addMedicinesVM: addMedicinesVM)
                        .tabItem {
                            Image(systemName: "square.grid.2x2")
                            Text("All Medicines")
                        }
                    
                    ProfileView()
                        .tabItem {
                            Image(systemName: "person.fill")
                            Text("Profile")
                        }
                }
            }
        }
        .onReceive(session.$error) { if let err = $0 { activeError = err} }
        .onReceive(medicinesVM.$error) { if let err = $0 { activeError = err} }
        .onReceive(addMedicinesVM.$error) { if let err = $0 { activeError = err} }
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        let session = SessionStore()
        MainTabView()
            .environmentObject(session)
    }
}
