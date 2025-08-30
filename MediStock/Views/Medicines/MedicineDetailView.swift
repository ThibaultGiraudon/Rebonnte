import SwiftUI
import Charts

struct MedicineDetailView: View {
    @State var medicine: Medicine
    @ObservedObject var viewModel: MedicineStockViewModel
    @EnvironmentObject var session: SessionStore

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Title
                Text(medicine.name)
                    .font(.largeTitle)
                    .padding(.top, 20)

                // Medicine Name
                medicineNameSection

                // Medicine Stock
                medicineStockSection

                // Medicine Aisle
                medicineAisleSection

                // History Section
                historySection
            }
            .padding(.vertical)
        }
        .navigationBarTitle("Medicine Details", displayMode: .inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Save") {
                    Task {
                        print(viewModel.medicines)
                        await viewModel.updateMedicine(medicine, user: session.session?.email ?? "")
                    }
                }
            }
        }
        .onAppear {
            Task {
//                await viewModel.fetchHistory(for: medicine)
            }
        }
    }
}

extension MedicineDetailView {
    private var medicineNameSection: some View {
        VStack(alignment: .leading) {
            Text("Name")
                .font(.headline)
            TextField("Name", text: $medicine.name)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding(.bottom, 10)
        }
        .padding(.horizontal)
    }

    private var medicineStockSection: some View {
        VStack(alignment: .leading) {
            Text("Stock")
                .font(.headline)
            HStack {
                Button {
                    medicine.stock -= 1
                } label: {
                    Image(systemName: "minus.circle")
                        .font(.title)
                        .foregroundColor(.red)
                }
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
            }
            .padding(.bottom, 10)
        }
        .padding(.horizontal)
    }

    private var medicineAisleSection: some View {
        VStack(alignment: .leading) {
            Text("Aisle")
                .font(.headline)
            TextField("Aisle", text: $medicine.aisle)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding(.bottom, 10)
        }
        .padding(.horizontal)
    }

    private var historySection: some View {
        VStack(alignment: .leading) {
            let history = viewModel.history.filter { $0.medicineId == medicine.id }
            Text("History")
                .font(.headline)
                .padding(.top, 20)
            
            Chart {
                ForEach(0..<history.count, id: \.self) { index in
                    LineMark(
                        x: .value("Date", history[index].timestamp),
                        y: .value("Stock", history[index].currentStock)
                        )
                }
            }
            
            ForEach(viewModel.history.filter { $0.medicineId == medicine.id }, id: \.id) { entry in
                VStack(alignment: .leading, spacing: 5) {
                    Text(entry.action)
                        .font(.headline)
                    Text("User: \(entry.user)")
                        .font(.subheadline)
                    Text("Date: \(entry.timestamp.formatted())")
                        .font(.subheadline)
                    Text("Details: \(entry.details)")
                        .font(.subheadline)
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.bottom, 5)
            }
        }
        .padding(.horizontal)
    }
}

struct MedicineDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleMedicine = Medicine(id: "12", name: "Sample", stock: 25, aisle: "Aisle 1")
        let sampleViewModel = MedicineStockViewModel()
        sampleViewModel.history = [
            .init(medicineId: "12", user: "user@test.com", action: "Add new medicine", details: "user@test.com adds Sample with initial stock of 10", currentStock: 10),
            .init(medicineId: "12", user: "user@test.com", action: "Increasing stock of 2", details: "Stock change from 10 to 12", currentStock: 12),
            .init(medicineId: "12", user: "user@test.com", action: "Increasing stock of 3", details: "Stock change from 12 to 15", currentStock: 15),
            .init(medicineId: "12", user: "user@test.com", action: "Increasing stock of 6", details: "Stock change from 15 to 21", currentStock: 21),
            .init(medicineId: "12", user: "user@test.com", action: "Decreasing stock of 2", details: "Stock change from 21 to 19", currentStock: 19),
            .init(medicineId: "12", user: "user@test.com", action: "Increasing stock of 19", details: "Stock change from 19 to 38", currentStock: 38),
            .init(medicineId: "12", user: "user@test.com", action: "Decreasing stock of 10", details: "Stock change from 38 to 28", currentStock: 28),
            .init(medicineId: "12", user: "user@test.com", action: "Increasing stock of 3", details: "Stock change from 28 to 25", currentStock: 25),
        ]
         return MedicineDetailView(medicine: sampleMedicine, viewModel: sampleViewModel).environmentObject(SessionStore())
    }
}
