import SwiftUI
import Foundation

class PlantStore: ObservableObject {
    // MARK: - 植物
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