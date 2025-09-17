import SwiftUI
import Charts

struct MedicineDetailView: View {
    @State var medicine: Medicine
    @ObservedObject var medicinesVM: MedicineStockViewModel
    @EnvironmentObject var session: SessionStore
    
    @State var isShowingChart: Bool = false
    @State var isShowingEditView: Bool = false
    
    var body: some View {
        VStack(alignment: .leading) {
            List {
                Section {
                    Text(medicine.name)
                        .font(.largeTitle)
                }

                Section("Location") {
                    Text(medicine.aisle)
                }
                
                Section("Stock") {
                    MedicineStockView(medicine: $medicine, medicinesVM: medicinesVM)
                }
                
                Section(isExpanded: $isShowingChart) {
                    historySection
                } header: {
                    Button("History") {
                        isShowingChart.toggle()
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .listRowBackground(Color.customPrimary)
        .scrollContentBackground(.hidden)
        .background {
            Color.background
                .ignoresSafeArea()
        }
        .navigationBarTitle("Medicine Details", displayMode: .inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Edit") {
                    isShowingEditView = true
                }
                .accessibilityElement(children: .ignore)
                .accessibilityLabel("Edit button")
                .accessibilityHint("Double-tap to save changes")
            }
        }
        .sheet(isPresented: $isShowingEditView, content: {
            NavigationStack {
                EditMedicineView(medicine: $medicine, medicinesVM: medicinesVM)
            }
        })
        .onAppear {
            Task {
                await medicinesVM.fetchHistory(for: medicine)
            }
        }
    }
}

extension MedicineDetailView {

    
    private var historySection: some View {

        let linearGradient = LinearGradient(gradient: .init(colors: [Color.lightBlue.opacity(0.8), Color.lightBlue.opacity(0)]), startPoint: .top, endPoint: .bottom)
        
        let history = medicinesVM.history.filter { $0.medicineId == medicine.id }
        
        let sortedHistory = history.sorted(by: { $0.timestamp < $1.timestamp})

        return VStack(alignment: .leading) {
            if history.count > 1 {
                Chart {
                    ForEach(0..<sortedHistory.count, id: \.self) { index in
                        LineMark(
                            x: .value("", index + 1),
                            y: .value("Stock", sortedHistory[index].currentStock)
                        )
                    }
                    .interpolationMethod(.cardinal)
                    .symbol(by: .value("Stock", "stock"))
                    
                    ForEach(0..<history.count, id: \.self) { index in
                        AreaMark(
                            x: .value("", index + 1),
                            y: .value("Stock", sortedHistory[index].currentStock)
                        )
                    }
                    .interpolationMethod(.cardinal)
                    .foregroundStyle(linearGradient)
                }
                .chartLegend(.hidden)
                .chartXAxis(.hidden)
                .aspectRatio(1, contentMode: .fit)
                .padding(.vertical)
                .accessibilityElement(children: .ignore)
            }
            
            ForEach(history, id: \.id) { entry in
                VStack(alignment: .leading, spacing: 5) {
                    Text(entry.user)
                    Text(entry.timestamp.formatted())
                        .font(.footnote)
                    Text(entry.action)
                        .font(.headline)
                }
                .accessibilityElement(children: .ignore)
                .accessibilityLabel("\(entry.details) at \(entry.timestamp)")
                Divider()
            }
        }
    }
}

struct MedicineDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleMedicine = Medicine(
            id: "12",
            name: "Sample",
            stock: 25,
            aisle: "Aisle 1",
            normalStock: 25,
            warningStock: 10,
            alertStock: 5,
            icon: "pills",
            color: "64DEF5"
        )
        let sampleViewModel = MedicineStockViewModel()
        sampleViewModel.history = [
            .init(medicineId: "12", user: "user@test.com", action: "Add new medicine", details: "user@test.com adds Sample with initial stock of 10", currentStock: 10),
        ]
        return NavigationStack {
            MedicineDetailView(medicine: sampleMedicine, medicinesVM: sampleViewModel).environmentObject(SessionStore())
        }
    }
}
