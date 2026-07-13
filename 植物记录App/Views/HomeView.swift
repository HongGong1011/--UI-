import SwiftUI

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
                // 天气卡片
                weatherCard
                // 今日C位植物
                if let plant = store.plants.randomElement() {
                    featuredPlant(plant)
                }
                // 待办提醒
                pendingAlerts
                // 植物收藏
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
                .tint(.green)
        }
        .padding()
        .background(Color(.systemBackground), in: RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.06), radius: 4, y: 2)
    }
}