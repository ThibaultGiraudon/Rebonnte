import SwiftUI

enum TabItem: String, CaseIterable {
    case aisles
    case medicines
    case profile
    
    var icon: String {
        switch self {
        case .aisles:
            "list.bullet.circle"
        case .medicines:
            "square.grid.2x2"
        case .profile:
            "person.fill"
        }
    }
}

struct MainTabView: View {
    @EnvironmentObject var session: SessionStore
    @StateObject var medicinesVM = MedicineStockViewModel()
    @StateObject var addMedicinesVM = AddMedicineViewModel()
    
    @State private var activeError: String?
    @State private var selectedTab: TabItem = .aisles
    
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
                switch selectedTab {
                case .aisles:
                    AisleListView(medicinesVM: medicinesVM, addMedicinesVM: addMedicinesVM)
                case .medicines:
                    AllMedicinesView(medicinesVM: medicinesVM, addMedicinesVM: addMedicinesVM)
                case .profile:
                    ProfileView()
                }
                
                HStack(spacing: 33) {
                    ForEach(TabItem.allCases, id: \.self) { tab in
                        VStack {
                            Image(systemName: tab.icon)
                                .font(.title)
                            Text(tab.rawValue)
                        }
                        .foregroundStyle(selectedTab == tab ? .lightBlue : .primaryText)
                        .onTapGesture {
                            selectedTab = tab
                        }
                        .accessibilityElement(children: .ignore)
                        .accessibilityIdentifier(tab.rawValue)
                        .accessibilityLabel(tab.rawValue)
                        .accessibilityHint(selectedTab == tab ? "" : "Double-tap to open \(tab.rawValue) view")
                    }
                }
                .frame(maxWidth: .infinity)
            }
        }
        .onReceive(session.$error) { if let err = $0 { activeError = err} }
        .onReceive(medicinesVM.$error) { if let err = $0 { activeError = err} }
        .onReceive(addMedicinesVM.$error) { if let err = $0 { activeError = err} }
        .background {
            Color.background
                .ignoresSafeArea()
        }
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        let session = SessionStore()
        MainTabView()
            .environmentObject(session)
    }
}
