import SwiftUI
import PhotosUI

// MARK: - MemorialView, ReceiptView, ShelfView
struct MemorialView: View {
    @EnvironmentObject var store: PlantStore
    var body: some View {
        ZStack {
            KraftBackground()
            ScrollView {
                VStack(spacing: 14) {
                    HeadlineBanner(title: "纪念碑", subtitle: "\(store.memorials.count) 已纪念")
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
                    Text("植物商店").font(.system(size: 16, weight: .black, design: .monospaced)).foregroundColor(.inkBlack).kerning(2)
                    Text("订单号: #2026-07-0001").monospaceLabel(size: 8).padding(.bottom, 8)
                    Rectangle().frame(height: 2).foregroundStyle(Color.inkBlack.opacity(0.15)).padding(.horizontal, 8)
                    rrow("🌿 龟背竹", "1", "¥68"); rrow("🪴 琴叶榕", "1", "¥120"); rrow("🧪 缓释肥", "2", "¥36")
                    Rectangle().frame(height: 2).foregroundColor(.inkDim).opacity(0.5).padding(.horizontal, 8)
                    HStack { Text("合计").font(.system(size: 14, weight: .black)).foregroundColor(.inkBlack); Spacer(); Text("¥224").font(.system(size: 14, weight: .black, design: .monospaced)).foregroundColor(.inkBlack) }
                    .padding(.horizontal, 8).padding(.top, 4)
                    barcodeView(widths: [1,2,3,1,2,1,1,2,1,3,2,1,1,2,3,1,2,1,1,2,1,3,2,1,1,2,3,1,1,2,1,2,3,1,1,2,1,3,1,2], height: 24).padding(.top, 8).padding(.horizontal, 8)
                }
                .padding(16).background(Color.paperWhite)
                .overlay(Rectangle().stroke(Color.inkBlack, lineWidth: 1.5))
                .shadow(color: .black.opacity(0.08), radius: 2, y: 1)
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
    func barcodeView(widths: [CGFloat], height: CGFloat) -> some View {
        HStack(spacing: 1) {
            ForEach(widths.indices, id: \.self) { i in
                Rectangle().fill(Color.inkBlack).frame(width: widths[i], height: height)
            }
        }
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
                    HeadlineBanner(title: "植物标本馆", subtitle: "植物标本收藏").padding(.horizontal, 12).padding(.top, 8)
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
                            Text("保存标本").font(.system(size: 12, weight: .black, design: .monospaced))
                                .foregroundColor(.paperWhite).kerning(2)
                                .padding(.horizontal, 24).padding(.vertical, 10)
                                .background(Color.inkBlack)
                                .overlay(Rectangle().stroke(Color.inkBlack, lineWidth: 2))
                                .shadow(color: .black.opacity(0.08), radius: 2, y: 1)
                        }
                    }
                    if !specimens.isEmpty {
                        Text("收藏 (\(specimens.count))").monospaceLabel(size: 10, color: .inkBlack).padding(.horizontal, 16).frame(maxWidth:.infinity, alignment:.leading)
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
                    HeadlineBanner(title: "品种图鉴", subtitle: "热带植物百科").padding(.horizontal, 12).padding(.top, 8)
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
                            .shadow(color: .black.opacity(0.04), radius: 1, y: 1)
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
                    HeadlineBanner(title: "拍立得", subtitle: "成长拼图").padding(.horizontal, 12).padding(.top, 8)
                    VStack(spacing: 10) {
                        Text("拍立得成长").monospaceLabel(size: 8, color: .paperWhite)
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
                        Text("拍摄").monospaceLabel(size: 7, color: .paperWhite)
                    }
                    .padding(16).frame(maxWidth:.infinity)
                    .background(LinearGradient(colors: [Color(red:58/255,green:58/255,blue:58/255), Color(red:26/255,green:26/255,blue:26/255)], startPoint:.top, endPoint:.bottom))
                    .overlay(Rectangle().stroke(Color.inkBlack, lineWidth: 3))
                    .overlay(alignment:.top) {
                        Rectangle().fill(Color(red:80/255,green:120/255,blue:80/255)).frame(width: 60, height: 16)
                            .overlay(Rectangle().stroke(Color.inkBlack, lineWidth: 1.5))
                            .offset(y: -8)
                    }
                    .padding(.horizontal, 12)
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
        .shadow(color: .black.opacity(0.06), radius: 3, y: 1)
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
                    HeadlineBanner(title: "病虫害图鉴", subtitle: "识别与防治").padding(.horizontal, 12).padding(.top, 8)
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
                            .shadow(color: .black.opacity(0.04), radius: 1, y: 1)
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
                    HeadlineBanner(title: "物资管理", subtitle: "肥料药品记录").padding(.horizontal, 12).padding(.top, 8)
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
                            Text("添加记录").font(.system(size: 12, weight: .black, design: .monospaced))
                                .foregroundColor(.paperWhite).kerning(2)
                                .frame(maxWidth:.infinity).padding(.vertical, 10)
                                .background(Color.inkBlack)
                                .overlay(Rectangle().stroke(Color.inkBlack, lineWidth: 2))
                                .shadow(color: .black.opacity(0.08), radius: 2, y: 1)
                        }.disabled(newName.isEmpty)
                    }
                    .padding(12).background(Color.paperWhite)
                    .overlay(Rectangle().stroke(Color.inkBlack, lineWidth: 1.5))
                    .shadow(color: .black.opacity(0.08), radius: 2, y: 1)
                    .padding(.horizontal, 12)
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
                    HeadlineBanner(title: "心愿清单", subtitle: "梦想植物").padding(.horizontal, 12).padding(.top, 8)
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
                            Text("加入心愿").font(.system(size: 12, weight: .black, design: .monospaced))
                                .foregroundColor(.paperWhite).kerning(2)
                                .frame(maxWidth:.infinity).padding(.vertical, 10)
                                .background(Color.inkBlack)
                                .overlay(Rectangle().stroke(Color.inkBlack, lineWidth: 2))
                                .shadow(color: .black.opacity(0.08), radius: 2, y: 1)
                        }.disabled(newName.isEmpty)
                    }
                    .padding(12).background(Color.paperWhite)
                    .overlay(Rectangle().stroke(Color.inkBlack, lineWidth: 1.5))
                    .shadow(color: .black.opacity(0.08), radius: 2, y: 1)
                    .padding(.horizontal, 12)
                    if !store.wishes.isEmpty {
                        Text("我的心愿 (\(store.wishes.count))").monospaceLabel(size: 10, color: .inkBlack).padding(.horizontal, 16).frame(maxWidth:.infinity, alignment:.leading)
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