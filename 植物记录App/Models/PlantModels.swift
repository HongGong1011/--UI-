import SwiftUI
import Foundation

// MARK: - 植物模型
struct Plant: Identifiable, Codable {
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