import SwiftUI
import PhotosUI

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