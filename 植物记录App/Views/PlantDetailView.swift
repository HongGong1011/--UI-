import SwiftUI

struct PlantDetailView: View {
    let plant: Plant
    @EnvironmentObject var store: PlantStore

    var plantEvents: [CareEvent] {
        store.events.filter { $0.plantName == plant.name }
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                // 身份证卡片
                idCard
                // 统计
                statsRow
                // 成长时间轴
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
            Text(value).font(.title3).bold().foregroundStyle(.green)
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