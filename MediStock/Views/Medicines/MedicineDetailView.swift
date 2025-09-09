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
                .accessibilityElement(children: .ignore)
                .accessibilityLabel("Save button")
                .accessibilityHint("Double-tap to save changes")
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
                    Task {
                        medicine.stock -= medicine.stock == 0 ? 0 : 1
                        await medicinesVM.updateStock(for: medicine, by: session.session?.email ?? "", medicine.stock)
                    }
                } label: {
                    Image(systemName: "minus.circle")
                        .font(.title)
                        .foregroundColor(.red)
                }
                .buttonStyle(.plain)
                .accessibilityElement(children: .ignore)
                .accessibilityLabel("Minus button")
                .accessibilityHint("Double-tap to substract one to the stock")
                
                TextField("Stock", value: $medicine.stock, formatter: NumberFormatter())
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.numberPad)
                .frame(width: 100)
                .onSubmit {
                    Task {
                        await medicinesVM.updateStock(for: medicine, by: session.session?.email ?? "", medicine.stock)
                    }
                }
                .onChange(of: medicine.stock) { _, _ in
                    if medicine.stock < 0 {
                        medicine.stock = 0
                    }
                }
                
                Button {
                    Task {
                        medicine.stock += 1
                        await medicinesVM.updateStock(for: medicine, by: session.session?.email ?? "", medicine.stock)
                    }
                } label: {
                    Image(systemName: "plus.circle")
                        .font(.title)
                        .foregroundColor(.green)
                }
                .buttonStyle(.plain)
                .accessibilityElement(children: .ignore)
                .accessibilityLabel("Plus button")
                .accessibilityHint("Double-tap to add one to the stock")
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
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.bottom, 5)
                .accessibilityElement(children: .ignore)
                .accessibilityLabel("\(entry.details) at \(entry.timestamp)")
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
        ]
         return MedicineDetailView(medicine: sampleMedicine, medicinesVM: sampleViewModel).environmentObject(SessionStore())
    }
}
