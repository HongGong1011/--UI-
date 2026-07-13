import SwiftUI
import Combine
import PhotosUI

// MARK: - 植物模型
struct Plant: Identifiable, Codable, Hashable {
    var id = UUID()
    var name: String
    var emoji: String
    var sciName: String
    var family: String
    var alias: String
    var origin: String
    var waterInterval: String
    var light: String
    var leafType: String
    var adoptedDate: Date
    var status: String = "健康"
    var growthValue: Double = 0.5
    var desc: String = ""
    var photoData: Data?
}

// MARK: - 养护事件
struct CareEvent: Identifiable, Codable {
    var id = UUID()
    var type: EventType
    var plantName: String
    var note: String
    var date: Date
    var photoData: [Data] = []
}

enum EventType: String, Codable, CaseIterable {
    case water = "浇水"
    case fertilize = "施肥"
    case pesticide = "杀虫"
    case repot = "换盆"
    case divide = "分苗"
    case merge = "合盆"
    case enclosed = "闷养"
    case outdoor = "露养"
    case mount = "上板"
    case newPlant = "新买"
    case death = "死亡"

    var emoji: String {
        switch self {
        case .water: return "💧"
        case .fertilize: return "🧪"
        case .pesticide: return "💊"
        case .repot: return "🪴"
        case .divide: return "✂️"
        case .merge: return "🤝"
        case .enclosed: return "🏠"
        case .outdoor: return "🌤️"
        case .mount: return "🪵"
        case .newPlant: return "🛒"
        case .death: return "🕯️"
        }
    }

    var color: String {
        switch self {
        case .water: return "blue"
        case .fertilize: return "green"
        case .pesticide: return "orange"
        case .repot: return "brown"
        case .divide: return "purple"
        case .merge: return "pink"
        case .enclosed: return "teal"
        case .outdoor: return "yellow"
        case .mount: return "mint"
        case .newPlant: return "indigo"
        case .death: return "gray"
        }
    }
}

// MARK: - 纪念碑
struct Memorial: Identifiable, Codable {
    var id = UUID()
    var emoji: String
    var name: String
    var adoptedDate: String
    var partedDate: String
    var cause: String
    var causeType: String
}

// MARK: - 购买记录（小票）
struct ReceiptItem: Identifiable, Codable {
    var id = UUID()
    var emoji: String
    var name: String
    var quantity: Int
    var price: Double
}

struct ReceiptPeriod: Identifiable, Codable {
    var id: String
    var title: String
    var subtitle: String
    var items: [ReceiptItem]
}

// MARK: - 花架
struct ShelfSlot: Codable {
    var plantIndex: Int?
    var potIndex: Int?
}

struct ShelfLayout: Codable {
    var name: String
    var emoji: String
    var slots: [[ShelfSlot]]
}

// MARK: - 品种图鉴
struct PlantSpecies: Identifiable {
    var id = UUID()
    var emoji: String
    var name: String
    var sciName: String
    var family: String
    var origin: String
    var waterInterval: String
    var light: String
    var leafType: String
    var desc: String
}

// MARK: - 成长照片
struct GrowthPhoto: Identifiable, Codable {
    var id = UUID()
    var date: String
    var note: String
    var photoData: Data?
}

// MARK: - 病虫害
struct PestEntry: Identifiable {
    var id = UUID()
    var icon: String
    var name: String
    var type: PestType
    var severity: String
    var plants: String
    var symptoms: String
    var treatment: String
    var prevention: String
}

enum PestType: String, CaseIterable {
    case disease = "病害"
    case pest = "虫害"
}

// MARK: - 肥料药品
struct Supply: Identifiable, Codable {
    var id = UUID()
    var name: String
    var type: SupplyType
    var date: String
    var note: String
}

enum SupplyType: String, Codable, CaseIterable {
    case fertilizer = "肥料"
    case pesticide = "药品"
    case tool = "工具"

    var icon: String {
        switch self {
        case .fertilizer: return "🧪"
        case .pesticide: return "💊"
        case .tool: return "🔧"
        }
    }
}

// MARK: - 心愿清单
struct WishItem: Identifiable, Codable {
    var id = UUID()
    var name: String
    var photoData: Data?
    var owned: Bool = false
}

// MARK: - PlantStore
class PlantStore: ObservableObject {
    @Published var plants: [Plant] = []
    @Published var events: [CareEvent] = []
    @Published var memorials: [Memorial] = []
    @Published var supplies: [Supply] = []
    @Published var wishes: [WishItem] = []

    init() {
        loadSampleData()
    }

    func loadSampleData() {
        plants = [
            Plant(name: "龟背竹", emoji: "🌿", sciName: "Monstera deliciosa", family: "天南星科",
                  alias: "蓬莱蕉", origin: "中美洲", waterInterval: "5-7天", light: "明亮散射光",
                  leafType: "心形·深裂", adoptedDate: Calendar.current.date(byAdding: .day, value: -128, to: Date())!,
                  status: "健康", growthValue: 0.85,
                  desc: "叶片宽大呈心形，成熟后深裂成羽毛状，是热带雨林经典观叶植物。"),
            Plant(name: "花烛红掌", emoji: "🌺", sciName: "Anthurium andraeanum", family: "天南星科",
                  alias: "红掌", origin: "哥伦比亚", waterInterval: "5-7天", light: "明亮散射光",
                  leafType: "心形·蜡质", adoptedDate: Calendar.current.date(byAdding: .day, value: -95, to: Date())!,
                  status: "健康", growthValue: 0.72,
                  desc: "佛焰苞鲜红亮丽，形似爱心，花期长达2-3个月。"),
            Plant(name: "琴叶榕", emoji: "🪴", sciName: "Ficus lyrata", family: "桑科",
                  alias: "小提琴榕", origin: "西非", waterInterval: "7-10天", light: "明亮散射光",
                  leafType: "提琴形·革质", adoptedDate: Calendar.current.date(byAdding: .day, value: -60, to: Date())!,
                  status: "健康", growthValue: 0.6,
                  desc: "叶片形似小提琴，革质厚实有光泽，北欧风标志性植物。"),
            Plant(name: "蝴蝶兰", emoji: "🦋", sciName: "Phalaenopsis aphrodite", family: "兰科",
                  alias: "蝶兰", origin: "东南亚", waterInterval: "7-10天", light: "明亮散射光",
                  leafType: "椭圆形·肉质", adoptedDate: Calendar.current.date(byAdding: .day, value: -45, to: Date())!,
                  status: "开花中", growthValue: 0.9,
                  desc: "花姿优雅如蝴蝶翩翩，花期长达3-6个月。"),
            Plant(name: "彩叶芋", emoji: "🍂", sciName: "Caladium bicolor", family: "天南星科",
                  alias: "花叶芋", origin: "南美", waterInterval: "5-7天", light: "明亮散射光",
                  leafType: "心形·霓虹色斑", adoptedDate: Calendar.current.date(byAdding: .day, value: -30, to: Date())!,
                  status: "健康", growthValue: 0.55,
                  desc: "叶片色彩斑斓，红粉绿白交织如调色盘。"),
            Plant(name: "鹿角蕨", emoji: "🦌", sciName: "Platycerium bifurcatum", family: "鹿角蕨科",
                  alias: "蝙蝠蕨", origin: "澳大利亚", waterInterval: "5-7天", light: "明亮散射光",
                  leafType: "二型叶·鹿角形", adoptedDate: Calendar.current.date(byAdding: .day, value: -25, to: Date())!,
                  status: "健康", growthValue: 0.5,
                  desc: "孢子叶形似鹿角垂挂，热带雨林中的空中艺术品。"),
            Plant(name: "空气凤梨", emoji: "🌬️", sciName: "Tillandsia ionantha", family: "凤梨科",
                  alias: "空凤", origin: "中南美洲", waterInterval: "2-3天", light: "明亮散射光",
                  leafType: "银灰色·鳞片状", adoptedDate: Calendar.current.date(byAdding: .day, value: -20, to: Date())!,
                  status: "健康", growthValue: 0.4,
                  desc: "无需土壤，靠叶片鳞片吸收空气中水分和养分。"),
            Plant(name: "秋海棠", emoji: "🌸", sciName: "Begonia rex", family: "秋海棠科",
                  alias: "彩叶海棠", origin: "亚洲热带", waterInterval: "5-7天", light: "明亮散射光",
                  leafType: "不对称·金属光泽", adoptedDate: Calendar.current.date(byAdding: .day, value: -15, to: Date())!,
                  status: "健康", growthValue: 0.35,
                  desc: "叶片色彩斑斓，银灰、紫红、翠绿交织，带金属质感。"),
        ]

        events = [
            CareEvent(type: .water, plantName: "龟背竹", note: "浇透水，盆底流出", date: Date()),
            CareEvent(type: .fertilize, plantName: "花烛红掌", note: "施缓释肥", date: Calendar.current.date(byAdding: .day, value: -3, to: Date())!),
            CareEvent(type: .repot, plantName: "琴叶榕", note: "换大一号盆", date: Calendar.current.date(byAdding: .day, value: -5, to: Date())!),
            CareEvent(type: .newPlant, plantName: "秋海棠", note: "新入盆·状态记录", date: Calendar.current.date(byAdding: .day, value: -15, to: Date())!),
        ]

        memorials = [
            Memorial(emoji: "🪴", name: "彩叶草", adoptedDate: "2025年3月", partedDate: "2026年5月", cause: "浇水过多导致根腐", causeType: "养护失误"),
            Memorial(emoji: "🌿", name: "绿萝", adoptedDate: "2024年8月", partedDate: "2026年1月", cause: "冬季冻伤", causeType: "环境因素"),
        ]

        supplies = [
            Supply(name: "热带植物缓释肥", type: .fertilizer, date: "6月1日", note: "200g·每2月撒一次"),
            Supply(name: "百菌清", type: .pesticide, date: "6月5日", note: "100ml·稀释800倍"),
            Supply(name: "HB-101活力素", type: .fertilizer, date: "6月10日", note: "50ml·稀释1000倍"),
            Supply(name: "阿维菌素", type: .pesticide, date: "6月15日", note: "200ml·稀释1500倍"),
            Supply(name: "吡虫啉", type: .pesticide, date: "6月20日", note: "100ml·稀释2000倍"),
            Supply(name: "尖嘴浇水壶", type: .tool, date: "6月1日", note: "500ml·精准控水"),
        ]

        wishes = [
            WishItem(name: "白锦龟背竹"),
            WishItem(name: "洒金蔓绿绒"),
            WishItem(name: "帝王花烛"),
            WishItem(name: "斑叶橙柄蔓绿绒"),
            WishItem(name: "荧光蔓绿绒"),
        ]
    }

    // MARK: - 植物操作
    func addPlant(_ plant: Plant) { plants.append(plant) }
    func deletePlant(_ plant: Plant) { plants.removeAll { $0.id == plant.id } }

    // MARK: - 事件操作
    func addEvent(_ event: CareEvent) { events.insert(event, at: 0) }
    func eventsForDate(_ date: Date) -> [CareEvent] {
        events.filter { Calendar.current.isDate($0.date, inSameDayAs: date) }
    }
    func eventsForMonth(_ date: Date) -> [CareEvent] {
        let cal = Calendar.current
        guard let monthStart = cal.date(from: cal.dateComponents([.year, .month], from: date)),
              let monthEnd = cal.date(byAdding: DateComponents(month: 1, day: -1), to: monthStart) else {
            return []
        }
        return events.filter { $0.date >= monthStart && $0.date <= monthEnd }
    }
    func daysWithEventsInMonth(_ date: Date) -> Set<Int> {
        Set(eventsForMonth(date).map { Calendar.current.component(.day, from: $0.date) })
    }
    func eventsForDay(_ day: Int, inMonth date: Date) -> [CareEvent] {
        let cal = Calendar.current
        return eventsForMonth(date).filter { cal.component(.day, from: $0.date) == day }
    }

    // MARK: - 纪念碑
    func addMemorial(_ memorial: Memorial) { memorials.append(memorial) }

    // MARK: - 供应品
    func addSupply(_ supply: Supply) { supplies.append(supply) }
    func deleteSupply(_ supply: Supply) { supplies.removeAll { $0.id == supply.id } }

    // MARK: - 心愿
    func addWish(_ wish: WishItem) { wishes.append(wish) }
    func toggleWishOwned(_ wish: WishItem) {
        if let idx = wishes.firstIndex(where: { $0.id == wish.id }) {
            wishes[idx].owned.toggle()
        }
    }
    func deleteWish(_ wish: WishItem) { wishes.removeAll { $0.id == wish.id } }
}

// MARK: - ContentView
struct ContentView: View {
    @EnvironmentObject var store: PlantStore
    @State private var selectedTab = 0
    @State private var showAddRecord = false

    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationStack { HomeView() }
                .tabItem { Label("花园", systemImage: "leaf.fill") }
                .tag(0)

            NavigationStack { CalendarView() }
                .tabItem { Label("月历", systemImage: "calendar") }
                .tag(1)

            Color.clear
                .tabItem { Label("", systemImage: "") }
                .tag(2)

            NavigationStack { ReminderView() }
                .tabItem { Label("提醒", systemImage: "bell.fill") }
                .tag(3)

            NavigationStack { ProfileView() }
                .tabItem { Label("我的", systemImage: "person.fill") }
                .tag(4)
        }
        .overlay(alignment: .bottom) {
            Button {
                showAddRecord = true
            } label: {
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 48))
                    .foregroundStyle(.white, Color.green)
                    .shadow(radius: 4)
            }
            .offset(y: -8)
        }
        .sheet(isPresented: $showAddRecord) {
            AddRecordView()
        }
    }
}

// MARK: - HomeView
struct HomeView: View {
    @EnvironmentObject var store: PlantStore
    @State private var weatherIndex = 0

    let weathers: [(icon: String, temp: String, desc: String)] = [
        ("☀️", "32°", "晴 · 注意遮阴"),
        ("🌧️", "26°", "雨 · 不用浇水"),
        ("⛅", "28°", "多云 · 适合通风"),
    ]

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                weatherCard
                if let plant = store.plants.randomElement() {
                    featuredPlant(plant)
                }
                pendingAlerts
                Text("我的植物收藏")
                    .font(.title3).bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)

                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                    ForEach(store.plants) { plant in
                        NavigationLink(destination: PlantDetailView(plant: plant)) {
                            plantCard(plant)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal)
            }
            .padding(.vertical)
        }
        .navigationTitle("植物花园")
        .onAppear { weatherIndex = Int.random(in: 0..<weathers.count) }
    }

    var weatherCard: some View {
        let w = weathers[weatherIndex]
        return HStack {
            Text(w.icon).font(.system(size: 40))
            VStack(alignment: .leading) {
                Text(w.temp).font(.title2).bold()
                Text(w.desc).font(.caption).foregroundStyle(.secondary)
            }
            Spacer()
            Text("7月11日 · 周四").font(.caption).foregroundStyle(.secondary)
        }
        .padding()
        .background(Color.green.opacity(0.08), in: RoundedRectangle(cornerRadius: 16))
        .padding(.horizontal)
    }

    func featuredPlant(_ plant: Plant) -> some View {
        NavigationLink(destination: PlantDetailView(plant: plant)) {
            HStack(spacing: 12) {
                Text(plant.emoji).font(.system(size: 50))
                VStack(alignment: .leading, spacing: 4) {
                    Text("今日C位").font(.caption).foregroundStyle(.orange)
                    Text(plant.name).font(.title3).bold()
                    Text(plant.family).font(.caption).foregroundStyle(.secondary)
                }
                Spacer()
                Image(systemName: "chevron.right").foregroundStyle(.secondary)
            }
            .padding()
            .background(Color.orange.opacity(0.06), in: RoundedRectangle(cornerRadius: 16))
        }
        .buttonStyle(.plain)
        .padding(.horizontal)
    }

    var pendingAlerts: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("待办提醒").font(.title3).bold().padding(.horizontal)
            ForEach(store.events.prefix(3)) { event in
                HStack {
                    Text(event.type.emoji)
                    Text("\(event.plantName) · \(event.type.rawValue)")
                        .font(.subheadline)
                    Spacer()
                    Text(event.date, style: .relative)
                        .font(.caption).foregroundStyle(.secondary)
                }
                .padding(.horizontal)
                .padding(.vertical, 6)
                .background(Color.blue.opacity(0.05), in: RoundedRectangle(cornerRadius: 10))
                .padding(.horizontal)
            }
        }
    }

    func plantCard(_ plant: Plant) -> some View {
        VStack(spacing: 8) {
            Text(plant.emoji).font(.system(size: 44))
            Text(plant.name).font(.subheadline).bold()
            Text(plant.family).font(.caption2).foregroundStyle(.secondary)
            HStack {
                Text(plant.status).font(.caption2).padding(.horizontal, 8).padding(.vertical, 2)
                    .background(Color.green.opacity(0.15), in: Capsule())
                Spacer()
                Text(plant.waterInterval).font(.caption2).foregroundStyle(.secondary)
            }
            ProgressView(value: plant.growthValue)
                .tint(Color.green)
        }
        .padding()
        .background(Color(.systemBackground), in: RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.06), radius: 4, y: 2)
    }
}

// MARK: - PlantDetailView
struct PlantDetailView: View {
    let plant: Plant
    @EnvironmentObject var store: PlantStore

    var plantEvents: [CareEvent] {
        store.events.filter { $0.plantName == plant.name }
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                idCard
                statsRow
                Text("成长时间轴").font(.title3).bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)

                if plantEvents.isEmpty {
                    Text("暂无记录").foregroundStyle(.secondary).padding()
                } else {
                    ForEach(plantEvents) { event in
                        timelineRow(event)
                    }
                }
            }
            .padding(.vertical)
        }
        .navigationTitle(plant.name)
        .navigationBarTitleDisplayMode(.inline)
    }

    var idCard: some View {
        VStack(spacing: 12) {
            Text(plant.emoji).font(.system(size: 60))
            Text(plant.name).font(.title).bold()
            Text(plant.sciName).font(.caption).foregroundStyle(.secondary).italic()
            Divider()
            HStack {
                infoItem("科属", plant.family)
                infoItem("别名", plant.alias)
                infoItem("原产地", plant.origin)
            }
            HStack {
                infoItem("浇水", plant.waterInterval)
                infoItem("光照", plant.light)
                infoItem("叶片", plant.leafType)
            }
            Divider()
            Text(plant.desc).font(.subheadline).foregroundStyle(.secondary).multilineTextAlignment(.center)
        }
        .padding()
        .background(Color(.systemBackground), in: RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.06), radius: 4, y: 2)
        .padding(.horizontal)
    }

    func infoItem(_ label: String, _ value: String) -> some View {
        VStack(spacing: 2) {
            Text(value).font(.caption).bold()
            Text(label).font(.caption2).foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
    }

    var statsRow: some View {
        HStack(spacing: 0) {
            statBlock("128", "天")
            statBlock("12", "次浇水")
            statBlock("3", "次施肥")
            statBlock("1", "次换盆")
        }
        .padding()
        .background(Color.green.opacity(0.06), in: RoundedRectangle(cornerRadius: 12))
        .padding(.horizontal)
    }

    func statBlock(_ value: String, _ label: String) -> some View {
        VStack(spacing: 2) {
            Text(value).font(.title3).bold().foregroundStyle(Color.green)
            Text(label).font(.caption2).foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
    }

    func timelineRow(_ event: CareEvent) -> some View {
        HStack(alignment: .top, spacing: 12) {
            VStack(spacing: 0) {
                Circle().fill(Color.green).frame(width: 10, height: 10)
                Rectangle().fill(Color.green.opacity(0.2)).frame(width: 2)
            }
            VStack(alignment: .leading, spacing: 4) {
                Text("\(event.type.emoji) \(event.type.rawValue)").font(.subheadline).bold()
                Text(event.note).font(.caption).foregroundStyle(.secondary)
                Text(event.date, style: .date).font(.caption2).foregroundStyle(.secondary)
            }
            Spacer()
        }
        .padding(.horizontal)
    }
}

// MARK: - AddRecordView
struct AddRecordView: View {
    @EnvironmentObject var store: PlantStore
    @Environment(\.dismiss) var dismiss

    @State private var selectedPlant = ""
    @State private var selectedType: EventType = .water
    @State private var note = ""
    @State private var selectedPhotos: [PhotosPickerItem] = []
    @State private var photoDatas: [Data] = []

    var body: some View {
        NavigationStack {
            Form {
                Section("选择植物") {
                    Picker("植物", selection: $selectedPlant) {
                        Text("请选择").tag("")
                        ForEach(store.plants) { plant in
                            Text("\(plant.emoji) \(plant.name)").tag(plant.name)
                        }
                    }
                }

                Section("事件类型") {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 60))], spacing: 8) {
                        ForEach(EventType.allCases, id: \.self) { type in
                            Button {
                                selectedType = type
                            } label: {
                                VStack(spacing: 4) {
                                    Text(type.emoji).font(.title2)
                                    Text(type.rawValue).font(.caption2)
                                }
                                .padding(8)
                                .background(selectedType == type ? Color.green.opacity(0.15) : Color(.systemGray6), in: RoundedRectangle(cornerRadius: 10))
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }

                Section("养护笔记") {
                    TextField("记录养护细节...", text: $note, axis: .vertical)
                        .lineLimit(3...6)
                }

                Section("添加照片") {
                    PhotosPicker(selection: $selectedPhotos, maxSelectionCount: 3, matching: .images) {
                        Label("选择照片", systemImage: "photo.on.rectangle.angled")
                    }
                    if !photoDatas.isEmpty {
                        ScrollView(.horizontal) {
                            HStack {
                                ForEach(photoDatas.indices, id: \.self) { i in
                                    if let uiImage = UIImage(data: photoDatas[i]) {
                                        Image(uiImage: uiImage)
                                            .resizable().scaledToFill()
                                            .frame(width: 80, height: 80)
                                            .clipShape(RoundedRectangle(cornerRadius: 8))
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("记录成长")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("取消") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("保存") {
                        saveRecord()
                        dismiss()
                    }
                    .disabled(selectedPlant.isEmpty)
                }
            }
            .onChange(of: selectedPhotos) { _, newItems in
                Task {
                    photoDatas = []
                    for item in newItems {
                        if let data = try? await item.loadTransferable(type: Data.self) {
                            photoDatas.append(data)
                        }
                    }
                }
            }
        }
    }

    func saveRecord() {
        let event = CareEvent(
            type: selectedType,
            plantName: selectedPlant,
            note: note,
            date: Date(),
            photoData: photoDatas
        )
        store.addEvent(event)
    }
}

// MARK: - CalendarView
struct CalendarView: View {
    @EnvironmentObject var store: PlantStore
    @State private var currentDate = Date()
    @State private var selectedDay: Int?

    private var calendar: Calendar { Calendar.current }
    private var daysInMonth: Int {
        calendar.range(of: .day, in: .month, for: currentDate)!.count
    }
    private var firstWeekday: Int {
        let comp = calendar.dateComponents([.year, .month], from: currentDate)
        let first = calendar.date(from: comp)!
        return calendar.component(.weekday, from: first)
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                HStack {
                    Button { changeMonth(-1) } label: { Image(systemName: "chevron.left") }
                    Text(currentDate, format: .dateTime.year().month(.wide))
                        .font(.title2).bold().frame(maxWidth: .infinity)
                    Button { changeMonth(1) } label: { Image(systemName: "chevron.right") }
                }
                .padding(.horizontal)

                if let day = selectedDay {
                    dayEventsCard(day)
                }

                calendarGrid
                    .padding(.horizontal)
            }
            .padding(.vertical)
        }
        .navigationTitle("养护月历")
    }

    func changeMonth(_ by: Int) {
        if let newDate = calendar.date(byAdding: .month, value: by, to: currentDate) {
            currentDate = newDate
            selectedDay = nil
        }
    }

    var calendarGrid: some View {
        let eventDays = store.daysWithEventsInMonth(currentDate)
        let todayComp = calendar.dateComponents([.year, .month, .day], from: Date())
        let curComp = calendar.dateComponents([.year, .month], from: currentDate)
        let isCurrentMonth = todayComp.year == curComp.year && todayComp.month == curComp.month

        return LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7)) {
            ForEach(["日","一","二","三","四","五","六"], id: \.self) { d in
                Text(d).font(.caption).bold().foregroundStyle(.secondary)
            }
            ForEach(0..<(firstWeekday - 1), id: \.self) { _ in Color.clear.frame(height: 40) }
            ForEach(1...daysInMonth, id: \.self) { day in
                let isToday = isCurrentMonth && todayComp.day == day
                let hasEvent = eventDays.contains(day)
                Button {
                    selectedDay = (selectedDay == day) ? nil : day
                } label: {
                    VStack(spacing: 2) {
                        Text("\(day)").font(.callout)
                            .foregroundStyle(isToday ? .white : .primary)
                        if hasEvent {
                            Circle().fill(Color.green).frame(width: 4, height: 4)
                        }
                    }
                    .frame(height: 40)
                    .frame(maxWidth: .infinity)
                    .background(isToday ? Color.green : (selectedDay == day ? Color.green.opacity(0.1) : .clear), in: RoundedRectangle(cornerRadius: 8))
                }
                .buttonStyle(.plain)
            }
        }
    }

    func dayEventsCard(_ day: Int) -> some View {
        let events = store.eventsForDay(day, inMonth: currentDate)
        return VStack(alignment: .leading, spacing: 8) {
            Text("\(calendar.component(.month, from: currentDate))月\(day)日").font(.headline)
            if events.isEmpty {
                Text("当天无记录").font(.caption).foregroundStyle(.secondary)
            } else {
                ForEach(events) { event in
                    HStack {
                        Text(event.type.emoji)
                        Text("\(event.plantName) · \(event.type.rawValue)")
                        Spacer()
                        Text(event.note).font(.caption).foregroundStyle(.secondary)
                    }
                    .padding(8)
                    .background(Color(.systemGray6), in: RoundedRectangle(cornerRadius: 8))
                }
            }
        }
        .padding()
        .background(Color(.systemBackground), in: RoundedRectangle(cornerRadius: 12))
        .shadow(color: .black.opacity(0.04), radius: 4, y: 2)
        .padding(.horizontal)
    }
}

// MARK: - ReminderView
struct ReminderView: View {
    @EnvironmentObject var store: PlantStore

    var body: some View {
        List {
            ForEach(store.plants) { plant in
                Section(plant.name) {
                    reminderRow(plant: plant, type: .water, icon: "💧", freq: "每\(plant.waterInterval)浇一次")
                    reminderRow(plant: plant, type: .fertilize, icon: "🧪", freq: "每30天施一次肥")
                    reminderRow(plant: plant, type: .pesticide, icon: "💊", freq: "每60天检查虫害")
                }
            }
        }
        .navigationTitle("养护提醒")
    }

    func reminderRow(plant: Plant, type: EventType, icon: String, freq: String) -> some View {
        HStack {
            Text(icon).font(.title3)
            VStack(alignment: .leading) {
                Text("\(type.rawValue) \(plant.name)").font(.subheadline)
                Text(freq).font(.caption).foregroundStyle(.secondary)
            }
            Spacer()
            Button("完成") {}.buttonStyle(.bordered).controlSize(.small)
        }
    }
}

// MARK: - ProfileView
struct ProfileView: View {
    @EnvironmentObject var store: PlantStore

    var body: some View {
        List {
            Section("工具") {
                NavigationLink(destination: MemorialView()) {
                    Label("植物纪念碑", systemImage: "sparkles")
                }
                NavigationLink(destination: ReceiptView()) {
                    Label("本月账单", systemImage: "receipt")
                }
                NavigationLink(destination: ShelfView()) {
                    Label("花架摆放", systemImage: "square.grid.3x3")
                }
                NavigationLink(destination: HerbariumView()) {
                    Label("植物标本馆", systemImage: "camera.macro")
                }
            }
            Section("知识库") {
                NavigationLink(destination: SpeciesGuideView()) {
                    Label("品种图鉴", systemImage: "book.pages")
                }
                NavigationLink(destination: GrowthPolaroidView()) {
                    Label("成长拍立得", systemImage: "camera.fill")
                }
                NavigationLink(destination: PestGuideView()) {
                    Label("病虫害图鉴", systemImage: "stethoscope")
                }
            }
            Section("管理") {
                NavigationLink(destination: SupplyManagerView()) {
                    Label("肥料药品管理", systemImage: "testtube.2")
                }
                NavigationLink(destination: WishlistView()) {
                    Label("心愿清单", systemImage: "heart")
                }
            }
        }
        .navigationTitle("我的")
    }
}

// MARK: - MemorialView, ReceiptView, ShelfView
struct MemorialView: View {
    @EnvironmentObject var store: PlantStore

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                Text("累计 \(store.memorials.count) 株").font(.headline).padding(.top)

                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                    ForEach(store.memorials) { m in
                        VStack(spacing: 8) {
                            Text(m.emoji).font(.system(size: 40))
                            Text(m.name).font(.subheadline).bold()
                            Text("\(m.adoptedDate) → \(m.partedDate)")
                                .font(.caption2).foregroundStyle(.secondary)
                            Text(m.cause).font(.caption).foregroundStyle(.red)
                                .multilineTextAlignment(.center)
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color(.systemBackground), in: RoundedRectangle(cornerRadius: 12))
                        .shadow(color: .black.opacity(0.04), radius: 4, y: 2)
                    }
                }
                .padding(.horizontal)
            }
        }
        .navigationTitle("植物纪念碑")
    }
}

struct ReceiptView: View {
    @State private var period = 0
    let periods = ["当日", "月度", "年度"]

    var body: some View {
        VStack(spacing: 16) {
            Picker("周期", selection: $period) {
                ForEach(periods.indices, id: \.self) { Text(periods[$0]) }
            }
            .pickerStyle(.segmented).padding(.horizontal)

            VStack(spacing: 8) {
                Text("PLANT SHOP").font(.headline).kerning(2)
                Text("订单号: #2026-07-0001").font(.caption)
                Divider()
                row("🌿 龟背竹", "1", "¥68")
                row("🪴 琴叶榕", "1", "¥120")
                row("🧪 缓释肥", "2", "¥36")
                Divider()
                HStack { Text("合计").bold(); Spacer(); Text("¥224").bold() }
            }
            .padding()
            .background(Color(.systemBackground), in: RoundedRectangle(cornerRadius: 12))
            .shadow(color: .black.opacity(0.04), radius: 4, y: 2)
            .padding(.horizontal)
        }
        .navigationTitle("本月账单")
    }

    func row(_ name: String, _ qty: String, _ price: String) -> some View {
        HStack { Text(name).font(.caption); Spacer(); Text("x\(qty)").font(.caption); Text(price).font(.caption).frame(width: 50, alignment: .trailing) }
    }
}

struct ShelfView: View {
    @EnvironmentObject var store: PlantStore
    @State private var layoutIndex = 0
    let layouts = ["三层架", "网格架", "阶梯架"]

    var body: some View {
        VStack {
            Picker("花架", selection: $layoutIndex) {
                ForEach(layouts.indices, id: \.self) { Text(layouts[$0]) }
            }
            .pickerStyle(.segmented).padding()

            ScrollView {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                    ForEach(store.plants) { plant in
                        VStack {
                            Text(plant.emoji).font(.system(size: 36))
                            Text(plant.name).font(.caption2)
                        }
                        .frame(height: 80)
                        .frame(maxWidth: .infinity)
                        .background(Color(.systemGray6), in: RoundedRectangle(cornerRadius: 10))
                    }
                }
                .padding()
            }
        }
        .navigationTitle("花架摆放")
    }
}

// MARK: - HerbariumView, SpeciesGuideView
struct HerbariumView: View {
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var specimenImage: UIImage?
    @State private var specimens: [Specimen] = []
    @State private var showPicker = false

    struct Specimen: Identifiable {
        let id = UUID()
        let image: UIImage
        let date: Date
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                Button {
                    showPicker = true
                } label: {
                    if let image = specimenImage {
                        ZStack(alignment: .topTrailing) {
                            Image(uiImage: image).resizable().scaledToFit()
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                            Button { specimenImage = nil } label: {
                                Image(systemName: "xmark.circle.fill").foregroundStyle(.red)
                            }.padding(8)
                        }
                    } else {
                        VStack(spacing: 8) {
                            Image(systemName: "camera.viewfinder").font(.system(size: 40))
                            Text("拍照或选择照片制作标本").foregroundStyle(.secondary)
                        }
                        .frame(height: 200).frame(maxWidth: .infinity)
                        .background(Color(.systemGray6), in: RoundedRectangle(cornerRadius: 12))
                    }
                }
                .buttonStyle(.plain)
                .padding(.horizontal)

                if specimenImage != nil {
                    Button("保存标本") {
                        if let img = specimenImage {
                            specimens.append(Specimen(image: img, date: Date()))
                            specimenImage = nil
                        }
                    }
                    .buttonStyle(.borderedProminent)
                }

                if !specimens.isEmpty {
                    Text("标本收藏").font(.headline).frame(maxWidth: .infinity, alignment: .leading).padding(.horizontal)
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 8) {
                        ForEach(specimens) { spec in
                            VStack {
                                Image(uiImage: spec.image).resizable().scaledToFill()
                                    .frame(height: 120).clipped()
                                Text(spec.date, style: .date).font(.caption2)
                            }
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color(.systemGray4)))
                        }
                    }.padding(.horizontal)
                }
            }
            .padding(.vertical)
        }
        .navigationTitle("植物标本馆")
        .photosPicker(isPresented: $showPicker, selection: $selectedPhoto, matching: .images)
        .onChange(of: selectedPhoto) { _, item in
            Task {
                if let data = try? await item?.loadTransferable(type: Data.self),
                   let img = UIImage(data: data) {
                    specimenImage = img
                }
            }
        }
    }
}

struct SpeciesGuideView: View {
    @State private var selectedFamily = "全部"
    let speciesList: [PlantSpecies] = [
        PlantSpecies(emoji: "🌿", name: "龟背竹", sciName: "Monstera deliciosa", family: "天南星科", origin: "中美洲", waterInterval: "5-7天", light: "明亮散射光", leafType: "心形·深裂", desc: "叶片宽大呈心形，成熟后深裂成羽毛状，是热带雨林经典观叶植物。"),
        PlantSpecies(emoji: "🌺", name: "花烛红掌", sciName: "Anthurium andraeanum", family: "天南星科", origin: "哥伦比亚", waterInterval: "5-7天", light: "明亮散射光", leafType: "心形·蜡质", desc: "佛焰苞鲜红亮丽，形似爱心，花期长达2-3个月。"),
        PlantSpecies(emoji: "🪴", name: "琴叶榕", sciName: "Ficus lyrata", family: "桑科", origin: "西非", waterInterval: "7-10天", light: "明亮散射光", leafType: "提琴形·革质", desc: "叶片形似小提琴，革质厚实有光泽。"),
        PlantSpecies(emoji: "🦋", name: "蝴蝶兰", sciName: "Phalaenopsis aphrodite", family: "兰科", origin: "东南亚", waterInterval: "7-10天", light: "明亮散射光", leafType: "椭圆形·肉质", desc: "花姿优雅如蝴蝶翩翩，花期长达3-6个月。"),
        PlantSpecies(emoji: "🍂", name: "彩叶芋", sciName: "Caladium bicolor", family: "天南星科", origin: "南美", waterInterval: "5-7天", light: "明亮散射光", leafType: "心形·霓虹色斑", desc: "叶片色彩斑斓，红粉绿白交织如调色盘。"),
        PlantSpecies(emoji: "🦌", name: "鹿角蕨", sciName: "Platycerium bifurcatum", family: "鹿角蕨科", origin: "澳大利亚", waterInterval: "5-7天", light: "明亮散射光", leafType: "二型叶·鹿角形", desc: "孢子叶形似鹿角垂挂，热带雨林中的空中艺术品。"),
        PlantSpecies(emoji: "🌬️", name: "空气凤梨", sciName: "Tillandsia ionantha", family: "凤梨科", origin: "中南美洲", waterInterval: "2-3天", light: "明亮散射光", leafType: "银灰色·鳞片状", desc: "无需土壤，靠叶片鳞片吸收空气中水分和养分。"),
        PlantSpecies(emoji: "🌸", name: "秋海棠", sciName: "Begonia rex", family: "秋海棠科", origin: "亚洲热带", waterInterval: "5-7天", light: "明亮散射光", leafType: "不对称·金属光泽", desc: "叶片色彩斑斓，银灰、紫红、翠绿交织，带金属质感。"),
    ]

    var families: [String] {
        ["全部"] + Array(Set(speciesList.map { $0.family })).sorted()
    }
    var filtered: [PlantSpecies] {
        selectedFamily == "全部" ? speciesList : speciesList.filter { $0.family == selectedFamily }
    }

    var body: some View {
        ScrollView {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(families, id: \.self) { f in
                        Button(f) { selectedFamily = f }
                            .font(.caption).padding(.horizontal, 12).padding(.vertical, 6)
                            .background(selectedFamily == f ? Color.green : Color(.systemGray6), in: Capsule())
                            .foregroundStyle(selectedFamily == f ? .white : .primary)
                    }
                }.padding(.horizontal)
            }

            LazyVStack(spacing: 12) {
                ForEach(filtered) { sp in
                    DisclosureGroup {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("光照: \(sp.light)").font(.caption)
                            Text("浇水: \(sp.waterInterval)").font(.caption)
                            Text("原产地: \(sp.origin)").font(.caption)
                            Text("叶片: \(sp.leafType)").font(.caption)
                            Text(sp.desc).font(.caption).foregroundStyle(.secondary)
                        }
                        .padding(.top, 4)
                    } label: {
                        HStack {
                            Text(sp.emoji).font(.title2)
                            VStack(alignment: .leading) {
                                Text(sp.name).font(.subheadline).bold()
                                Text(sp.sciName).font(.caption2).italic().foregroundStyle(.secondary)
                            }
                        }
                    }
                    .padding()
                    .background(Color(.systemBackground), in: RoundedRectangle(cornerRadius: 12))
                    .shadow(color: .black.opacity(0.04), radius: 4, y: 2)
                }
            }.padding(.horizontal)
        }
        .navigationTitle("品种图鉴")
    }
}

// MARK: - GrowthPolaroidView, PestGuideView
struct GrowthPolaroidView: View {
    @EnvironmentObject var store: PlantStore
    @State private var selectedPlant: Plant?
    @State private var showCollage = false

    let growthData: [String: [(date: String, color: Color, note: String)]] = [
        "龟背竹": [("6月1日", Color.green.opacity(0.3), "新入盆"), ("6月15日", Color.green.opacity(0.45), "新叶萌发"), ("7月1日", Color.green.opacity(0.6), "叶片深裂")],
        "花烛红掌": [("6月3日", Color.pink.opacity(0.3), "新入盆"), ("6月17日", Color.pink.opacity(0.45), "花色显现"), ("7月1日", Color.pink.opacity(0.6), "盛花期")],
        "琴叶榕": [("6月5日", Color.mint.opacity(0.3), "新购入"), ("6月19日", Color.mint.opacity(0.45), "新叶伸展"), ("7月3日", Color.mint.opacity(0.6), "革质光泽")],
    ]

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                VStack(spacing: 12) {
                    Text("POLAROID GROWTH").font(.caption).foregroundStyle(.secondary).kerning(2)
                    Picker("选择植物", selection: $selectedPlant) {
                        Text("-- 选择植物 --").tag(nil as Plant?)
                        ForEach(store.plants) { plant in
                            Text("\(plant.emoji) \(plant.name)").tag(plant as Plant?)
                        }
                    }
                    .pickerStyle(.menu)

                    Button {
                        if selectedPlant != nil { showCollage = true }
                    } label: {
                        Circle().fill(.red).frame(width: 40, height: 40)
                            .overlay(Circle().stroke(.gray, lineWidth: 3))
                    }
                    Text("SHOOT").font(.caption).foregroundStyle(.secondary)
                }
                .padding()
                .background(Color(.systemGray6), in: RoundedRectangle(cornerRadius: 16))
                .padding(.horizontal)

                if showCollage, let plant = selectedPlant {
                    collageView(plant)
                }
            }
            .padding(.vertical)
        }
        .navigationTitle("成长拍立得")
    }

    func collageView(_ plant: Plant) -> some View {
        let photos = growthData[plant.name] ?? []
        return VStack(spacing: 0) {
            ForEach(photos.indices, id: \.self) { i in
                let p = photos[i]
                ZStack(alignment: .bottomLeading) {
                    p.color.frame(height: 80)
                    Text("\(p.date) · \(p.note)").font(.caption2).padding(4)
                        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 4))
                        .padding(4)
                }
            }
            Text(plant.name).font(.footnote).foregroundStyle(.secondary).padding(.vertical, 8)
        }
        .padding(12)
        .background(Color.white, in: RoundedRectangle(cornerRadius: 4))
        .shadow(color: .black.opacity(0.1), radius: 8, y: 4)
        .padding(.horizontal, 24)
        .transition(.move(edge: .top).combined(with: .opacity))
        .animation(.spring(duration: 0.5), value: showCollage)
    }
}

struct PestGuideView: View {
    @State private var filter: PestType?

    let pests: [PestEntry] = [
        PestEntry(icon: "🔴", name: "炭疽病", type: .disease, severity: "★★★★", plants: "天南星科·桑科",
                  symptoms: "叶片出现圆形褐色斑点，边缘深褐色，中心灰白色。",
                  treatment: "1. 剪除病叶\n2. 百菌清800倍液，每7天一次\n3. 保持通风干燥",
                  prevention: "保持通风，避免叶片积水。春秋季每月喷多菌灵预防。"),
        PestEntry(icon: "🟤", name: "根腐病", type: .disease, severity: "★★★★★", plants: "所有热带植物",
                  symptoms: "植株基部发黑软化，根系腐烂发臭。",
                  treatment: "1. 脱盆剪除烂根\n2. 高锰酸钾1000倍液浸泡15分钟\n3. 晾根2-3天换新土",
                  prevention: "透气颗粒土，干透浇透。冬季控水。"),
        PestEntry(icon: "🕷️", name: "红蜘蛛", type: .pest, severity: "★★★", plants: "天南星科·桑科",
                  symptoms: "叶片细小黄白斑点，叶背有红色虫体和细网。",
                  treatment: "1. 清水冲洗叶片\n2. 阿维菌素1500倍液喷叶背\n3. 增加环境湿度",
                  prevention: "保持湿度50%以上，每月检查叶片背面。"),
        PestEntry(icon: "🪲", name: "介壳虫", type: .pest, severity: "★★★★", plants: "天南星科·兰科",
                  symptoms: "叶片和茎干出现白色棉絮状附着物，引发煤污病。",
                  treatment: "1. 酒精点涂虫体\n2. 矿物油乳剂100倍液\n3. 噻虫嗪2000倍液灌根",
                  prevention: "新植物仔细检查，定期清理枯叶。"),
        PestEntry(icon: "🟡", name: "叶斑病", type: .disease, severity: "★★★", plants: "天南星科·兰科",
                  symptoms: "叶片出现水渍状黄褐色小斑，逐渐扩大成不规则斑块。",
                  treatment: "1. 隔离病株剪除病叶\n2. 代森锰锌600倍液\n3. 增加光照减少浇水",
                  prevention: "通风避免闷热潮湿，定期检查叶片背面。"),
        PestEntry(icon: "🐛", name: "蓟马", type: .pest, severity: "★★★", plants: "天南星科·秋海棠科",
                  symptoms: "叶片银白色条纹，新叶扭曲变形。",
                  treatment: "1. 悬挂蓝色粘虫板\n2. 吡虫啉2000倍液\n3. 剪除受害部位",
                  prevention: "定期检查嫩叶花苞，保持通风，避免过度密植。"),
    ]

    var filtered: [PestEntry] {
        if let filter { pests.filter { $0.type == filter } } else { pests }
    }

    var body: some View {
        ScrollView {
            HStack(spacing: 8) {
                Button("全部") { filter = nil }
                    .font(.caption).padding(.horizontal, 12).padding(.vertical, 6)
                    .background(filter == nil ? Color.green : Color(.systemGray6), in: Capsule())
                    .foregroundStyle(filter == nil ? .white : .primary)
                ForEach(PestType.allCases, id: \.self) { t in
                    Button(t.rawValue) { filter = t }
                        .font(.caption).padding(.horizontal, 12).padding(.vertical, 6)
                        .background(filter == t ? Color.green : Color(.systemGray6), in: Capsule())
                        .foregroundStyle(filter == t ? .white : .primary)
                }
            }.padding(.horizontal)

            LazyVStack(spacing: 12) {
                ForEach(filtered) { pest in
                    DisclosureGroup {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("症状：\(pest.symptoms)").font(.caption)
                            Text("治疗：\(pest.treatment)").font(.caption).foregroundStyle(.red)
                            Text("预防：\(pest.prevention)").font(.caption).foregroundStyle(Color.green)
                            Text("易感植物：\(pest.plants)").font(.caption2).foregroundStyle(.secondary)
                        }.padding(.top, 4)
                    } label: {
                        HStack {
                            Text(pest.icon).font(.title2)
                            VStack(alignment: .leading) {
                                Text(pest.name).font(.subheadline).bold()
                                Text("危害 \(pest.severity)").font(.caption2).foregroundStyle(.secondary)
                            }
                        }
                    }
                    .padding()
                    .background(Color(.systemBackground), in: RoundedRectangle(cornerRadius: 12))
                    .shadow(color: .black.opacity(0.04), radius: 4, y: 2)
                }
            }.padding(.horizontal)
        }
        .navigationTitle("病虫害图鉴")
    }
}

// MARK: - SupplyManagerView, WishlistView
struct SupplyManagerView: View {
    @EnvironmentObject var store: PlantStore
    @State private var showAdd = false
    @State private var filter: SupplyType?
    @State private var newName = ""
    @State private var newType: SupplyType = .fertilizer
    @State private var newDate = ""
    @State private var newNote = ""

    var filtered: [Supply] {
        if let filter { store.supplies.filter { $0.type == filter } } else { store.supplies }
    }

    var body: some View {
        List {
            Section {
                HStack {
                    TextField("名称", text: $newName)
                    Picker("类型", selection: $newType) {
                        ForEach(SupplyType.allCases, id: \.self) { t in Text(t.rawValue).tag(t) }
                    }
                }
                HStack {
                    TextField("购买日期", text: $newDate)
                    TextField("备注", text: $newNote)
                }
                Button("添加记录") {
                    guard !newName.isEmpty else { return }
                    store.addSupply(Supply(name: newName, type: newType, date: newDate.isEmpty ? "未知" : newDate, note: newNote))
                    newName = ""; newDate = ""; newNote = ""
                }
                .disabled(newName.isEmpty)
            }

            Section {
                Picker("筛选", selection: $filter) {
                    Text("全部 (\(store.supplies.count))").tag(nil as SupplyType?)
                    ForEach(SupplyType.allCases, id: \.self) { t in
                        Text("\(t.rawValue) (\(store.supplies.filter{$0.type==t}.count))").tag(t as SupplyType?)
                    }
                }
            }

            Section {
                ForEach(filtered) { item in
                    HStack {
                        Text(item.type.icon)
                        VStack(alignment: .leading) {
                            Text(item.name).font(.subheadline)
                            Text("\(item.date) · \(item.note)").font(.caption).foregroundStyle(.secondary)
                        }
                        Spacer()
                        Text(item.type.rawValue).font(.caption2).padding(.horizontal, 6).padding(.vertical, 2)
                            .background(item.type == .fertilizer ? Color.green.opacity(0.15) : item.type == .pesticide ? Color.orange.opacity(0.15) : Color.blue.opacity(0.15), in: Capsule())
                    }
                }
                .onDelete { idx in
                    for i in idx {
                        store.deleteSupply(filtered[i])
                    }
                }
            }
        }
        .navigationTitle("肥料药品管理")
    }
}

struct WishlistView: View {
    @EnvironmentObject var store: PlantStore
    @State private var showAdd = false
    @State private var newName = ""
    @State private var newPhoto: UIImage?
    @State private var showPhotoPicker = false
    @State private var photoItem: PhotosPickerItem?

    var body: some View {
        List {
            Section {
                HStack {
                    TextField("植物名称", text: $newName)
                    Button {
                        showPhotoPicker = true
                    } label: {
                        Image(systemName: newPhoto == nil ? "photo.badge.plus" : "photo.fill")
                            .foregroundStyle(newPhoto == nil ? Color.secondary : Color.green)
                    }
                }
                Button("加入心愿") {
                    guard !newName.isEmpty else { return }
                    var wish = WishItem(name: newName)
                    if let img = newPhoto {
                        wish.photoData = img.jpegData(compressionQuality: 0.7)
                    }
                    store.addWish(wish)
                    newName = ""; newPhoto = nil
                }
                .disabled(newName.isEmpty)
            }

            Section("心愿清单") {
                ForEach(store.wishes) { wish in
                    HStack {
                        if let data = wish.photoData, let uiImage = UIImage(data: data) {
                            Image(uiImage: uiImage).resizable().scaledToFill()
                                .frame(width: 44, height: 44).clipShape(RoundedRectangle(cornerRadius: 8))
                        } else {
                            RoundedRectangle(cornerRadius: 8).fill(Color(.systemGray6))
                                .frame(width: 44, height: 44)
                                .overlay(Image(systemName: "photo").foregroundStyle(.secondary))
                        }
                        Text(wish.name).font(.subheadline)
                            .strikethrough(wish.owned).foregroundStyle(wish.owned ? .secondary : .primary)
                        Spacer()
                        Button {
                            store.toggleWishOwned(wish)
                        } label: {
                            Image(systemName: wish.owned ? "checkmark.circle.fill" : "circle")
                                .foregroundStyle(wish.owned ? Color.green : Color.secondary)
                        }
                    }
                }
                .onDelete { idx in
                    for i in idx { store.deleteWish(store.wishes[i]) }
                }
            }
        }
        .navigationTitle("心愿清单")
        .photosPicker(isPresented: $showPhotoPicker, selection: $photoItem, matching: .images)
        .onChange(of: photoItem) { _, item in
            Task {
                if let data = try? await item?.loadTransferable(type: Data.self),
                   let img = UIImage(data: data) {
                    newPhoto = img
                }
            }
        }
    }
}

// MARK: - App Entry
@main
struct 植物记录App: App {
    @StateObject private var store = PlantStore()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(store)
        }
    }
}