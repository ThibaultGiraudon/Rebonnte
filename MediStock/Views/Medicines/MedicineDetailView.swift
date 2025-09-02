import SwiftUI
import Charts

struct MedicineDetailView: View {
    @State var medicine: Medicine
    @ObservedObject var medicinesVM: MedicineStockViewModel
    @EnvironmentObject var session: SessionStore

    var body: some View {
        VStack(alignment: .leading) {
            List {
                // Title
                Section {
                    TextField("Name", text: $medicine.name)
                        .font(.largeTitle)
                }

                // Medicine Stock
                Section("Stock") {
                    medicineStockSection
                }
                Section("Location") {
                    // Medicine Aisle
                    TextField("Aisle", text: $medicine.aisle)
                }

                // History Section
                Section("History") {
                    historySection
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
                Button("Save") {
                    Task {
                        await medicinesVM.updateMedicine(medicine, user: session.session?.email ?? "")
                    }
                }
            }
        }
        .onAppear {
            Task {
                await medicinesVM.fetchHistory(for: medicine)
            }
        }
    }
}

extension MedicineDetailView {

    private var medicineStockSection: some View {
        VStack(alignment: .leading) {
            HStack {
                Button {
                    medicine.stock -= 1
                } label: {
                    Image(systemName: "minus.circle")
                        .font(.title)
                        .foregroundColor(.red)
                }
                .buttonStyle(.plain)
                TextField("Stock", value: $medicine.stock, formatter: NumberFormatter())
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.numberPad)
                .frame(width: 100)
                Button {
                    medicine.stock += 1
                } label: {
                    Image(systemName: "plus.circle")
                        .font(.title)
                        .foregroundColor(.green)
                }
                .buttonStyle(.plain)
            }
        }
    }

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
            }
            
            ForEach(history, id: \.id) { entry in
                VStack(alignment: .leading, spacing: 5) {
                    HStack {
                        Text(entry.user)
                        Spacer()
                        Text(entry.timestamp.formatted())
                    }
                    Text(entry.action)
                        .font(.headline)
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.bottom, 5)
            }
        }
    }
}

struct MedicineDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleMedicine = Medicine(id: "12", name: "Sample", stock: 25, aisle: "Aisle 1")
        let sampleViewModel = MedicineStockViewModel()
        sampleViewModel.history = [
            .init(medicineId: "12", user: "user@test.com", action: "Add new medicine", details: "user@test.com adds Sample with initial stock of 10", currentStock: 10),
//            .init(medicineId: "12", user: "user@test.com", action: "Increasing stock of 2", details: "Stock change from 10 to 12", currentStock: 12),
//            .init(medicineId: "12", user: "user@test.com", action: "Increasing stock of 3", details: "Stock change from 12 to 15", currentStock: 15),
//            .init(medicineId: "12", user: "user@test.com", action: "Increasing stock of 6", details: "Stock change from 15 to 21", currentStock: 21),
//            .init(medicineId: "12", user: "user@test.com", action: "Decreasing stock of 2", details: "Stock change from 21 to 19", currentStock: 19),
//            .init(medicineId: "12", user: "user@test.com", action: "Increasing stock of 19", details: "Stock change from 19 to 38", currentStock: 38),
//            .init(medicineId: "12", user: "user@test.com", action: "Decreasing stock of 10", details: "Stock change from 38 to 28", currentStock: 28),
//            .init(medicineId: "12", user: "user@test.com", action: "Increasing stock of 3", details: "Stock change from 28 to 25", currentStock: 25),
        ]
         return MedicineDetailView(medicine: sampleMedicine, medicinesVM: sampleViewModel).environmentObject(SessionStore())
    }
}
