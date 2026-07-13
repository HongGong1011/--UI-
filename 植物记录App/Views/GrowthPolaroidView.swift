import SwiftUI

struct GrowthPolaroidView: View {
    @EnvironmentObject var store: PlantStore
    @State private var selectedPlant: Plant?
    @State private var showCollage = false

    let growthData: [String: [(date: String, color: Color, note: String)]] = [
        "龟背竹": [("6月1日", .green.opacity(0.3), "新入盆"), ("6月15日", .green.opacity(0.45), "新叶萌发"), ("7月1日", .green.opacity(0.6), "叶片深裂")],
        "花烛红掌": [("6月3日", .pink.opacity(0.3), "新入盆"), ("6月17日", .pink.opacity(0.45), "花色显现"), ("7月1日", .pink.opacity(0.6), "盛花期")],
        "琴叶榕": [("6月5日", .mint.opacity(0.3), "新购入"), ("6月19日", .mint.opacity(0.45), "新叶伸展"), ("7月3日", .mint.opacity(0.6), "革质光泽")],
    ]

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                // 相机
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

                // 拍立得照片
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
                            Text("预防：\(pest.prevention)").font(.caption).foregroundStyle(.green)
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