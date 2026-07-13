import SwiftUI

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