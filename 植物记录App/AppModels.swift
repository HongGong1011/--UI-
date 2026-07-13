import SwiftUI
import Combine
import PhotosUI

// MARK: - 美式拼贴撕纸风 · 色彩系统
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

extension View {
    func monospaceLabel(size: CGFloat = 9, color: Color = .inkDim) -> some View {
        modifier(MonospaceLabel(size: size, color: color))
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
struct ShelfSlot: Codable { var plantIndex:Int?; var potIndex:Int? }
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
        let now = Date()
        let cal = Calendar.current
        plants = [
            Plant(name:"龟背竹",emoji:"🌿",sciName:"Monstera deliciosa",family:"天南星科",alias:"蓬莱蕉",origin:"中美洲",waterInterval:"5-7天",light:"明亮散射光",leafType:"心形·深裂",adoptedDate:cal.date(byAdding:.day,value:-128,to:now)!,status:"健康",growthValue:0.85,desc:"叶片宽大呈心形，成熟后深裂成羽毛状，是热带雨林经典观叶植物。"),
            Plant(name:"花烛红掌",emoji:"🌺",sciName:"Anthurium andraeanum",family:"天南星科",alias:"红掌",origin:"哥伦比亚",waterInterval:"5-7天",light:"明亮散射光",leafType:"心形·蜡质",adoptedDate:cal.date(byAdding:.day,value:-95,to:now)!,status:"健康",growthValue:0.72,desc:"佛焰苞鲜红亮丽，形似爱心，花期长达2-3个月。"),
            Plant(name:"琴叶榕",emoji:"🪴",sciName:"Ficus lyrata",family:"桑科",alias:"小提琴榕",origin:"西非",waterInterval:"7-10天",light:"明亮散射光",leafType:"提琴形·革质",adoptedDate:cal.date(byAdding:.day,value:-60,to:now)!,status:"健康",growthValue:0.6,desc:"叶片形似小提琴，革质厚实有光泽，北欧风标志性植物。"),
            Plant(name:"蝴蝶兰",emoji:"🦋",sciName:"Phalaenopsis aphrodite",family:"兰科",alias:"蝶兰",origin:"东南亚",waterInterval:"7-10天",light:"明亮散射光",leafType:"椭圆形·肉质",adoptedDate:cal.date(byAdding:.day,value:-45,to:now)!,status:"开花中",growthValue:0.9,desc:"花姿优雅如蝴蝶翩翩，花期长达3-6个月。"),
            Plant(name:"彩叶芋",emoji:"🍂",sciName:"Caladium bicolor",family:"天南星科",alias:"花叶芋",origin:"南美",waterInterval:"5-7天",light:"明亮散射光",leafType:"心形·霓虹色斑",adoptedDate:cal.date(byAdding:.day,value:-30,to:now)!,status:"健康",growthValue:0.55,desc:"叶片色彩斑斓，红粉绿白交织如调色盘。"),
            Plant(name:"鹿角蕨",emoji:"🦌",sciName:"Platycerium bifurcatum",family:"鹿角蕨科",alias:"蝙蝠蕨",origin:"澳大利亚",waterInterval:"5-7天",light:"明亮散射光",leafType:"二型叶·鹿角形",adoptedDate:cal.date(byAdding:.day,value:-25,to:now)!,status:"健康",growthValue:0.5,desc:"孢子叶形似鹿角垂挂，热带雨林中的空中艺术品。"),
            Plant(name:"空气凤梨",emoji:"🌬️",sciName:"Tillandsia ionantha",family:"凤梨科",alias:"空凤",origin:"中南美洲",waterInterval:"2-3天",light:"明亮散射光",leafType:"银灰色·鳞片状",adoptedDate:cal.date(byAdding:.day,value:-20,to:now)!,status:"健康",growthValue:0.4,desc:"无需土壤，靠叶片鳞片吸收空气中水分和养分。"),
            Plant(name:"秋海棠",emoji:"🌸",sciName:"Begonia rex",family:"秋海棠科",alias:"彩叶海棠",origin:"亚洲热带",waterInterval:"5-7天",light:"明亮散射光",leafType:"不对称·金属光泽",adoptedDate:cal.date(byAdding:.day,value:-15,to:now)!,status:"健康",growthValue:0.35,desc:"叶片色彩斑斓，银灰、紫红、翠绿交织，带金属质感。"),
        ]
        events = [
            CareEvent(type:.water,plantName:"龟背竹",note:"浇透水，盆底流出",date:Date()),
            CareEvent(type:.fertilize,plantName:"花烛红掌",note:"施缓释肥",date:cal.date(byAdding:.day,value:-3,to:now)!),
            CareEvent(type:.repot,plantName:"琴叶榕",note:"换大一号盆",date:cal.date(byAdding:.day,value:-5,to:now)!),
            CareEvent(type:.newPlant,plantName:"秋海棠",note:"新入盆·状态记录",date:cal.date(byAdding:.day,value:-15,to:now)!),
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