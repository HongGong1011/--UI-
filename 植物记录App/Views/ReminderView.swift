import SwiftUI

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