import SwiftUI
import Combine
import PhotosUI

// MARK: - 美式拼贴撕纸风 · 色彩系统
// 牛皮纸底 · 报纸头条 · 撕纸边缘 · 邮票印章 · 打字机字体 · 粗粝手工感
extension Color {
    static let kraft      = Color(red: 212/255, green: 184/255, blue: 150/255)
    static let kraftDark  = Color(red: 184/255, green: 155/255, blue: 118/255)
    static let kraftLight = Color(red: 232/255, green: 217/255, blue: 196/255)
    static let newsprint  = Color(red: 244/255, green: 237/255, blue: 224/255)
    static let paperWhite = Color(red: 253/255, green: 250/255, blue: 244/255)
    static let inkBlack   = Color(red: 30/255,  green: 27/255,  blue: 24/255)
    static let inkDim     = Color(red: 107/255, green: 94/255,  blue: 83/255)
    static let accentRed  = Color(red: 196/255, green: 30/255,  blue: 58/255)
    static let redDeep    = Color(red: 155/255, green: 27/255,  blue: 48/255)
    static let navyBlue   = Color(red: 27/255,  green: 54/255,  blue: 93/255)
    static let mustard    = Color(red: 212/255, green: 160/255, blue: 23/255)
    static let oliveGreen = Color(red: 92/255,  green: 107/255, blue: 60/255)
    static let amberGold  = Color(red: 232/255, green: 168/255, blue: 56/255)
    static let tealWater  = Color(red: 46/255,  green: 107/255, blue: 98/255)
    static let bgWarm     = Color(red: 232/255, green: 221/255, blue: 210/255)
}

// MARK: - 自定义字体修饰
struct MonospaceLabel: ViewModifier {
    var size: CGFloat = 9
    var color: Color = .inkDim
    func body(content: Content) -> some View {
        content
            .font(.system(size: size, weight: .bold, design: .monospaced))
            .foregroundColor(color)
            .textCase(.uppercase)
    }
}

struct KraftCard: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(Color.paperWhite)
            .overlay(Rectangle().stroke(Color.inkBlack.opacity(0.1), lineWidth: 1))
    }
}

// MARK: - 视图扩展
extension View {
    func monospaceLabel(size: CGFloat = 9, color: Color = .inkDim) -> some View {
        modifier(MonospaceLabel(size: size, color: color))
    }
    func kraftCard() -> some View {
        modifier(KraftCard())
    }
    func hardShadow(_ color: Color = .kraftDark) -> some View {
        self.shadow(color: color, radius: 0, x: 3, y: 3)
    }
    func softShadow() -> some View {
        self.shadow(color: .inkBlack.opacity(0.06), radius: 2, x: 2, y: 2)
    }
    func inkBorder(_ width: CGFloat = 1) -> some View {
        self.overlay(Rectangle().stroke(Color.inkBlack.opacity(0.1), lineWidth: width))
    }
}

// MARK: - 模型
struct Plant: Identifiable, Codable, Hashable {
    var id = UUID()
    var name: String; var emoji: String; var sciName: String
    var family: String; var alias: String; var origin: String
    var waterInterval: String; var light: String; var leafType: String
    var adoptedDate: Date; var status: String = "健康"; var growthValue: Double = 0.5
    var desc: String = ""; var photoData: Data?
}

struct CareEvent: Identifiable, Codable {
    var id = UUID(); var type: EventType; var plantName: String
    var note: String; var date: Date; var photoData: [Data] = []
}

enum EventType: String, Codable, CaseIterable {
    case water="浇水", fertilize="施肥", pesticide="杀虫", repot="换盆"
    case divide="分苗", merge="合盆", enclosed="闷养", outdoor="露养"
    case mount="上板", newPlant="新买", death="死亡"
    var emoji: String {
        switch self {
        case .water:"💧"; case .fertilize:"🧪"; case .pesticide:"💊"; case .repot:"🪴"
        case .divide:"✂️"; case .merge:"🤝"; case .enclosed:"🏠"; case .outdoor:"🌤️"
        case .mount:"🪵"; case .newPlant:"🛒"; case .death:"🕯️"
        }
    }
    var eventColor: Color {
        switch self {
        case .water:.tealWater; case .newPlant:.oliveGreen; case .repot:Color(red:198/255,green:124/255,blue:92/255)
        case .pesticide:.mustard; case .death:Color(red:138/255,green:126/255,blue:118/255)
        case .fertilize:Color(red:196/255,green:160/255,blue:53/255)
        case .divide:Color(red:58/255,green:125/255,blue:124/255)
        case .merge:Color(red:139/255,green:94/255,blue:140/255)
        case .enclosed:Color(red:90/255,green:122/255,blue:158/255)
        case .outdoor:Color(red:107/255,green:163/255,blue:184/255)
        case .mount:Color(red:160/255,green:123/255,blue:92/255)
        }
    }
}

struct Memorial: Identifiable, Codable {
    var id=UUID(); var emoji:String; var name:String
    var adoptedDate:String; var partedDate:String; var cause:String; var causeType:String
}
struct ReceiptItem: Identifiable, Codable { var id=UUID(); var emoji:String; var name:String; var quantity:Int; var price:Double }
struct ReceiptPeriod: Identifiable, Codable { var id:String; var title:String; var subtitle:String; var items:[ReceiptItem] }
struct ShelfSlot: Codable { var plantIndex:Int?; var potIndex:Int? }
struct ShelfLayout: Codable { var name:String; var emoji:String; var slots:[[ShelfSlot]] }
struct PlantSpecies: Identifiable { var id=UUID(); var emoji:String; var name:String; var sciName:String; var family:String; var origin:String; var waterInterval:String; var light:String; var leafType:String; var desc:String }
struct GrowthPhoto: Identifiable, Codable { var id=UUID(); var date:String; var note:String; var photoData:Data? }
struct PestEntry: Identifiable { var id=UUID(); var icon:String; var name:String; var type:PestType; var severity:String; var plants:String; var symptoms:String; var treatment:String; var prevention:String }
enum PestType: String, CaseIterable { case disease="病害", pest="虫害" }
struct Supply: Identifiable, Codable { var id=UUID(); var name:String; var type:SupplyType; var date:String; var note:String }
enum SupplyType: String, Codable, CaseIterable {
    case fertilizer="肥料", pesticide="药品", tool="工具"
    var icon: String { switch self { case .fertilizer:"🧪"; case .pesticide:"💊"; case .tool:"🔧" } }
}
struct WishItem: Identifiable, Codable { var id=UUID(); var name:String; var photoData:Data?; var owned:Bool=false }

// MARK: - PlantStore
class PlantStore: ObservableObject {
    @Published var plants: [Plant] = []
    @Published var events: [CareEvent] = []
    @Published var memorials: [Memorial] = []
    @Published var supplies: [Supply] = []
    @Published var wishes: [WishItem] = []

    init() { loadSampleData() }

    func loadSampleData() {
        plants = [
            Plant(name:"龟背竹",emoji:"🌿",sciName:"Monstera deliciosa",family:"天南星科",alias:"蓬莱蕉",origin:"中美洲",waterInterval:"5-7天",light:"明亮散射光",leafType:"心形·深裂",adoptedDate:Calendar.current.date(byAdding:.day,value:-128,to:Date())!,status:"健康",growthValue:0.85,desc:"叶片宽大呈心形，成熟后深裂成羽毛状，是热带雨林经典观叶植物。"),
            Plant(name:"花烛红掌",emoji:"🌺",sciName:"Anthurium andraeanum",family:"天南星科",alias:"红掌",origin:"哥伦比亚",waterInterval:"5-7天",light:"明亮散射光",leafType:"心形·蜡质",adoptedDate:Calendar.current.date(byAdding:.day,value:-95,to:Date())!,status:"健康",growthValue:0.72,desc:"佛焰苞鲜红亮丽，形似爱心，花期长达2-3个月。"),
            Plant(name:"琴叶榕",emoji:"🪴",sciName:"Ficus lyrata",family:"桑科",alias:"小提琴榕",origin:"西非",waterInterval:"7-10天",light:"明亮散射光",leafType:"提琴形·革质",adoptedDate:Calendar.current.date(byAdding:.day,value:-60,to:Date())!,status:"健康",growthValue:0.6,desc:"叶片形似小提琴，革质厚实有光泽，北欧风标志性植物。"),
            Plant(name:"蝴蝶兰",emoji:"🦋",sciName:"Phalaenopsis aphrodite",family:"兰科",alias:"蝶兰",origin:"东南亚",waterInterval:"7-10天",light:"明亮散射光",leafType:"椭圆形·肉质",adoptedDate:Calendar.current.date(byAdding:.day,value:-45,to:Date())!,status:"开花中",growthValue:0.9,desc:"花姿优雅如蝴蝶翩翩，花期长达3-6个月。"),
            Plant(name:"彩叶芋",emoji:"🍂",sciName:"Caladium bicolor",family:"天南星科",alias:"花叶芋",origin:"南美",waterInterval:"5-7天",light:"明亮散射光",leafType:"心形·霓虹色斑",adoptedDate:Calendar.current.date(byAdding:.day,value:-30,to:Date())!,status:"健康",growthValue:0.55,desc:"叶片色彩斑斓，红粉绿白交织如调色盘。"),
            Plant(name:"鹿角蕨",emoji:"🦌",sciName:"Platycerium bifurcatum",family:"鹿角蕨科",alias:"蝙蝠蕨",origin:"澳大利亚",waterInterval:"5-7天",light:"明亮散射光",leafType:"二型叶·鹿角形",adoptedDate:Calendar.current.date(byAdding:.day,value:-25,to:Date())!,status:"健康",growthValue:0.5,desc:"孢子叶形似鹿角垂挂，热带雨林中的空中艺术品。"),
            Plant(name:"空气凤梨",emoji:"🌬️",sciName:"Tillandsia ionantha",family:"凤梨科",alias:"空凤",origin:"中南美洲",waterInterval:"2-3天",light:"明亮散射光",leafType:"银灰色·鳞片状",adoptedDate:Calendar.current.date(byAdding:.day,value:-20,to:Date())!,status:"健康",growthValue:0.4,desc:"无需土壤，靠叶片鳞片吸收空气中水分和养分。"),
            Plant(name:"秋海棠",emoji:"🌸",sciName:"Begonia rex",family:"秋海棠科",alias:"彩叶海棠",origin:"亚洲热带",waterInterval:"5-7天",light:"明亮散射光",leafType:"不对称·金属光泽",adoptedDate:Calendar.current.date(byAdding:.day,value:-15,to:Date())!,status:"健康",growthValue:0.35,desc:"叶片色彩斑斓，银灰、紫红、翠绿交织，带金属质感。"),
        ]
        events = [
            CareEvent(type:.water,plantName:"龟背竹",note:"浇透水，盆底流出",date:Date()),
            CareEvent(type:.fertilize,plantName:"花烛红掌",note:"施缓释肥",date:Calendar.current.date(byAdding:.day,value:-3,to:Date())!),
            CareEvent(type:.repot,plantName:"琴叶榕",note:"换大一号盆",date:Calendar.current.date(byAdding:.day,value:-5,to:Date())!),
            CareEvent(type:.newPlant,plantName:"秋海棠",note:"新入盆·状态记录",date:Calendar.current.date(byAdding:.day,value:-15,to:Date())!),
        ]
        memorials = [
            Memorial(emoji:"🪴",name:"彩叶草",adoptedDate:"2025年3月",partedDate:"2026年5月",cause:"浇水过多导致根腐",causeType:"养护失误"),
            Memorial(emoji:"🌿",name:"绿萝",adoptedDate:"2024年8月",partedDate:"2026年1月",cause:"冬季冻伤",causeType:"环境因素"),
        ]
        supplies = [
            Supply(name:"热带植物缓释肥",type:.fertilizer,date:"6月1日",note:"200g·每2月撒一次"),
            Supply(name:"百菌清",type:.pesticide,date:"6月5日",note:"100ml·稀释800倍"),
            Supply(name:"HB-101活力素",type:.fertilizer,date:"6月10日",note:"50ml·稀释1000倍"),
            Supply(name:"阿维菌素",type:.pesticide,date:"6月15日",note:"200ml·稀释1500倍"),
            Supply(name:"吡虫啉",type:.pesticide,date:"6月20日",note:"100ml·稀释2000倍"),
            Supply(name:"尖嘴浇水壶",type:.tool,date:"6月1日",note:"500ml·精准控水"),
        ]
        wishes = [
            WishItem(name:"白锦龟背竹"), WishItem(name:"洒金蔓绿绒"), WishItem(name:"帝王花烛"),
            WishItem(name:"斑叶橙柄蔓绿绒"), WishItem(name:"荧光蔓绿绒"),
        ]
    }
    func addPlant(_ plant:Plant) { plants.append(plant) }
    func deletePlant(_ plant:Plant) { plants.removeAll{$0.id==plant.id} }
    func addEvent(_ event:CareEvent) { events.insert(event,at:0) }
    func eventsForDate(_ date:Date)->[CareEvent] { events.filter{Calendar.current.isDate($0.date,inSameDayAs:date)} }
    func eventsForMonth(_ date:Date)->[CareEvent] {
        let cal=Calendar.current
        guard let ms=cal.date(from:cal.dateComponents([.year,.month],from:date)),
              let me=cal.date(byAdding:DateComponents(month:1,day:-1),to:ms) else { return[] }
        return events.filter{$0.date>=ms&&$0.date<=me}
    }
    func daysWithEventsInMonth(_ date:Date)->Set<Int> { Set(eventsForMonth(date).map{Calendar.current.component(.day,from:$0.date)}) }
    func eventsForDay(_ day:Int,inMonth date:Date)->[CareEvent] {
        let cal=Calendar.current; return eventsForMonth(date).filter{cal.component(.day,from:$0.date)==day}
    }
    func addMemorial(_ m:Memorial) { memorials.append(m) }
    func addSupply(_ s:Supply) { supplies.append(s) }
    func deleteSupply(_ s:Supply) { supplies.removeAll{$0.id==s.id} }
    func addWish(_ w:WishItem) { wishes.append(w) }
    func toggleWishOwned(_ w:WishItem) { if let i=wishes.firstIndex(where:{$0.id==w.id}){wishes[i].owned.toggle()} }
    func deleteWish(_ w:WishItem) { wishes.removeAll{$0.id==w.id} }
}

// MARK: - 美式牛皮纸背景
struct KraftBackground: View {
    var body: some View {
        ZStack {
            Color.bgWarm
            RadialGradient(colors:[Color.kraft.opacity(0.35),.clear], center:.topLeading, startRadius:0, endRadius:400)
            RadialGradient(colors:[Color(red:180/255,green:160/255,blue:130/255).opacity(0.25),.clear], center:.bottomTrailing, startRadius:0, endRadius:350)
        }.ignoresSafeArea()
    }
}

// MARK: - 报纸头条横幅
struct HeadlineBanner: View {
    let title: String
    let subtitle: String
    var body: some View {
        VStack(spacing: 0) {
            Text("热带植物时报")
                .monospaceLabel(size: 8, color: .accentRed)
                .padding(.horizontal, 8).padding(.vertical, 2)
                .background(Color.paperWhite)
                .overlay(Rectangle().stroke(Color.accentRed, lineWidth: 1))
                .offset(y: 6).zIndex(1)
            VStack(spacing: 4) {
                Text(title).font(.system(size: 22, weight: .black)).foregroundColor(.inkBlack)
                    .kerning(2).textCase(.uppercase)
                Text(subtitle).monospaceLabel(size: 9).kerning(2)
            }
            .frame(maxWidth:.infinity).padding(.vertical,16)
            .background(Color.paperWhite)
            .overlay(Rectangle().stroke(Color.inkBlack, lineWidth: 3))
        }
    }
}

// MARK: - 自定义导航栏
struct VintageNavBar: View {
    @Binding var selectedTab: Int
    @Binding var showAddRecord: Bool
    let tabs: [(String, String)] = [
        ("leaf.fill", "Garden"), ("calendar", "Calendar"),
        ("plus", ""), ("bell.fill", "Remind"), ("person.fill", "Profile")
    ]
    var body: some View {
        HStack(spacing: 0) {
            ForEach(0..<tabs.count, id:\.self) { i in
                if i == 2 {
                    Button { showAddRecord = true } label: {
                        Image(systemName: "plus")
                            .font(.system(size: 20, weight: .black))
                            .foregroundColor(.paperWhite)
                            .frame(width: 48, height: 48)
                            .background(Color.accentRed)
                            .overlay(Rectangle().stroke(Color.inkBlack, lineWidth: 2))
                            .shadow(color: .navyBlue, radius: 0, x: 4, y: 4)
                    }
                    .offset(y: -8)
                    .frame(maxWidth: .infinity)
                } else {
                    Button { selectedTab = i } label: {
                        VStack(spacing: 4) {
                            Image(systemName: tabs[i].0)
                                .font(.system(size: 20))
                                .foregroundColor(selectedTab == i ? .inkBlack : .inkDim)
                            Text(tabs[i].1)
                                .monospaceLabel(size: 7, color: selectedTab == i ? .inkBlack : .inkDim)
                                .kerning(1)
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
            }
        }
        .padding(.horizontal, 8).padding(.top, 10).padding(.bottom, 20)
        .background(Color.paperWhite)
        .overlay(alignment:.top) { Rectangle().fill(Color.inkBlack).frame(height: 2) }
    }
}

// MARK: - ContentView
struct ContentView: View {
    @EnvironmentObject var store: PlantStore
    @State private var selectedTab = 0
    @State private var showAddRecord = false

    var body: some View {
        ZStack(alignment: .bottom) {
            KraftBackground()
            TabView(selection: $selectedTab) {
                NavigationStack { HomeView() }.tag(0)
                NavigationStack { CalendarView() }.tag(1)
                NavigationStack { ReminderView() }.tag(3)
                NavigationStack { ProfileView() }.tag(4)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            VintageNavBar(selectedTab: $selectedTab, showAddRecord: $showAddRecord)
        }
        .sheet(isPresented: $showAddRecord) { AddRecordView() }
        .ignoresSafeArea(.keyboard)
    }
}

// MARK: - HomeView
struct HomeView: View {
    @EnvironmentObject var store: PlantStore
    @State private var weatherIndex = 0
    let weathers: [(String,String,String,Color,Color)] = [
        ("☀️","32°","SUNNY · 注意遮阴",Color(red:254/255,green:245/255,blue:224/255),Color(red:248/255,green:232/255,blue:200/255)),
        ("🌧️","26°","RAIN · 不用浇水",Color(red:168/255,green:181/255,blue:192/255),Color(red:188/255,green:197/255,blue:205/255)),
        ("⛅","28°","CLOUDY · 适合通风",Color(red:240/255,green:235/255,blue:228/255),Color(red:224/255,green:221/255,blue:213/255)),
    ]

    var body: some View {
        ZStack {
            KraftBackground()
            ScrollView {
                VStack(spacing: 14) {
                    HeadlineBanner(title: "TROPICAL GARDEN", subtitle: "DAILY REPORT · \(todayString())")
                        .padding(.horizontal, 12).padding(.top, 8)
                    weatherCard.padding(.horizontal, 12)
                    if let plant = store.plants.randomElement() {
                        featuredPlant(plant).padding(.horizontal, 12)
                    }
                    pendingAlerts.padding(.horizontal, 12)
                    // 植物收藏
                    HStack {
                        Text("MY COLLECTION").monospaceLabel(size: 10, color: .inkBlack)
                        Spacer()
                        Text("\(store.plants.count) PLANTS").monospaceLabel(size: 8)
                    }.padding(.horizontal, 16).padding(.top, 8)
                    LazyVGrid(columns:[GridItem(.flexible()),GridItem(.flexible())], spacing: 12) {
                        ForEach(store.plants) { plant in
                            NavigationLink(destination: PlantDetailView(plant: plant)) {
                                plantCard(plant)
                            }.buttonStyle(.plain)
                        }
                    }.padding(.horizontal, 12)
                }.padding(.bottom, 100)
            }
        }
        .navigationBarHidden(true)
        .onAppear { weatherIndex = Int.random(in: 0..<weathers.count) }
    }
    func todayString() -> String {
        let f = DateFormatter(); f.dateFormat = "MMM dd · EEEE"; return f.string(from: Date()).uppercased()
    }
    var weatherCard: some View {
        let w = weathers[weatherIndex]
        return VStack(spacing:0) {
            HStack(alignment:.top) {
                VStack(alignment:.leading, spacing: 4) {
                    Text("WEATHER REPORT").monospaceLabel(size: 8, color: .accentRed)
                    Text(w.2).font(.system(size: 13, weight: .bold, design: .monospaced)).foregroundColor(.inkBlack)
                    Text(w.1).font(.system(size: 36, weight: .black, design: .monospaced)).foregroundColor(.inkBlack)
                }
                Spacer()
                Text(w.0).font(.system(size: 48))
            }.padding(16)
            .background(LinearGradient(colors:[w.3,w.4,.paperWhite], startPoint:.top, endPoint:.bottom))
            .overlay(Rectangle().stroke(Color.inkBlack, lineWidth: 2))
        }
    }
    func featuredPlant(_ plant: Plant) -> some View {
        NavigationLink(destination: PlantDetailView(plant: plant)) {
            HStack(spacing: 10) {
                Text(plant.emoji).font(.system(size: 44))
                    .frame(width: 60, height: 60)
                    .background(Color.kraftLight)
                    .overlay(Rectangle().stroke(Color.inkBlack, lineWidth: 2))
                VStack(alignment:.leading, spacing: 2) {
                    Text("★ FEATURED").monospaceLabel(size: 7, color: .accentRed)
                    Text(plant.name).font(.system(size: 18, weight: .black)).foregroundColor(.inkBlack)
                    Text(plant.sciName).font(.system(size: 10, design: .monospaced)).foregroundColor(.inkDim).italic()
                }
                Spacer()
                Image(systemName: "arrow.right").font(.system(size: 14, weight: .bold)).foregroundColor(.inkBlack)
            }
            .padding(12).background(Color.paperWhite)
            .overlay(Rectangle().stroke(Color.inkBlack, lineWidth: 1))
            .shadow(color: .kraftDark, radius: 0, x: 3, y: 3)
        }.buttonStyle(.plain)
    }
    var pendingAlerts: some View {
        VStack(alignment:.leading, spacing: 8) {
            Text("PENDING TASKS").monospaceLabel(size: 10, color: .inkBlack).padding(.horizontal, 4)
            ForEach(store.events.prefix(3)) { event in
                HStack(spacing: 10) {
                    Text(event.type.emoji).font(.system(size: 20))
                        .frame(width: 36, height: 36)
                        .background(Color.kraftLight)
                        .overlay(Rectangle().stroke(Color.inkBlack, lineWidth: 1.5))
                    VStack(alignment:.leading, spacing: 1) {
                        Text("\(event.plantName) · \(event.type.rawValue)")
                            .font(.system(size: 13, weight: .bold)).foregroundColor(.inkBlack)
                        Text(event.date, style: .relative)
                            .monospaceLabel(size: 8).kerning(0.5)
                    }
                    Spacer()
                    Image(systemName: "checkmark").font(.system(size: 10, weight: .bold)).foregroundColor(.inkDim)
                }
                .padding(10).background(Color.paperWhite)
                .overlay(Rectangle().stroke(Color.inkBlack.opacity(0.1), lineWidth: 1))
                .shadow(color: .inkBlack.opacity(0.06), radius: 0, x: 2, y: 2)
            }
        }
    }
    func plantCard(_ plant: Plant) -> some View {
        VStack(spacing: 8) {
            ZStack(alignment:.topTrailing) {
                Text(plant.emoji).font(.system(size: 40))
                    .frame(width: 68, height: 68)
                    .background(Color.kraftLight)
                    .overlay(Rectangle().stroke(Color.inkBlack, lineWidth: 2))
                Circle().fill(Color.accentRed).frame(width: 10, height: 10)
                    .offset(x: 4, y: -4)
            }
            Text(plant.name).font(.system(size: 14, weight: .black)).foregroundColor(.inkBlack)
            Text(plant.family).monospaceLabel(size: 8)
            HStack {
                Text(plant.status).monospaceLabel(size: 7, color: .oliveGreen)
                    .padding(.horizontal, 6).padding(.vertical, 2)
                    .overlay(Rectangle().stroke(Color.oliveGreen, lineWidth: 1.5))
                Spacer()
                Text(plant.waterInterval).monospaceLabel(size: 7)
            }
            // 进度条
            ZStack(alignment:.leading) {
                Rectangle().fill(Color.kraftLight).frame(height: 5)
                    .overlay(Rectangle().stroke(Color.inkDim, lineWidth: 0.5))
                Rectangle().fill(plant.growthValue > 0.7 ? Color.accentRed : Color.mustard)
                    .frame(width: CGFloat(plant.growthValue) * 120, height: 5)
            }
            .frame(maxWidth: .infinity)
        }
        .padding(12).background(Color.paperWhite)
        .overlay(Rectangle().stroke(Color.inkBlack.opacity(0.1), lineWidth: 1))
        .shadow(color: .kraftDark, radius: 0, x: 3, y: 3)
    }
}

// MARK: - PlantDetailView
struct PlantDetailView: View {
    let plant: Plant
    @EnvironmentObject var store: PlantStore
    var plantEvents: [CareEvent] { store.events.filter{$0.plantName==plant.name} }

    var body: some View {
        ZStack {
            KraftBackground()
            ScrollView {
                VStack(spacing: 14) {
                    // ID 卡片
                    VStack(spacing: 0) {
                        // 头部
                        VStack(spacing: 4) {
                            Text("BOTANICAL IDENTITY CARD")
                                .monospaceLabel(size: 8, color: .paperWhite)
                            Text(plant.name).font(.system(size: 22, weight: .black, design: .monospaced))
                                .foregroundColor(.paperWhite).kerning(2)
                        }
                        .frame(maxWidth:.infinity).padding(.vertical, 14)
                        .background(Color.navyBlue)
                        // 内容
                        VStack(spacing: 0) {
                            Text(plant.emoji).font(.system(size: 56)).padding(.vertical, 12)
                            Text(plant.sciName).font(.system(size: 11, design: .monospaced)).foregroundColor(.inkDim).italic()
                            Divider().background(Color.inkBlack.opacity(0.12)).padding(.vertical, 8)
                            idRow("科属 FAMILY", plant.family)
                            idRow("别名 ALIAS", plant.alias)
                            idRow("原产地 ORIGIN", plant.origin)
                            Divider().background(Color.inkBlack.opacity(0.12)).padding(.vertical, 8)
                            idRow("浇水 WATER", plant.waterInterval)
                            idRow("光照 LIGHT", plant.light)
                            idRow("叶片 LEAF", plant.leafType)
                            Divider().background(Color.inkBlack.opacity(0.12)).padding(.vertical, 8)
                            Text(plant.desc).font(.system(size: 12)).foregroundColor(.inkDim)
                                .multilineTextAlignment(.center).padding(.bottom, 8)
                            // 健康印章
                            Text("HEALTHY").font(.system(size: 11, weight: .black, design: .monospaced))
                                .foregroundColor(.accentRed).padding(.horizontal, 14).padding(.vertical, 6)
                                .overlay(Rectangle().stroke(Color.accentRed, lineWidth: 2))
                                .rotationEffect(.degrees(-8)).padding(.bottom, 12)
                            // 条形码
                            HStack(spacing: 1) {
                                ForEach(0..<30, id:\.self) { i in
                                    Rectangle().fill(Color.inkBlack)
                                        .frame(width: [1,2,3,1,2,1,1,2,1,3,2,1,1,2,3,1,2,1,1,2,1,3,2,1,1,2,3,1,1,2][i].map{CGFloat($0)} ?? 1, height: 28)
                                }
                            }.padding(.bottom, 8)
                            Text("ID: #PL-\(String(format:"%04d",abs(plant.name.hashValue)%10000)))")
                                .monospaceLabel(size: 7).kerning(2)
                        }
                        .padding(16).background(Color.paperWhite)
                    }
                    .overlay(Rectangle().stroke(Color.inkBlack, lineWidth: 2))
                    .padding(.horizontal, 12).padding(.top, 8)
                    // 统计行
                    HStack(spacing: 0) {
                        statBlock("128", "DAYS"); statBlock("12", "WATER")
                        statBlock("3", "FERT"); statBlock("1", "REPOT")
                    }
                    .padding(12).background(Color.paperWhite)
                    .overlay(Rectangle().stroke(Color.inkBlack.opacity(0.1), lineWidth: 1))
                    .shadow(color: .inkBlack.opacity(0.06), radius: 0, x: 2, y: 2)
                    .padding(.horizontal, 12)
                    // 时间轴
                    HStack {
                        Text("GROWTH TIMELINE").monospaceLabel(size: 10, color: .inkBlack)
                        Spacer()
                    }.padding(.horizontal, 16)
                    if plantEvents.isEmpty {
                        Text("NO RECORDS YET").monospaceLabel(size: 9).padding()
                    } else {
                        ForEach(plantEvents) { event in timelineRow(event) }
                    }
                }.padding(.bottom, 100)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement:.principal) {
                Text(plant.name).font(.system(size: 16, weight: .black, design: .monospaced)).foregroundColor(.inkBlack)
            }
        }
    }
    func idRow(_ label: String, _ value: String) -> some View {
        HStack {
            Text(label).monospaceLabel(size: 7).frame(width: 100, alignment: .leading)
            Spacer()
            Text(value).font(.system(size: 12, weight: .bold)).foregroundColor(.inkBlack)
        }
        .padding(.vertical, 4).padding(.horizontal, 12)
    }
    func statBlock(_ value: String, _ label: String) -> some View {
        VStack(spacing: 2) {
            Text(value).font(.system(size: 20, weight: .black, design: .monospaced)).foregroundColor(.accentRed)
            Text(label).monospaceLabel(size: 7)
        }.frame(maxWidth:.infinity)
    }
    func timelineRow(_ event: CareEvent) -> some View {
        HStack(alignment:.top, spacing: 10) {
            VStack(spacing:0) {
                Rectangle().fill(Color.inkBlack).frame(width: 14, height: 14)
                Rectangle().fill(Color.inkBlack.opacity(0.15)).frame(width: 2)
            }
            VStack(alignment:.leading, spacing: 3) {
                HStack {
                    Text(event.type.emoji)
                    Text(event.type.rawValue).font(.system(size: 13, weight: .bold, design: .monospaced)).foregroundColor(.inkBlack)
                }
                Text(event.note).font(.system(size: 11)).foregroundColor(.inkDim)
                Text(event.date, style:.date).monospaceLabel(size: 8)
            }
            Spacer()
        }
        .padding(10).background(Color.paperWhite)
        .overlay(Rectangle().stroke(Color.inkBlack.opacity(0.1), lineWidth: 1))
        .shadow(color: .inkBlack.opacity(0.08), radius: 0, x: 2, y: 2)
        .padding(.horizontal, 12)
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
        ZStack {
            Color.bgWarm.ignoresSafeArea()
            ScrollView {
                VStack(spacing: 16) {
                    Text("RECORD GROWTH").font(.system(size: 22, weight: .black, design: .monospaced))
                        .foregroundColor(.inkBlack).kerning(2).padding(.top, 20)
                    // 选择植物
                    VStack(alignment:.leading, spacing: 8) {
                        Text("SELECT PLANT").monospaceLabel(size: 8, color: .accentRed)
                        Picker("植物", selection: $selectedPlant) {
                            Text("-- CHOOSE --").tag("")
                            ForEach(store.plants) { plant in
                                Text("\(plant.emoji) \(plant.name)").tag(plant.name)
                            }
                        }.pickerStyle(.menu)
                            .padding(10).background(Color.paperWhite)
                            .overlay(Rectangle().stroke(Color.inkBlack, lineWidth: 1))
                    }.padding(.horizontal, 12)
                    // 事件类型
                    VStack(alignment:.leading, spacing: 8) {
                        Text("EVENT TYPE").monospaceLabel(size: 8, color: .accentRed)
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: 8) {
                            ForEach(EventType.allCases, id:\.self) { type in
                                Button { selectedType = type } label: {
                                    VStack(spacing: 3) {
                                        Text(type.emoji).font(.title3)
                                        Text(type.rawValue).monospaceLabel(size: 7, color: selectedType == type ? .paperWhite : .inkDim)
                                    }
                                    .frame(maxWidth:.infinity).padding(.vertical, 8)
                                    .background(selectedType == type ? Color.accentRed : Color.paperWhite)
                                    .overlay(Rectangle().stroke(selectedType == type ? Color.accentRed : Color.inkBlack.opacity(0.1), lineWidth: 1))
                                }.buttonStyle(.plain)
                            }
                        }
                    }.padding(.horizontal, 12)
                    // 笔记
                    VStack(alignment:.leading, spacing: 8) {
                        Text("NOTES").monospaceLabel(size: 8, color: .accentRed)
                        TextField("养护细节记录...", text: $note, axis: .vertical)
                            .lineLimit(3...6).font(.system(size: 13))
                            .padding(12).background(Color.paperWhite)
                            .overlay(Rectangle().stroke(Color.inkBlack.opacity(0.1), lineWidth: 1))
                    }.padding(.horizontal, 12)
                    // 照片
                    VStack(alignment:.leading, spacing: 8) {
                        Text("PHOTOS").monospaceLabel(size: 8, color: .accentRed)
                        PhotosPicker(selection: $selectedPhotos, maxSelectionCount: 3, matching: .images) {
                            HStack {
                                Image(systemName: "photo.on.rectangle.angled")
                                Text("SELECT PHOTOS").monospaceLabel(size: 9, color: .inkBlack)
                            }
                            .padding(12).frame(maxWidth:.infinity)
                            .background(Color.paperWhite)
                            .overlay(Rectangle().stroke(Color.inkBlack, lineWidth: 1.5))
                        }
                        if !photoDatas.isEmpty {
                            ScrollView(.horizontal) {
                                HStack {
                                    ForEach(photoDatas.indices, id:\.self) { i in
                                        if let uiImage = UIImage(data: photoDatas[i]) {
                                            Image(uiImage: uiImage).resizable().scaledToFill()
                                                .frame(width: 72, height: 72).clipped()
                                                .overlay(Rectangle().stroke(Color.inkBlack, lineWidth: 2))
                                        }
                                    }
                                }
                            }
                        }
                    }.padding(.horizontal, 12)
                    // 保存按钮
                    Button {
                        saveRecord(); dismiss()
                    } label: {
                        Text("SAVE RECORD")
                            .font(.system(size: 14, weight: .black, design: .monospaced))
                            .foregroundColor(.paperWhite).kerning(3)
                            .frame(maxWidth:.infinity).padding(.vertical, 14)
                            .background(Color.inkBlack)
                            .overlay(Rectangle().stroke(Color.inkBlack, lineWidth: 2))
                            .shadow(color: .accentRed, radius: 0, x: 4, y: 4)
                    }
                    .disabled(selectedPlant.isEmpty)
                    .opacity(selectedPlant.isEmpty ? 0.5 : 1)
                    .padding(.horizontal, 12)
                    Button("取消") { dismiss() }
                        .monospaceLabel(size: 10, color: .inkDim).padding(.bottom, 20)
                }
            }
        }
        .onChange(of: selectedPhotos) { _, newItems in
            Task {
                photoDatas = []
                for item in newItems {
                    if let data = try? await item.loadTransferable(type: Data.self) { photoDatas.append(data) }
                }
            }
        }
    }
    func saveRecord() {
        store.addEvent(CareEvent(type: selectedType, plantName: selectedPlant, note: note, date: Date(), photoData: photoDatas))
    }
}

// MARK: - CalendarView
struct CalendarView: View {
    @EnvironmentObject var store: PlantStore
    @State private var currentDate = Date()
    @State private var selectedDay: Int?
    private var calendar: Calendar { Calendar.current }
    private var daysInMonth: Int { calendar.range(of:.day,in:.month,for:currentDate)!.count }
    private var firstWeekday: Int {
        let comp = calendar.dateComponents([.year,.month], from: currentDate)
        return calendar.component(.weekday, from: calendar.date(from: comp)!)
    }

    var body: some View {
        ZStack {
            KraftBackground()
            ScrollView {
                VStack(spacing: 14) {
                    HeadlineBanner(title: "PLANT CALENDAR", subtitle: "MONTHLY CARE LOG")
                        .padding(.horizontal, 12).padding(.top, 8)
                    // 月份切换
                    HStack {
                        Button { changeMonth(-1) } label: {
                            Image(systemName: "chevron.left").font(.system(size: 16, weight: .black)).foregroundColor(.inkBlack)
                        }
                        Text(currentDate, format: .dateTime.year().month(.wide))
                            .font(.system(size: 20, weight: .black, design: .monospaced)).foregroundColor(.inkBlack)
                            .frame(maxWidth:.infinity)
                        Button { changeMonth(1) } label: {
                            Image(systemName: "chevron.right").font(.system(size: 16, weight: .black)).foregroundColor(.inkBlack)
                        }
                    }.padding(.horizontal, 20)
                    // 选中日事件
                    if let day = selectedDay { dayEventsCard(day).padding(.horizontal, 12) }
                    // 日历网格
                    calendarGrid.padding(.horizontal, 12)
                }.padding(.bottom, 100)
            }
        }
        .navigationBarHidden(true)
    }
    func changeMonth(_ by: Int) {
        if let d = calendar.date(byAdding:.month,value:by,to:currentDate) { currentDate = d; selectedDay = nil }
    }
    var calendarGrid: some View {
        let eventDays = store.daysWithEventsInMonth(currentDate)
        let todayComp = calendar.dateComponents([.year,.month,.day], from: Date())
        let curComp = calendar.dateComponents([.year,.month], from: currentDate)
        let isCurrentMonth = todayComp.year == curComp.year && todayComp.month == curComp.month
        return VStack(spacing: 0) {
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7)) {
                ForEach(["SUN","MON","TUE","WED","THU","FRI","SAT"], id:\.self) { d in
                    Text(d).monospaceLabel(size: 8, color: .inkDim).kerning(1).frame(height: 28)
                }
                ForEach(0..<(firstWeekday - 1), id:\.self) { _ in Color.clear.frame(height: 42) }
                ForEach(1...daysInMonth, id:\.self) { day in
                    let isToday = isCurrentMonth && todayComp.day == day
                    let hasEvent = eventDays.contains(day)
                    Button {
                        selectedDay = (selectedDay == day) ? nil : day
                    } label: {
                        VStack(spacing: 2) {
                            Text("\(day)").font(.system(size: 14, weight: isToday ? .black : .medium, design: .monospaced))
                                .foregroundColor(isToday ? .paperWhite : .inkBlack)
                            if hasEvent { Rectangle().fill(Color.accentRed).frame(width: 4, height: 4) }
                        }
                        .frame(height: 42).frame(maxWidth:.infinity)
                        .background(isToday ? Color.accentRed : (selectedDay == day ? Color.kraftLight : .clear))
                        .overlay(Rectangle().stroke(selectedDay == day ? Color.inkBlack : .clear, lineWidth: 1))
                    }.buttonStyle(.plain)
                }
            }
        }
        .padding(12).background(Color.paperWhite)
        .overlay(Rectangle().stroke(Color.inkBlack, lineWidth: 1.5))
        .shadow(color: .kraftDark, radius: 0, x: 3, y: 3)
    }
    func dayEventsCard(_ day: Int) -> some View {
        let events = store.eventsForDay(day, inMonth: currentDate)
        return VStack(alignment:.leading, spacing: 8) {
            Text("\(calendar.component(.month,from:currentDate))月\(day)日")
                .font(.system(size: 15, weight: .black, design: .monospaced)).foregroundColor(.inkBlack)
            if events.isEmpty {
                Text("NO RECORDS").monospaceLabel(size: 8)
            } else {
                ForEach(events) { event in
                    HStack(spacing: 8) {
                        Text(event.type.emoji).font(.system(size: 18))
                        VStack(alignment:.leading, spacing: 1) {
                            Text("\(event.plantName) · \(event.type.rawValue)")
                                .font(.system(size: 12, weight: .bold)).foregroundColor(.inkBlack)
                            Text(event.note).monospaceLabel(size: 8)
                        }
                    }
                    .padding(8).frame(maxWidth:.infinity, alignment:.leading)
                    .background(Color.kraftLight.opacity(0.3))
                    .overlay(Rectangle().stroke(Color.inkBlack.opacity(0.08), lineWidth: 1))
                }
            }
        }
        .padding(12).background(Color.paperWhite)
        .overlay(Rectangle().stroke(Color.inkBlack.opacity(0.1), lineWidth: 1))
        .shadow(color: .inkBlack.opacity(0.04), radius: 0, x: 2, y: 2)
    }
}

// MARK: - ReminderView
struct ReminderView: View {
    @EnvironmentObject var store: PlantStore
    var body: some View {
        ZStack {
            KraftBackground()
            ScrollView {
                VStack(spacing: 14) {
                    HeadlineBanner(title: "REMINDERS", subtitle: "CARE SCHEDULE").padding(.horizontal, 12).padding(.top, 8)
                    ForEach(store.plants) { plant in
                        VStack(alignment:.leading, spacing: 8) {
                            HStack {
                                Text(plant.emoji).font(.system(size: 24))
                                    .frame(width: 40, height: 40)
                                    .background(Color.kraftLight)
                                    .overlay(Rectangle().stroke(Color.inkBlack, lineWidth: 1.5))
                                VStack(alignment:.leading) {
                                    Text(plant.name).font(.system(size: 15, weight: .black)).foregroundColor(.inkBlack)
                                    Text(plant.sciName).monospaceLabel(size: 8).italic()
                                }
                                Spacer()
                            }
                            reminderRow(plant: plant, type: .water, icon: "💧", freq: "每\(plant.waterInterval)浇一次")
                            reminderRow(plant: plant, type: .fertilize, icon: "🧪", freq: "每30天施一次肥")
                            reminderRow(plant: plant, type: .pesticide, icon: "💊", freq: "每60天检查虫害")
                        }
                        .padding(12).background(Color.paperWhite)
                        .overlay(Rectangle().stroke(Color.inkBlack.opacity(0.1), lineWidth: 1))
                        .shadow(color: .inkBlack.opacity(0.06), radius: 0, x: 2, y: 2)
                        .padding(.horizontal, 12)
                    }
                }.padding(.bottom, 100)
            }
        }
        .navigationBarHidden(true)
    }
    func reminderRow(plant: Plant, type: EventType, icon: String, freq: String) -> some View {
        HStack(spacing: 10) {
            Text(icon).font(.system(size: 18))
                .frame(width: 36, height: 36)
                .background(Color.kraftLight)
                .overlay(Rectangle().stroke(Color.inkBlack, lineWidth: 1.5))
            VStack(alignment:.leading, spacing: 1) {
                Text("\(type.rawValue) \(plant.name)").font(.system(size: 12, weight: .bold)).foregroundColor(.inkBlack)
                Text(freq).monospaceLabel(size: 8)
            }
            Spacer()
            Button("DONE") {}.monospaceLabel(size: 8, color: .paperWhite)
                .padding(.horizontal, 12).padding(.vertical, 6)
                .background(Color.inkBlack)
                .overlay(Rectangle().stroke(Color.inkBlack, lineWidth: 1))
        }
        .padding(8).background(Color.kraftLight.opacity(0.2))
        .overlay(Rectangle().stroke(Color.inkBlack.opacity(0.06), lineWidth: 1))
    }
}

// MARK: - ProfileView
struct ProfileView: View {
    @EnvironmentObject var store: PlantStore
    var body: some View {
        ZStack {
            KraftBackground()
            ScrollView {
                VStack(spacing: 14) {
                    HeadlineBanner(title: "MY PROFILE", subtitle: "TOOLS & KNOWLEDGE").padding(.horizontal, 12).padding(.top, 8)
                    sectionView("TOOLS", items: [
                        ("sparkles", "植物纪念碑", AnyView(MemorialView())),
                        ("receipt", "本月账单", AnyView(ReceiptView())),
                        ("square.grid.3x3", "花架摆放", AnyView(ShelfView())),
                        ("camera.macro", "植物标本馆", AnyView(HerbariumView())),
                    ])
                    sectionView("KNOWLEDGE", items: [
                        ("book.pages", "品种图鉴", AnyView(SpeciesGuideView())),
                        ("camera.fill", "成长拍立得", AnyView(GrowthPolaroidView())),
                        ("stethoscope", "病虫害图鉴", AnyView(PestGuideView())),
                    ])
                    sectionView("MANAGE", items: [
                        ("testtube.2", "肥料药品管理", AnyView(SupplyManagerView())),
                        ("heart", "心愿清单", AnyView(WishlistView())),
                    ])
                }.padding(.bottom, 100)
            }
        }
        .navigationBarHidden(true)
    }
    func sectionView(_ title: String, items: [(String, String, AnyView)]) -> some View {
        VStack(alignment:.leading, spacing: 0) {
            Text(title).monospaceLabel(size: 10, color: .accentRed).padding(.horizontal, 16).padding(.bottom, 8)
            VStack(spacing: 0) {
                ForEach(0..<items.count, id:\.self) { i in
                    NavigationLink(destination: items[i].2) {
                        HStack {
                            Image(systemName: items[i].0).font(.system(size: 16)).foregroundColor(.inkBlack)
                                .frame(width: 32)
                            Text(items[i].1).font(.system(size: 14, weight: .bold, design: .monospaced)).foregroundColor(.inkBlack)
                            Spacer()
                            Image(systemName: "chevron.right").font(.system(size: 10, weight: .bold)).foregroundColor(.inkDim)
                        }
                        .padding(.horizontal, 16).padding(.vertical, 12)
                    }
                    if i < items.count - 1 {
                        Divider().background(Color.inkBlack.opacity(0.08)).padding(.leading, 48)
                    }
                }
            }
            .background(Color.paperWhite)
            .overlay(Rectangle().stroke(Color.inkBlack, lineWidth: 1.5))
            .shadow(color: .kraftDark, radius: 0, x: 3, y: 3)
        }.padding(.horizontal, 12)
    }
}

// MARK: - MemorialView, ReceiptView, ShelfView
struct MemorialView: View {
    @EnvironmentObject var store: PlantStore
    var body: some View {
        ZStack {
            KraftBackground()
            ScrollView {
                VStack(spacing: 14) {
                    HeadlineBanner(title: "MEMORIAL", subtitle: "\(store.memorials.count) PLANTS REMEMBERED")
                        .padding(.horizontal, 12).padding(.top, 8)
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                        ForEach(store.memorials) { m in
                            VStack(spacing: 8) {
                                Text(m.emoji).font(.system(size: 36))
                                Text(m.name).font(.system(size: 14, weight: .black, design: .monospaced)).foregroundColor(.inkBlack)
                                Text("\(m.adoptedDate) → \(m.partedDate)").monospaceLabel(size: 7)
                                Text(m.cause).font(.system(size: 10)).foregroundColor(.accentRed).multilineTextAlignment(.center)
                            }
                            .padding(12).frame(maxWidth:.infinity)
                            .background(Color.kraftLight.opacity(0.5))
                            .overlay(Rectangle().stroke(Color.inkBlack.opacity(0.12), lineWidth: 1))
                            .opacity(0.85)
                        }
                    }.padding(.horizontal, 12)
                }.padding(.bottom, 100)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement:.principal) {
                Text("植物纪念碑").font(.system(size: 16, weight: .black, design: .monospaced)).foregroundColor(.inkBlack)
            }
        }
    }
}

struct ReceiptView: View {
    @State private var period = 0
    var body: some View {
        ZStack {
            KraftBackground()
            VStack(spacing: 16) {
                Picker("周期", selection: $period) {
                    Text("当日").tag(0); Text("月度").tag(1); Text("年度").tag(2)
                }.pickerStyle(.segmented).padding(.horizontal)
                VStack(spacing: 4) {
                    Text("PLANT SHOP").font(.system(size: 16, weight: .black, design: .monospaced)).foregroundColor(.inkBlack).kerning(2)
                    Text("订单号: #2026-07-0001").monospaceLabel(size: 8).padding(.bottom, 8)
                    Rectangle().frame(height: 2).foregroundStyle(Color.inkBlack.opacity(0.15)).padding(.horizontal, 8)
                    rrow("🌿 龟背竹", "1", "¥68"); rrow("🪴 琴叶榕", "1", "¥120"); rrow("🧪 缓释肥", "2", "¥36")
                    Rectangle().frame(height: 2).foregroundColor(.inkDim).opacity(0.5).padding(.horizontal, 8)
                    HStack { Text("合计").font(.system(size: 14, weight: .black)).foregroundColor(.inkBlack); Spacer(); Text("¥224").font(.system(size: 14, weight: .black, design: .monospaced)).foregroundColor(.inkBlack) }
                    .padding(.horizontal, 8).padding(.top, 4)
                    // 条形码
                    HStack(spacing: 1) {
                        ForEach(0..<40, id:\.self) { i in
                            Rectangle().fill(Color.inkBlack)
                                .frame(width: CGFloat([1,2,3,1,2,1,1,2,1,3,2,1,1,2,3,1,2,1,1,2,1,3,2,1,1,2,3,1,1,2,1,2,3,1,1,2,1,3,1,2][i]), height: 24)
                        }
                    }.padding(.top, 8).padding(.horizontal, 8)
                }
                .padding(16).background(Color.paperWhite)
                .overlay(Rectangle().stroke(Color.inkBlack, lineWidth: 1.5))
                .shadow(color: .kraftDark, radius: 0, x: 3, y: 3)
                .padding(.horizontal)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement:.principal) {
                Text("本月账单").font(.system(size: 16, weight: .black, design: .monospaced)).foregroundColor(.inkBlack)
            }
        }
    }
    func rrow(_ name: String, _ qty: String, _ price: String) -> some View {
        HStack {
            Text(name).font(.system(size: 11)).foregroundColor(.inkDim)
            Spacer()
            Text("x\(qty)").font(.system(size: 11, design: .monospaced)).foregroundColor(.inkDim)
            Text(price).font(.system(size: 11, design: .monospaced)).foregroundColor(.inkBlack).frame(width: 50, alignment:.trailing)
        }.padding(.horizontal, 8).padding(.vertical, 2)
    }
}

struct ShelfView: View {
    @EnvironmentObject var store: PlantStore
    @State private var layoutIndex = 0
    var body: some View {
        ZStack {
            KraftBackground()
            VStack {
                Picker("花架", selection: $layoutIndex) {
                    Text("三层架").tag(0); Text("网格架").tag(1); Text("阶梯架").tag(2)
                }.pickerStyle(.segmented).padding()
                ScrollView {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                        ForEach(store.plants) { plant in
                            VStack(spacing: 4) {
                                Text(plant.emoji).font(.system(size: 32))
                                Text(plant.name).monospaceLabel(size: 7, color: .inkBlack)
                            }
                            .frame(height: 72).frame(maxWidth:.infinity)
                            .background(Color.kraftLight.opacity(0.4))
                            .overlay(Rectangle().stroke(Color.inkBlack.opacity(0.12), lineWidth: 1))
                        }
                    }.padding()
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement:.principal) {
                Text("花架摆放").font(.system(size: 16, weight: .black, design: .monospaced)).foregroundColor(.inkBlack)
            }
        }
    }
}

// MARK: - HerbariumView, SpeciesGuideView
struct HerbariumView: View {
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var specimenImage: UIImage?
    @State private var specimens: [Specimen] = []
    @State private var showPicker = false
    struct Specimen: Identifiable { let id=UUID(); let image: UIImage; let date: Date }

    var body: some View {
        ZStack {
            KraftBackground()
            ScrollView {
                VStack(spacing: 14) {
                    HeadlineBanner(title: "HERBARIUM", subtitle: "PLANT SPECIMEN COLLECTION").padding(.horizontal, 12).padding(.top, 8)
                    Button { showPicker = true } label: {
                        if let image = specimenImage {
                            ZStack(alignment:.topTrailing) {
                                Image(uiImage: image).resizable().scaledToFit()
                                    .overlay(Rectangle().stroke(Color.inkBlack, lineWidth: 2))
                                Button { specimenImage = nil } label: {
                                    Image(systemName: "xmark.circle.fill").font(.title2).foregroundColor(.accentRed)
                                }.padding(6)
                            }
                        } else {
                            VStack(spacing: 8) {
                                Image(systemName: "camera.viewfinder").font(.system(size: 40)).foregroundColor(.inkDim)
                                Text("拍照或选择照片制作标本").monospaceLabel(size: 9).foregroundColor(.inkDim)
                            }
                            .frame(height: 180).frame(maxWidth:.infinity)
                            .background(Color.paperWhite)
                            .overlay(Rectangle().stroke(style: StrokeStyle(lineWidth: 2, dash: [6, 4])).foregroundColor(.inkBlack.opacity(0.2)))
                        }
                    }.buttonStyle(.plain).padding(.horizontal, 12)
                    if specimenImage != nil {
                        Button {
                            if let img = specimenImage { specimens.append(Specimen(image: img, date: Date())); specimenImage = nil }
                        } label: {
                            Text("SAVE SPECIMEN").font(.system(size: 12, weight: .black, design: .monospaced))
                                .foregroundColor(.paperWhite).kerning(2)
                                .padding(.horizontal, 24).padding(.vertical, 10)
                                .background(Color.inkBlack)
                                .overlay(Rectangle().stroke(Color.inkBlack, lineWidth: 2))
                                .shadow(color: .accentRed, radius: 0, x: 3, y: 3)
                        }
                    }
                    if !specimens.isEmpty {
                        Text("COLLECTION (\(specimens.count))").monospaceLabel(size: 10, color: .inkBlack).padding(.horizontal, 16).frame(maxWidth:.infinity, alignment:.leading)
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 8) {
                            ForEach(specimens) { spec in
                                VStack(spacing: 4) {
                                    Image(uiImage: spec.image).resizable().scaledToFill()
                                        .frame(height: 110).clipped()
                                    Text(spec.date, style:.date).monospaceLabel(size: 7)
                                }
                                .overlay(Rectangle().stroke(Color.inkBlack.opacity(0.1), lineWidth: 1))
                            }
                        }.padding(.horizontal, 12)
                    }
                }.padding(.bottom, 100)
            }
        }
        .photosPicker(isPresented: $showPicker, selection: $selectedPhoto, matching: .images)
        .onChange(of: selectedPhoto) { _, item in
            Task { if let d = try? await item?.loadTransferable(type: Data.self), let img = UIImage(data: d) { specimenImage = img } }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement:.principal) {
                Text("植物标本馆").font(.system(size: 16, weight: .black, design: .monospaced)).foregroundColor(.inkBlack)
            }
        }
    }
}

struct SpeciesGuideView: View {
    @State private var selectedFamily = "全部"
    let speciesList: [PlantSpecies] = [
        PlantSpecies(emoji:"🌿",name:"龟背竹",sciName:"Monstera deliciosa",family:"天南星科",origin:"中美洲",waterInterval:"5-7天",light:"明亮散射光",leafType:"心形·深裂",desc:"叶片宽大呈心形，成熟后深裂成羽毛状，是热带雨林经典观叶植物。"),
        PlantSpecies(emoji:"🌺",name:"花烛红掌",sciName:"Anthurium andraeanum",family:"天南星科",origin:"哥伦比亚",waterInterval:"5-7天",light:"明亮散射光",leafType:"心形·蜡质",desc:"佛焰苞鲜红亮丽，形似爱心，花期长达2-3个月。"),
        PlantSpecies(emoji:"🪴",name:"琴叶榕",sciName:"Ficus lyrata",family:"桑科",origin:"西非",waterInterval:"7-10天",light:"明亮散射光",leafType:"提琴形·革质",desc:"叶片形似小提琴，革质厚实有光泽。"),
        PlantSpecies(emoji:"🦋",name:"蝴蝶兰",sciName:"Phalaenopsis aphrodite",family:"兰科",origin:"东南亚",waterInterval:"7-10天",light:"明亮散射光",leafType:"椭圆形·肉质",desc:"花姿优雅如蝴蝶翩翩，花期长达3-6个月。"),
        PlantSpecies(emoji:"🍂",name:"彩叶芋",sciName:"Caladium bicolor",family:"天南星科",origin:"南美",waterInterval:"5-7天",light:"明亮散射光",leafType:"心形·霓虹色斑",desc:"叶片色彩斑斓，红粉绿白交织如调色盘。"),
        PlantSpecies(emoji:"🦌",name:"鹿角蕨",sciName:"Platycerium bifurcatum",family:"鹿角蕨科",origin:"澳大利亚",waterInterval:"5-7天",light:"明亮散射光",leafType:"二型叶·鹿角形",desc:"孢子叶形似鹿角垂挂，热带雨林中的空中艺术品。"),
        PlantSpecies(emoji:"🌬️",name:"空气凤梨",sciName:"Tillandsia ionantha",family:"凤梨科",origin:"中南美洲",waterInterval:"2-3天",light:"明亮散射光",leafType:"银灰色·鳞片状",desc:"无需土壤，靠叶片鳞片吸收空气中水分和养分。"),
        PlantSpecies(emoji:"🌸",name:"秋海棠",sciName:"Begonia rex",family:"秋海棠科",origin:"亚洲热带",waterInterval:"5-7天",light:"明亮散射光",leafType:"不对称·金属光泽",desc:"叶片色彩斑斓，银灰、紫红、翠绿交织，带金属质感。"),
    ]
    var families: [String] { ["全部"] + Array(Set(speciesList.map{$0.family})).sorted() }
    var filtered: [PlantSpecies] { selectedFamily == "全部" ? speciesList : speciesList.filter{$0.family==selectedFamily} }

    var body: some View {
        ZStack {
            KraftBackground()
            ScrollView {
                VStack(spacing: 14) {
                    HeadlineBanner(title: "SPECIES GUIDE", subtitle: "TROPICAL PLANT ENCYCLOPEDIA").padding(.horizontal, 12).padding(.top, 8)
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(families, id:\.self) { f in
                                Button(f) { selectedFamily = f }
                                    .monospaceLabel(size: 8, color: selectedFamily == f ? .paperWhite : .inkBlack)
                                    .padding(.horizontal, 10).padding(.vertical, 5)
                                    .background(selectedFamily == f ? Color.accentRed : Color.paperWhite)
                                    .overlay(Rectangle().stroke(selectedFamily == f ? Color.accentRed : Color.inkBlack, lineWidth: 1))
                            }
                        }.padding(.horizontal, 12)
                    }
                    VStack(spacing: 10) {
                        ForEach(filtered) { sp in
                            DisclosureGroup {
                                VStack(alignment:.leading, spacing: 6) {
                                    Text("光照: \(sp.light)").font(.system(size: 11)).foregroundColor(.inkDim)
                                    Text("浇水: \(sp.waterInterval)").font(.system(size: 11)).foregroundColor(.inkDim)
                                    Text("原产地: \(sp.origin)").font(.system(size: 11)).foregroundColor(.inkDim)
                                    Text("叶片: \(sp.leafType)").font(.system(size: 11)).foregroundColor(.inkDim)
                                    Text(sp.desc).font(.system(size: 11)).foregroundColor(.inkDim).padding(.top, 2)
                                }.padding(.top, 4)
                            } label: {
                                HStack(spacing: 10) {
                                    Text(sp.emoji).font(.title2)
                                    VStack(alignment:.leading, spacing: 2) {
                                        Text(sp.name).font(.system(size: 14, weight: .black)).foregroundColor(.inkBlack)
                                        Text(sp.sciName).monospaceLabel(size: 8).italic()
                                    }
                                }
                            }
                            .padding(12).background(Color.paperWhite)
                            .overlay(Rectangle().stroke(Color.inkBlack.opacity(0.1), lineWidth: 1))
                            .shadow(color: .inkBlack.opacity(0.04), radius: 0, x: 2, y: 2)
                        }
                    }.padding(.horizontal, 12)
                }.padding(.bottom, 100)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement:.principal) {
                Text("品种图鉴").font(.system(size: 16, weight: .black, design: .monospaced)).foregroundColor(.inkBlack)
            }
        }
    }
}

// MARK: - GrowthPolaroidView, PestGuideView
struct GrowthPolaroidView: View {
    @EnvironmentObject var store: PlantStore
    @State private var selectedPlant: Plant?
    @State private var showCollage = false
    let growthData: [String: [(date: String, color: Color, note: String)]] = [
        "龟背竹": [("6月1日", Color.oliveGreen.opacity(0.35), "新入盆"), ("6月15日", Color.oliveGreen.opacity(0.5), "新叶萌发"), ("7月1日", Color.oliveGreen.opacity(0.65), "叶片深裂")],
        "花烛红掌": [("6月3日", Color.accentRed.opacity(0.3), "新入盆"), ("6月17日", Color.accentRed.opacity(0.45), "花色显现"), ("7月1日", Color.accentRed.opacity(0.6), "盛花期")],
        "琴叶榕": [("6月5日", Color.tealWater.opacity(0.3), "新购入"), ("6月19日", Color.tealWater.opacity(0.45), "新叶伸展"), ("7月3日", Color.tealWater.opacity(0.6), "革质光泽")],
    ]

    var body: some View {
        ZStack {
            KraftBackground()
            ScrollView {
                VStack(spacing: 14) {
                    HeadlineBanner(title: "POLAROID", subtitle: "GROWTH COLLAGE").padding(.horizontal, 12).padding(.top, 8)
                    // 拍立得相机 黑色机身
                    VStack(spacing: 10) {
                        Text("POLAROID GROWTH").monospaceLabel(size: 8, color: .paperWhite)
                        Picker("选择植物", selection: $selectedPlant) {
                            Text("-- 选择植物 --").tag(nil as Plant?)
                            ForEach(store.plants) { p in Text("\(p.emoji) \(p.name)").tag(p as Plant?) }
                        }
                        .pickerStyle(.menu).padding(8)
                        .background(Color.paperWhite)
                        .overlay(Rectangle().stroke(Color.inkBlack, lineWidth: 1))
                        Button {
                            if selectedPlant != nil { showCollage = true }
                        } label: {
                            Circle().fill(Color.accentRed).frame(width: 44, height: 44)
                                .overlay(Circle().stroke(Color.inkBlack, lineWidth: 3))
                        }
                        Text("SHOOT").monospaceLabel(size: 7, color: .paperWhite)
                    }
                    .padding(16).frame(maxWidth:.infinity)
                    .background(LinearGradient(colors: [Color(red:58/255,green:58/255,blue:58/255), Color(red:26/255,green:26/255,blue:26/255)], startPoint:.top, endPoint:.bottom))
                    .overlay(Rectangle().stroke(Color.inkBlack, lineWidth: 3))
                    .overlay(alignment:.top) {
                        // 取景器
                        Rectangle().fill(Color(red:80/255,green:120/255,blue:80/255)).frame(width: 60, height: 16)
                            .overlay(Rectangle().stroke(Color.inkBlack, lineWidth: 1.5))
                            .offset(y: -8)
                    }
                    .padding(.horizontal, 12)
                    // 拍立得照片
                    if showCollage, let plant = selectedPlant {
                        collageView(plant)
                            .transition(.move(edge:.top).combined(with:.opacity))
                            .animation(.spring(duration:0.5), value: showCollage)
                    }
                }.padding(.bottom, 100)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement:.principal) {
                Text("成长拍立得").font(.system(size: 16, weight: .black, design: .monospaced)).foregroundColor(.inkBlack)
            }
        }
    }
    func collageView(_ plant: Plant) -> some View {
        let photos = growthData[plant.name] ?? []
        return VStack(spacing: 0) {
            ForEach(photos.indices, id:\.self) { i in
                let p = photos[i]
                ZStack(alignment:.bottomLeading) {
                    p.color.frame(height: 72)
                    Text("\(p.date) · \(p.note)").monospaceLabel(size: 7, color: .paperWhite)
                        .padding(4).background(Color.inkBlack.opacity(0.5)).padding(4)
                }
            }
            Text(plant.name).font(.system(size: 12, weight: .bold, design: .monospaced)).foregroundColor(.inkDim).padding(.vertical, 8)
        }
        .padding(12).background(Color.white)
        .overlay(Rectangle().stroke(Color.inkBlack.opacity(0.08), lineWidth: 1))
        .shadow(color: .inkBlack.opacity(0.1), radius: 4, y: 3)
        .padding(.horizontal, 20)
    }
}

struct PestGuideView: View {
    @State private var filter: PestType?
    let pests: [PestEntry] = [
        PestEntry(icon:"🔴",name:"炭疽病",type:.disease,severity:"★★★★",plants:"天南星科·桑科",symptoms:"叶片出现圆形褐色斑点，边缘深褐色，中心灰白色。",treatment:"1. 剪除病叶\n2. 百菌清800倍液，每7天一次\n3. 保持通风干燥",prevention:"保持通风，避免叶片积水。春秋季每月喷多菌灵预防。"),
        PestEntry(icon:"🟤",name:"根腐病",type:.disease,severity:"★★★★★",plants:"所有热带植物",symptoms:"植株基部发黑软化，根系腐烂发臭。",treatment:"1. 脱盆剪除烂根\n2. 高锰酸钾1000倍液浸泡15分钟\n3. 晾根2-3天换新土",prevention:"透气颗粒土，干透浇透。冬季控水。"),
        PestEntry(icon:"🕷️",name:"红蜘蛛",type:.pest,severity:"★★★",plants:"天南星科·桑科",symptoms:"叶片细小黄白斑点，叶背有红色虫体和细网。",treatment:"1. 清水冲洗叶片\n2. 阿维菌素1500倍液喷叶背\n3. 增加环境湿度",prevention:"保持湿度50%以上，每月检查叶片背面。"),
        PestEntry(icon:"🪲",name:"介壳虫",type:.pest,severity:"★★★★",plants:"天南星科·兰科",symptoms:"叶片和茎干出现白色棉絮状附着物，引发煤污病。",treatment:"1. 酒精点涂虫体\n2. 矿物油乳剂100倍液\n3. 噻虫嗪2000倍液灌根",prevention:"新植物仔细检查，定期清理枯叶。"),
        PestEntry(icon:"🟡",name:"叶斑病",type:.disease,severity:"★★★",plants:"天南星科·兰科",symptoms:"叶片出现水渍状黄褐色小斑，逐渐扩大成不规则斑块。",treatment:"1. 隔离病株剪除病叶\n2. 代森锰锌600倍液\n3. 增加光照减少浇水",prevention:"通风避免闷热潮湿，定期检查叶片背面。"),
        PestEntry(icon:"🐛",name:"蓟马",type:.pest,severity:"★★★",plants:"天南星科·秋海棠科",symptoms:"叶片银白色条纹，新叶扭曲变形。",treatment:"1. 悬挂蓝色粘虫板\n2. 吡虫啉2000倍液\n3. 剪除受害部位",prevention:"定期检查嫩叶花苞，保持通风，避免过度密植。"),
    ]
    var filtered: [PestEntry] { filter.map{ f in pests.filter{$0.type==f} } ?? pests }

    var body: some View {
        ZStack {
            KraftBackground()
            ScrollView {
                VStack(spacing: 14) {
                    HeadlineBanner(title: "PEST GUIDE", subtitle: "IDENTIFY & TREAT").padding(.horizontal, 12).padding(.top, 8)
                    HStack(spacing: 8) {
                        Button("全部") { filter = nil }
                            .monospaceLabel(size: 8, color: filter == nil ? .paperWhite : .inkBlack)
                            .padding(.horizontal, 12).padding(.vertical, 6)
                            .background(filter == nil ? Color.accentRed : Color.paperWhite)
                            .overlay(Rectangle().stroke(filter == nil ? Color.accentRed : Color.inkBlack, lineWidth: 1))
                        ForEach(PestType.allCases, id:\.self) { t in
                            Button(t.rawValue) { filter = t }
                                .monospaceLabel(size: 8, color: filter == t ? .paperWhite : .inkBlack)
                                .padding(.horizontal, 12).padding(.vertical, 6)
                                .background(filter == t ? Color.accentRed : Color.paperWhite)
                                .overlay(Rectangle().stroke(filter == t ? Color.accentRed : Color.inkBlack, lineWidth: 1))
                        }
                    }.padding(.horizontal, 12)
                    VStack(spacing: 10) {
                        ForEach(filtered) { pest in
                            DisclosureGroup {
                                VStack(alignment:.leading, spacing: 6) {
                                    Text("症状：\(pest.symptoms)").font(.system(size: 11)).foregroundColor(.inkDim)
                                    Text("治疗：\(pest.treatment)").font(.system(size: 11, weight: .bold)).foregroundColor(.accentRed)
                                    Text("预防：\(pest.prevention)").font(.system(size: 11)).foregroundColor(.oliveGreen)
                                    Text("易感植物：\(pest.plants)").monospaceLabel(size: 7)
                                }.padding(.top, 4)
                            } label: {
                                HStack(spacing: 10) {
                                    Text(pest.icon).font(.title2)
                                    VStack(alignment:.leading, spacing: 2) {
                                        Text(pest.name).font(.system(size: 14, weight: .black, design: .monospaced)).foregroundColor(.inkBlack)
                                        Text("危害 \(pest.severity)").monospaceLabel(size: 7)
                                    }
                                }
                            }
                            .padding(12).background(Color.paperWhite)
                            .overlay(Rectangle().stroke(Color.inkBlack.opacity(0.1), lineWidth: 1))
                            .shadow(color: .inkBlack.opacity(0.04), radius: 0, x: 2, y: 2)
                        }
                    }.padding(.horizontal, 12)
                }.padding(.bottom, 100)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement:.principal) {
                Text("病虫害图鉴").font(.system(size: 16, weight: .black, design: .monospaced)).foregroundColor(.inkBlack)
            }
        }
    }
}

// MARK: - SupplyManagerView, WishlistView
struct SupplyManagerView: View {
    @EnvironmentObject var store: PlantStore
    @State private var filter: SupplyType?
    @State private var newName = ""
    @State private var newType: SupplyType = .fertilizer
    @State private var newDate = ""
    @State private var newNote = ""
    var filtered: [Supply] { filter.map{ f in store.supplies.filter{$0.type==f} } ?? store.supplies }

    var body: some View {
        ZStack {
            KraftBackground()
            ScrollView {
                VStack(spacing: 14) {
                    HeadlineBanner(title: "SUPPLIES", subtitle: "FERTILIZER & PESTICIDE LOG").padding(.horizontal, 12).padding(.top, 8)
                    // 添加表单
                    VStack(spacing: 8) {
                        HStack {
                            TextField("名称", text: $newName).font(.system(size: 13)).padding(10)
                                .background(Color.paperWhite).overlay(Rectangle().stroke(Color.inkBlack.opacity(0.1), lineWidth: 1))
                            Picker("类型", selection: $newType) {
                                ForEach(SupplyType.allCases, id:\.self) { t in Text(t.rawValue).tag(t) }
                            }
                        }
                        HStack {
                            TextField("购买日期", text: $newDate).font(.system(size: 13)).padding(10)
                                .background(Color.paperWhite).overlay(Rectangle().stroke(Color.inkBlack.opacity(0.1), lineWidth: 1))
                            TextField("备注", text: $newNote).font(.system(size: 13)).padding(10)
                                .background(Color.paperWhite).overlay(Rectangle().stroke(Color.inkBlack.opacity(0.1), lineWidth: 1))
                        }
                        Button {
                            guard !newName.isEmpty else { return }
                            store.addSupply(Supply(name: newName, type: newType, date: newDate.isEmpty ? "未知" : newDate, note: newNote))
                            newName = ""; newDate = ""; newNote = ""
                        } label: {
                            Text("ADD RECORD").font(.system(size: 12, weight: .black, design: .monospaced))
                                .foregroundColor(.paperWhite).kerning(2)
                                .frame(maxWidth:.infinity).padding(.vertical, 10)
                                .background(Color.inkBlack)
                                .overlay(Rectangle().stroke(Color.inkBlack, lineWidth: 2))
                                .shadow(color: .accentRed, radius: 0, x: 3, y: 3)
                        }.disabled(newName.isEmpty)
                    }
                    .padding(12).background(Color.paperWhite)
                    .overlay(Rectangle().stroke(Color.inkBlack, lineWidth: 1.5))
                    .shadow(color: .kraftDark, radius: 0, x: 3, y: 3)
                    .padding(.horizontal, 12)
                    // 筛选
                    HStack(spacing: 8) {
                        Button("全部 (\(store.supplies.count))") { filter = nil }
                            .monospaceLabel(size: 8, color: filter == nil ? .paperWhite : .inkBlack)
                            .padding(.horizontal, 10).padding(.vertical, 5)
                            .background(filter == nil ? Color.accentRed : Color.paperWhite)
                            .overlay(Rectangle().stroke(filter == nil ? Color.accentRed : Color.inkBlack, lineWidth: 1))
                        ForEach(SupplyType.allCases, id:\.self) { t in
                            Button("\(t.rawValue) (\(store.supplies.filter{$0.type==t}.count))") { filter = t }
                                .monospaceLabel(size: 8, color: filter == t ? .paperWhite : .inkBlack)
                                .padding(.horizontal, 10).padding(.vertical, 5)
                                .background(filter == t ? Color.accentRed : Color.paperWhite)
                                .overlay(Rectangle().stroke(filter == t ? Color.accentRed : Color.inkBlack, lineWidth: 1))
                        }
                    }.padding(.horizontal, 12)
                    // 列表
                    VStack(spacing: 6) {
                        ForEach(filtered) { item in
                            HStack(spacing: 10) {
                                Text(item.type.icon).font(.system(size: 20))
                                    .frame(width: 36, height: 36)
                                    .background(Color.kraftLight)
                                    .overlay(Rectangle().stroke(Color.inkBlack, lineWidth: 1.5))
                                VStack(alignment:.leading, spacing: 1) {
                                    Text(item.name).font(.system(size: 13, weight: .bold)).foregroundColor(.inkBlack)
                                    Text("\(item.date) · \(item.note)").monospaceLabel(size: 7)
                                }
                                Spacer()
                                Text(item.type.rawValue).monospaceLabel(size: 7, color: .oliveGreen)
                                    .padding(.horizontal, 6).padding(.vertical, 2)
                                    .overlay(Rectangle().stroke(Color.oliveGreen, lineWidth: 1))
                                Button { store.deleteSupply(item) } label: {
                                    Image(systemName: "trash").font(.system(size: 12)).foregroundColor(.accentRed)
                                }
                            }
                            .padding(10).background(Color.paperWhite)
                            .overlay(Rectangle().stroke(Color.inkBlack.opacity(0.08), lineWidth: 1))
                        }
                    }.padding(.horizontal, 12)
                }.padding(.bottom, 100)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement:.principal) {
                Text("肥料药品管理").font(.system(size: 16, weight: .black, design: .monospaced)).foregroundColor(.inkBlack)
            }
        }
    }
}

struct WishlistView: View {
    @EnvironmentObject var store: PlantStore
    @State private var newName = ""
    @State private var newPhoto: UIImage?
    @State private var showPhotoPicker = false
    @State private var photoItem: PhotosPickerItem?

    var body: some View {
        ZStack {
            KraftBackground()
            ScrollView {
                VStack(spacing: 14) {
                    HeadlineBanner(title: "WISHLIST", subtitle: "DREAM PLANTS").padding(.horizontal, 12).padding(.top, 8)
                    // 添加
                    VStack(spacing: 8) {
                        HStack(spacing: 8) {
                            TextField("植物名称", text: $newName).font(.system(size: 13)).padding(10)
                                .background(Color.paperWhite).overlay(Rectangle().stroke(Color.inkBlack.opacity(0.1), lineWidth: 1))
                            Button { showPhotoPicker = true } label: {
                                Image(systemName: newPhoto == nil ? "photo.badge.plus" : "photo.fill")
                                    .font(.system(size: 18)).foregroundColor(newPhoto == nil ? .inkDim : .accentRed)
                                    .frame(width: 40, height: 40)
                                    .background(Color.paperWhite)
                                    .overlay(Rectangle().stroke(Color.inkBlack, lineWidth: 1))
                            }
                        }
                        Button {
                            guard !newName.isEmpty else { return }
                            var wish = WishItem(name: newName)
                            if let img = newPhoto { wish.photoData = img.jpegData(compressionQuality: 0.7) }
                            store.addWish(wish); newName = ""; newPhoto = nil
                        } label: {
                            Text("ADD TO WISHLIST").font(.system(size: 12, weight: .black, design: .monospaced))
                                .foregroundColor(.paperWhite).kerning(2)
                                .frame(maxWidth:.infinity).padding(.vertical, 10)
                                .background(Color.inkBlack)
                                .overlay(Rectangle().stroke(Color.inkBlack, lineWidth: 2))
                                .shadow(color: .accentRed, radius: 0, x: 3, y: 3)
                        }.disabled(newName.isEmpty)
                    }
                    .padding(12).background(Color.paperWhite)
                    .overlay(Rectangle().stroke(Color.inkBlack, lineWidth: 1.5))
                    .shadow(color: .kraftDark, radius: 0, x: 3, y: 3)
                    .padding(.horizontal, 12)
                    // 心愿列表
                    if !store.wishes.isEmpty {
                        Text("MY WISHLIST (\(store.wishes.count))").monospaceLabel(size: 10, color: .inkBlack).padding(.horizontal, 16).frame(maxWidth:.infinity, alignment:.leading)
                        VStack(spacing: 6) {
                            ForEach(store.wishes) { wish in
                                HStack(spacing: 10) {
                                    if let data = wish.photoData, let uiImage = UIImage(data: data) {
                                        Image(uiImage: uiImage).resizable().scaledToFill()
                                            .frame(width: 44, height: 44).clipped()
                                            .overlay(Rectangle().stroke(Color.inkBlack, lineWidth: 2))
                                    } else {
                                        Rectangle().fill(Color.kraftLight)
                                            .frame(width: 44, height: 44)
                                            .overlay(Image(systemName: "photo").foregroundColor(.inkDim))
                                            .overlay(Rectangle().stroke(Color.inkBlack, lineWidth: 1))
                                    }
                                    Text(wish.name).font(.system(size: 13, weight: .bold, design: .monospaced))
                                        .foregroundColor(wish.owned ? .inkDim : .inkBlack)
                                        .strikethrough(wish.owned)
                                    Spacer()
                                    Button { store.toggleWishOwned(wish) } label: {
                                        Image(systemName: wish.owned ? "checkmark" : "circle")
                                            .font(.system(size: 16, weight: .bold))
                                            .foregroundColor(wish.owned ? .oliveGreen : .inkDim)
                                    }
                                    Button { store.deleteWish(wish) } label: {
                                        Image(systemName: "xmark").font(.system(size: 12, weight: .bold)).foregroundColor(.accentRed)
                                    }
                                }
                                .padding(10).background(Color.paperWhite)
                                .overlay(Rectangle().stroke(Color.inkBlack.opacity(0.08), lineWidth: 1))
                            }
                        }.padding(.horizontal, 12)
                    }
                }.padding(.bottom, 100)
            }
        }
        .photosPicker(isPresented: $showPhotoPicker, selection: $photoItem, matching: .images)
        .onChange(of: photoItem) { _, item in
            Task { if let d = try? await item?.loadTransferable(type: Data.self), let img = UIImage(data: d) { newPhoto = img } }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement:.principal) {
                Text("心愿清单").font(.system(size: 16, weight: .black, design: .monospaced)).foregroundColor(.inkBlack)
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
            ContentView().environmentObject(store)
        }
    }
}