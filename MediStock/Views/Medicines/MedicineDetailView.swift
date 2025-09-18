import SwiftUI
import Charts

enum Interval: String, CaseIterable {
    case day = "Day"
    case week = "Week"
    case month = "Month"
}

struct MedicineDetailView: View {
    @State var medicine: Medicine
    @ObservedObject var medicinesVM: MedicineStockViewModel
    
    @EnvironmentObject var session: SessionStore
    @EnvironmentObject var coordinator: AppCoordinator
    
    @State var isShowingHistory: Bool = false
    @State var isShowingEditView: Bool = false
    @State private var selectedInterval: Interval = .week
    @State private var debounceTask: Task<Void, Never>?
    
    private var stockStatus: String {
        switch medicine.stock {
        case 0:
            return "Out of Stock"
        case ...medicine.alertStock:
            return "Low Stock"
        case ...medicine.warningStock:
            return "Stock OK"
        default:
            return "In Stock"
        }
    }
    
    private var stockColor: Color {
        switch medicine.stock {
        case 0:
            return .red
        case ...medicine.alertStock:
            return .orange
        case ...medicine.warningStock:
            return .yellow
        default:
            return .green
        }
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading) {
                HStack {
                    Image(systemName: medicine.icon)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 48, height: 48)
                        .foregroundStyle(medicine.color.toColor())
                        .padding(10)
                        .background {
                            Circle()
                                .fill(medicine.color.toColor().opacity(0.2))
                        }
                    Text(medicine.name)
                        .font(.largeTitle)
                    Spacer()
                }
                HStack(spacing: 25) {
                    StockCircleIndicatorView(stock: medicine.stock, normalStock: medicine.normalStock, waringStock: medicine.warningStock, alertStock: medicine.alertStock)
                    VStack(alignment: .leading) {
                        Text(stockStatus)
                            .foregroundStyle(Color.background)
                            .padding(.vertical, 5)
                            .padding(.horizontal, 10)
                            .background(stockColor)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                        
                        Stepper("Stock: \(medicine.stock)", value: $medicine.stock, in: 0...Int.max)
                            .labelsHidden()
                            .onChange(of: medicine.stock) {
                                debounceTask?.cancel()
                                
                                debounceTask = Task {
                                    try? await Task.sleep(for: .milliseconds(500))
                                    guard !Task.isCancelled else { return }
                                    
                                    await medicinesVM.updateStock(for: medicine, to: medicine.stock, by: session.session?.email ?? "")
                                }
                            }
                    }
                }
                .padding()
                
                VStack(alignment: .leading) {
                    HStack {
                        Text("Stock")
                            .font(.title.bold())
                        Spacer()
                        Picker("Select interval", selection: $selectedInterval) {
                            ForEach(Interval.allCases, id: \.self) { item in
                                Text(item.rawValue)
                            }
                        }
                        .pickerStyle(.segmented)
                    }
                    historySection
                        .padding(.bottom)
                    HStack {
                        Text("History")
                            .font(.title.bold())
                        Spacer()
                        Image(systemName: "chevron.right")
                            .rotationEffect(.degrees(isShowingHistory ? 90 : 0))
                    }
                        .onTapGesture {
                            withAnimation {
                                isShowingHistory.toggle()
                            }
                        }
                    if isShowingHistory {
                        ForEach(medicinesVM.history.sorted(by: { $0.timestamp > $1.timestamp })) { item in
                            HStack {
                                if item.action.contains("Add") {
                                    Image(systemName: "plus.circle.fill")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 50, height: 50)
                                        .foregroundStyle(.gray)
                                } else if item.action.contains("Increase") {
                                    Image(systemName: "arrow.up.right.circle.fill")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 50, height: 50)
                                        .foregroundStyle(.green)
                                } else if item.action.contains("Decrease") {
                                    Image(systemName: "arrow.down.left.circle.fill")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 50, height: 50)
                                        .foregroundStyle(.red)
                                } else {
                                    Image(systemName: "minus.circle.fill")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 50, height: 50)
                                        .foregroundStyle(.red)
                                }
                                VStack(alignment: .leading) {
                                    Text(item.user)
                                    Text(item.action)
                                    Text(item.timestamp.formatted())
                                }
                            }
                            .padding(.vertical, 5)
                        }
                    }
                }
                .padding()
                .background(Color.customPrimary)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                
                Button {
                    Task {
                        await medicinesVM.delete(medicine)
                        coordinator.dismiss()
                    }
                } label: {
                    HStack {
                        Image(systemName: "trash")
                        Text("Delete")
                    }
                    .foregroundStyle(.red)
                    .font(.title2)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.red.opacity(0.2))
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                }

            }
        }
        .padding()
        .background {
            Color.background
                .ignoresSafeArea()
        }
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
        
        let currentStockHistory: HistoryEntry = .init(medicineId: medicine.id, user: session.session?.email ?? "", action: "", details: "", currentStock: medicine.stock)
        
        let currentHistory: [HistoryEntry] = medicinesVM.history + [currentStockHistory]
        
        var interval: ClosedRange<Date> {
            switch selectedInterval {
            case .day:
                return Date().addingTimeInterval(-86400)...Date()
            case .week:
                return Date().addingTimeInterval(-604800)...Date()
            case .month:
                return Date().addingTimeInterval(-2592000)...Date()
            }
        }

        return VStack(alignment: .leading) {
            
            Chart {
                ForEach(currentHistory.sorted(by: { $0.timestamp < $1.timestamp}), id: \.id) { item in
                    LineMark(
                        x: .value("Date", item.timestamp, unit: .minute),
                        y: .value("Stock", item.currentStock)
                    )
                    .foregroundStyle(.blue)
                    .interpolationMethod(.monotone)
                    
                    AreaMark(
                        x: .value("Date", item.timestamp, unit: .minute),
                        y: .value("Stock", item.currentStock)
                    )
                    .interpolationMethod(.monotone)
                    .foregroundStyle(linearGradient)
                }
            }
            .chartXScale(domain: interval)
            .frame(height: 200)
        }
    }
}

struct MedicineDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleMedicine = Medicine(
            id: "12",
            name: "Tramadol",
            stock: 10,
            aisle: "Aisle 1",
            normalStock: 25,
            warningStock: 10,
            alertStock: 5,
            icon: "pills",
            color: "64DEF5"
        )
        let sampleViewModel = MedicineStockViewModel()
        sampleViewModel.history = [
            .init(medicineId: "12", user: "user@test.com", action: "Add new medicine", details: "user@test.com adds Tramadol with initial stock of 10", timestamp: Date(timeIntervalSinceNow: -86400 * 12), currentStock: 10),
            .init(medicineId: "12", user: "user@test.com", action: "Increased stock of Tramadol by 5", details: "changed stock from 10 to 15", timestamp: Date(timeIntervalSinceNow: -86400 * 11), currentStock: 15),
            .init(medicineId: "12", user: "user@test.com", action: "Decreased stock of Tramadol by 3", details: "changed stock from 15 to 12", timestamp: Date(timeIntervalSinceNow: -86400 * 10), currentStock: 12),
            .init(medicineId: "12", user: "user@test.com", action: "Increased stock of Tramadol by 8", details: "changed stock from 12 to 20", timestamp: Date(timeIntervalSinceNow: -86400 * 9), currentStock: 20),
            .init(medicineId: "12", user: "user@test.com", action: "Decreased stock of Tramadol by 2", details: "changed stock from 20 to 18", timestamp: Date(timeIntervalSinceNow: -86400 * 8), currentStock: 18),
            .init(medicineId: "12", user: "user@test.com", action: "Increased stock of Tramadol by 10", details: "changed stock from 18 to 28", timestamp: Date(timeIntervalSinceNow: -86400 * 7), currentStock: 28),
            .init(medicineId: "12", user: "user@test.com", action: "Decreased stock of Tramadol by 6", details: "changed stock from 28 to 22", timestamp: Date(timeIntervalSinceNow: -86400 * 6), currentStock: 22),
            .init(medicineId: "12", user: "user@test.com", action: "Increased stock of Tramadol by 3", details: "changed stock from 22 to 25", timestamp: Date(timeIntervalSinceNow: -86400 * 5), currentStock: 25),
            .init(medicineId: "12", user: "user@test.com", action: "Decreased stock of Tramadol by 4", details: "changed stock from 25 to 21", timestamp: Date(timeIntervalSinceNow: -86400 * 4), currentStock: 21),
            .init(medicineId: "12", user: "user@test.com", action: "Increased stock of Tramadol by 7", details: "changed stock from 21 to 28", timestamp: Date(timeIntervalSinceNow: -86400 * 3), currentStock: 28),
            .init(medicineId: "12", user: "user@test.com", action: "Decreased stock of Tramadol by 5", details: "changed stock from 28 to 23", timestamp: Date(timeIntervalSinceNow: -86400 * 2), currentStock: 23),
            .init(medicineId: "12", user: "user@test.com", action: "Increased stock of Tramadol by 12", details: "changed stock from 23 to 35", timestamp: Date(timeIntervalSinceNow: -86400), currentStock: 35),
            .init(medicineId: "12", user: "user@test.com", action: "Decreased stock of Tramadol by 25", details: "changed stock from 23 to 35", timestamp: Date(timeIntervalSinceNow: -32400), currentStock: 10),
        ]


        return NavigationStack {
            MedicineDetailView(medicine: sampleMedicine, medicinesVM: sampleViewModel)
                .environmentObject(SessionStore())
                .environmentObject(AppCoordinator())
        }
    }
}
