import SwiftUI
import PhotosUI

// MARK: - 全屏天气首屏
struct WeatherHero: View {
    let weatherIndex: Int
    let potPlant: Plant
    let geo: GeometryProxy
    @State private var sunPulse = false
    @State private var cloudOffset: CGFloat = 0
    @State private var rainPhase: Double = 0

    let weathers: [(icon: String, temp: String, desc: String, bgTop: Color, bgMid: Color, bgBot: Color, type: String)] = [
        ("☀️", "32°", "晴朗 · 适合晒太阳", Color(hex: "FEF5E0"), Color(hex: "F8E8C8"), Color(hex: "FDFAF4"), "sunny"),
        ("🌧️", "22°", "雨天 · 记得关窗", Color(hex: "A8B5C0"), Color(hex: "BCC5CD"), Color(hex: "E0DDD5"), "rainy"),
        ("☁️", "26°", "多云 · 温和舒适", Color(hex: "D8D5CC"), Color(hex: "E0DDD5"), Color(hex: "F4EDE0"), "cloudy"),
    ]

    var body: some View {
        let w = weathers[weatherIndex]
        ZStack {
            LinearGradient(colors: [w.bgTop, w.bgMid, w.bgBot], startPoint: .top, endPoint: .bottom)
            // 太阳
            if w.type == "sunny" {
                Circle()
                    .fill(RadialGradient(colors: [Color(hex: "FFE066"), Color(hex: "F5A623")], center: .center, startRadius: 0, endRadius: 24))
                    .frame(width: 48, height: 48)
                    .shadow(color: Color(hex: "F5A623").opacity(sunPulse ? 0.7 : 0.5), radius: sunPulse ? 50 : 30)
                    .shadow(color: Color(hex: "FFE066").opacity(sunPulse ? 0.5 : 0.3), radius: sunPulse ? 80 : 60)
                    .position(x: geo.size.width - 50, y: 40)
                    .onAppear {
                        withAnimation(.easeInOut(duration: 3).repeatForever(autoreverses: true)) { sunPulse = true }
                    }
            }
            // 云朵
            if w.type != "sunny" {
                CloudShape(dark: w.type == "rainy")
                    .frame(width: 80, height: 28)
                    .position(x: 56 + cloudOffset * 12, y: 36)
                CloudShape(dark: w.type == "rainy")
                    .frame(width: 60, height: 22)
                    .position(x: geo.size.width - 106 + cloudOffset * 8, y: 60)
            }
            // 雨滴
            if w.type == "rainy" {
                GeometryReader { g in
                    ForEach(0..<20, id: \.self) { i in
                        let x = CGFloat.random(in: 0...g.size.width)
                        let delay = Double.random(in: 0...2)
                        let duration = Double.random(in: 0.6...1.2)
                        RainDrop()
                            .position(x: x, y: g.size.height * sin(rainPhase * duration + delay))
                            .opacity(sin(rainPhase * duration + delay) > 0.1 ? 0.5 : 0)
                    }
                }
                .onAppear {
                    withAnimation(.linear(duration: 20).repeatForever(autoreverses: false)) { rainPhase = 100 }
                }
            }
            // 天气信息
            VStack(alignment: .leading, spacing: 0) {
                HStack(alignment: .top, spacing: 8) {
                    Text(w.icon).font(.system(size: 34))
                    VStack(alignment: .leading, spacing: 0) {
                        Text(w.temp)
                            .font(.system(size: 26, weight: .black, design: .monospaced))
                            .foregroundColor(.navyBlue)
                        Text(w.desc)
                            .font(.system(size: 10, design: .monospaced))
                            .foregroundColor(.inkDim)
                    }
                }
                .padding(.leading, 14).padding(.top, 12)
                Spacer()
            }
            // 花盆架
            VStack(spacing: 0) {
                Spacer()
                ZStack(alignment: .bottom) {
                    // 花盆
                    Text(potPlant.emoji).font(.system(size: 32))
                        .frame(width: 56, height: 56)
                        .background(
                            Ellipse()
                                .fill(LinearGradient(colors: [Color(hex: "D4A878"), Color(hex: "B8845C")], startPoint: .topLeading, endPoint: .bottomTrailing))
                        )
                        .clipShape(Capsule())
                        .overlay(
                            Capsule().stroke(Color(hex: "5A4020"), lineWidth: 1.5)
                        )
                        .shadow(color: .black.opacity(0.15), radius: 3, y: 2)
                        .offset(y: -6)
                    // 花盆上沿
                    RoundedRectangle(cornerRadius: 3)
                        .fill(Color(hex: "B8845C"))
                        .frame(width: 44, height: 8)
                        .overlay(RoundedRectangle(cornerRadius: 3).stroke(Color(hex: "5A4020"), lineWidth: 1))
                        .offset(y: -34)
                    // 架板
                    Rectangle().fill(Color(hex: "8B7355")).frame(width: 100, height: 8)
                        .overlay(Rectangle().stroke(Color(hex: "5A4020"), lineWidth: 1))
                    // 架腿
                    HStack(spacing: 0) {
                        Rectangle().fill(Color(hex: "6B5335")).frame(width: 3, height: 28)
                            .overlay(Rectangle().stroke(Color(hex: "4A3010"), lineWidth: 0.5))
                        Spacer().frame(width: 64)
                        Rectangle().fill(Color(hex: "6B5335")).frame(width: 3, height: 28)
                            .overlay(Rectangle().stroke(Color(hex: "4A3010"), lineWidth: 0.5))
                    }
                    .frame(width: 70)
                    .padding(.top, 8)
                }
                // 阴影
                Ellipse().fill(Color.black.opacity(0.1)).frame(width: 80, height: 6).padding(.top, 4).padding(.bottom, 8)
            }
            .frame(maxWidth: .infinity)
            // 植物名牌
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Text(potPlant.name)
                        .font(.system(size: 9, weight: .black, design: .monospaced))
                        .foregroundColor(.inkBlack)
                        .padding(.horizontal, 9).padding(.vertical, 3)
                        .background(Color.paperWhite)
                        .overlay(Rectangle().stroke(Color.inkBlack, lineWidth: 1))
                        .padding(.trailing, 12).padding(.bottom, 8)
                }
            }
        }
        .frame(height: max(460, geo.size.height * 0.55))
        .overlay(Rectangle().stroke(Color.inkBlack, lineWidth: 2))
        .clipped()
    }
}

struct CloudShape: View {
    let dark: Bool
    var body: some View {
        Rectangle()
            .fill(dark ? Color(hex: "969BA5").opacity(0.7) : Color.white.opacity(0.85))
            .clipShape(Capsule())
            .overlay(Capsule().stroke(Color.inkBlack.opacity(0.06), lineWidth: 1))
    }
}

struct RainDrop: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 1)
            .fill(Color(hex: "64788C").opacity(0.5))
            .frame(width: 2, height: 16)
    }
}

// MARK: - 颜色扩展
extension Color {
    init(hex: String) {
        let r, g, b: Double
        let start = hex.startIndex
        let rIdx = hex.index(start, offsetBy: 0)
        let gIdx = hex.index(start, offsetBy: 2)
        let bIdx = hex.index(start, offsetBy: 4)
        r = Double(Int(hex[rIdx..<gIdx], radix: 16)!) / 255
        g = Double(Int(hex[gIdx..<bIdx], radix: 16)!) / 255
        b = Double(Int(hex[bIdx...], radix: 16)!) / 255
        self.init(red: r, green: g, blue: b)
    }
}

// MARK: - 牛皮纸背景
struct KraftBackground: View {
    var body: some View {
        ZStack {
            Color.bgWarm
            RadialGradient(colors: [Color.kraft.opacity(0.35), .clear], center: .topLeading, startRadius: 0, endRadius: 400)
            RadialGradient(colors: [Color(red: 180/255, green: 160/255, blue: 130/255).opacity(0.25), .clear], center: .bottomTrailing, startRadius: 0, endRadius: 350)
        }.ignoresSafeArea()
    }
}

// MARK: - 报纸头条横幅
struct HeadlineBanner: View {
    let title: String; let subtitle: String
    var body: some View {
        VStack(spacing: 0) {
            Text("热带植物时报")
                .font(.system(size: 9, weight: .black, design: .monospaced))
                .foregroundColor(.accentRed)
                .padding(.horizontal, 8).padding(.vertical, 2)
                .background(Color.bgWarm)
                .overlay(Rectangle().stroke(Color.accentRed, lineWidth: 1))
                .offset(y: 6).zIndex(1)
            VStack(spacing: 6) {
                Text(title).font(.system(size: 17, weight: .black)).foregroundColor(.inkBlack)
                Rectangle().fill(Color.inkDim.opacity(0.4)).frame(height: 1)
                    .overlay(Rectangle().stroke(style: StrokeStyle(lineWidth: 1, dash: [4, 4])).foregroundColor(.inkDim.opacity(0.4)))
                Text(subtitle).font(.system(size: 12, design: .monospaced)).foregroundColor(.inkDim)
            }
            .frame(maxWidth: .infinity).padding(18)
            .background(Color.paperWhite)
            .overlay(Rectangle().stroke(Color.inkBlack, lineWidth: 3).padding(.horizontal, 0))
        }
    }
}

// MARK: - Section标签
struct SectionLabel: View {
    let title: String; let color: Color
    var body: some View {
        HStack(spacing: 10) {
            Text(title)
                .font(.system(size: 11, weight: .black, design: .monospaced))
                .foregroundColor(color)
            Rectangle()
                .fill(LinearGradient(
                    stops: stride(from: 0, through: 20, by: 2).map { .init(color: color.opacity(0.3), location: $0 / 20) },
                    startPoint: .leading, endPoint: .trailing
                ))
                .frame(height: 1)
        }
    }
}

// MARK: - 回形针便签
struct ClipNote: View {
    let date: String; let text: String; let photos: [String]
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(date)
                .font(.system(size: 10, design: .monospaced)).foregroundColor(.inkDim)
            Text(text).font(.system(size: 13, weight: .semibold)).foregroundColor(.inkBlack)
            if !photos.isEmpty {
                HStack(spacing: 6) {
                    ForEach(photos, id: \.self) { p in
                        Text(p).font(.system(size: 20))
                            .frame(width: 48, height: 48)
                            .background(Color.paperWhite)
                            .overlay(Rectangle().stroke(Color.inkBlack, lineWidth: 1.5))
                    }
                }
            }
        }
        .padding(12).background(Color.kraftLight)
        .overlay(Rectangle().stroke(Color.inkBlack.opacity(0.08), lineWidth: 1))
        .rotationEffect(.degrees(-1))
        .overlay(alignment: .topLeading) {
            Text("📎").font(.system(size: 18)).rotationEffect(.degrees(-20)).offset(x: 12, y: -8)
        }
    }
}

// MARK: - 撕纸边
struct TornEdge: ViewModifier {
    func body(content: Content) -> some View {
        content
            .mask(alignment: .bottom) {
                VStack(spacing: 0) {
                    Rectangle().fill(.white)
                    TornShape().fill(.white).frame(height: 14)
                }
            }
    }
}

struct TornShape: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        let w = rect.width; let h = rect.height
        p.move(to: CGPoint(x: 0, y: 0))
        for x in stride(from: 0, through: w, by: 6) {
            let y = CGFloat.random(in: 0...(h * 0.7))
            p.addLine(to: CGPoint(x: x, y: y))
        }
        p.addLine(to: CGPoint(x: w, y: h))
        p.addLine(to: CGPoint(x: 0, y: h))
        p.closeSubpath()
        return p
    }
}

extension View {
    func tornEdge() -> some View { modifier(TornEdge()) }
}

// MARK: - 自定义导航栏
struct VintageNavBar: View {
    @Binding var selectedTab: Int
    @Binding var showAddRecord: Bool

    var body: some View {
        HStack(spacing: 0) {
            navItem(0, "🏠", "花园")
            navItem(1, "📅", "月历")
            Button { showAddRecord = true } label: {
                Text("＋").font(.system(size: 22, weight: .black))
                    .foregroundColor(.paperWhite)
                    .frame(width: 48, height: 48)
                    .background(Color.accentRed)
                    .overlay(Rectangle().stroke(Color.inkBlack, lineWidth: 2))
                    .shadow(color: .black.opacity(0.1), radius: 3, y: 2)
            }
            .offset(y: -8).frame(maxWidth: .infinity)
            navItem(3, "🔔", "提醒")
            navItem(4, "👤", "我的")
        }
        .padding(.horizontal, 8).padding(.top, 10).padding(.bottom, 20)
        .background(Color.paperWhite)
        .overlay(alignment: .top) { Rectangle().fill(Color.inkBlack).frame(height: 2) }
    }

    func navItem(_ tag: Int, _ icon: String, _ label: String) -> some View {
        Button { selectedTab = tag } label: {
            VStack(spacing: 4) {
                Text(icon).font(.system(size: 20))
                Text(label)
                    .font(.system(size: 8, weight: .black, design: .monospaced))
                    .foregroundColor(selectedTab == tag ? .inkBlack : .inkDim)
            }
        }.frame(maxWidth: .infinity)
    }
}

// MARK: - ContentView
struct ContentView: View {
    @EnvironmentObject var store: PlantStore
    @State private var selectedTab = 0
    @State private var showAddRecord = false

    var body: some View {
        ZStack(alignment: .bottom) {
            KraftBackground()
            TabView(selection: $selectedTab) {
                NavigationStack { HomeView() }.tag(0)
                NavigationStack { CalendarView() }.tag(1)
                NavigationStack { ReminderView() }.tag(3)
                NavigationStack { ProfileView() }.tag(4)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            VintageNavBar(selectedTab: $selectedTab, showAddRecord: $showAddRecord)
        }
        .sheet(isPresented: $showAddRecord) { AddRecordView() }
        .ignoresSafeArea(.keyboard)
    }
}

// MARK: - HomeView
struct HomeView: View {
    @EnvironmentObject var store: PlantStore
    @State private var weatherIndex: Int = {
        let seeds = [0, 1, 0, 0, 2, 0, 1, 0, 0, 2]
        return seeds[Int(Date().timeIntervalSince1970) % seeds.count]
    }()

    var body: some View {
        ZStack {
            KraftBackground()
            GeometryReader { geo in
                ScrollView {
                    VStack(spacing: 0) {
                        // 问候语
                        HStack {
                            VStack(alignment: .leading, spacing: 2) {
                                Text(greetingText()).font(.system(size: 13)).foregroundColor(.inkDim)
                                Text("植物花园").font(.system(size: 22, weight: .black)).foregroundColor(.inkBlack)
                            }
                            Spacer()
                            Text("\(currentYearMonth())")
                                .font(.system(size: 9, weight: .black, design: .monospaced))
                                .foregroundColor(.accentRed)
                                .padding(.horizontal, 8).padding(.vertical, 4)
                                .overlay(Rectangle().stroke(Color.accentRed, lineWidth: 1.5))
                                .rotationEffect(.degrees(3))
                        }
                        .padding(.horizontal, 14).padding(.top, 12).padding(.bottom, 10)
                        // 全屏天气
                        let potPlant = store.plants.first ?? store.plants[0]
                        WeatherHero(weatherIndex: weatherIndex, potPlant: potPlant, geo: geo)
                            .padding(.horizontal, 12)
                        // 头条横幅
                        let needsWater = store.plants.filter { $0.waterInterval.contains("7") }.count
                        HeadlineBanner(
                            title: "今日 \(needsWater) 盆植物\n等待浇水",
                            subtitle: "龟背竹大叶已 7 天未浇水，叶片微微发皱，建议今日傍晚施加 100ml 清水。"
                        ).padding(.horizontal, 12).padding(.top, 16)
                        // 我的植物藏品
                        SectionLabel(title: "我的植物藏品", color: .navyBlue)
                            .padding(.horizontal, 16).padding(.top, 20).padding(.bottom, 14)
                        LazyVStack(spacing: 16) {
                            ForEach(store.plants) { plant in
                                NavigationLink(destination: PlantDetailView(plant: plant)) {
                                    plantCard(plant)
                                }.buttonStyle(.plain)
                            }
                        }.padding(.horizontal, 12)
                        // 最新快讯
                        SectionLabel(title: "最新快讯", color: .navyBlue)
                            .padding(.horizontal, 16).padding(.top, 20).padding(.bottom, 14)
                        if let lastEvent = store.events.first {
                            ClipNote(date: "昨天 · 18:32", text: "\(lastEvent.type.emoji) 给\(lastEvent.plantName)\(lastEvent.type.rawValue)了，\(lastEvent.note) ✨", photos: ["🌸", "💧"])
                                .padding(.horizontal, 12)
                        }
                    }.padding(.bottom, 100)
                }
            }
        }
        .navigationBarHidden(true)
    }
    func greetingText() -> String {
        let h = Calendar.current.component(.hour, from: Date())
        if h < 11 { return "早安，小园丁" }
        else if h < 18 { return "下午好，小园丁" }
        else { return "晚安，小园丁" }
    }
    func currentYearMonth() -> String {
        let f = DateFormatter(); f.locale = Locale(identifier: "zh_CN"); f.dateFormat = "yyyy年M月"
        return f.string(from: Date())
    }
    func plantCard(_ plant: Plant) -> some View {
        VStack(spacing: 0) {
            HStack(spacing: 14) {
                ZStack(alignment: .topTrailing) {
                    Text(plant.emoji).font(.system(size: 38))
                        .frame(width: 76, height: 76)
                        .background(Color.kraftLight)
                        .overlay(Rectangle().stroke(Color.inkBlack, lineWidth: 2))
                    Circle().fill(Color.accentRed).frame(width: 12, height: 12).opacity(0.7)
                        .offset(x: 4, y: -4)
                }
                VStack(alignment: .leading, spacing: 3) {
                    Text(plant.name).font(.system(size: 16, weight: .black)).foregroundColor(.inkBlack)
                    Text("\(plant.family) · \(daysSince(plant.adoptedDate)) 天")
                        .font(.system(size: 11, design: .monospaced)).foregroundColor(.inkDim)
                    HStack(spacing: 6) {
                        tagView(plant.status == "健康" ? "状态健康" : plant.status,
                                color: plant.status == "健康" ? .navyBlue : .accentRed)
                        if plant.waterInterval.contains("7") { tagView("今日浇水", color: .accentRed) }
                        else if plant.growthValue < 0.5 { tagView("待施肥", color: .mustard) }
                    }
                }
                Spacer()
            }
            .padding(16).padding(.bottom, 10)
            HStack(spacing: 10) {
                Text("成长值").font(.system(size: 10, design: .monospaced)).foregroundColor(.inkDim)
                ZStack(alignment: .leading) {
                    Rectangle().fill(Color.kraftLight).frame(height: 6)
                        .overlay(Rectangle().stroke(Color.inkDim, lineWidth: 0.5))
                    Rectangle()
                        .fill(plant.growthValue > 0.7 ? Color.accentRed : Color.mustard)
                        .frame(width: CGFloat(plant.growthValue) * 120, height: 6)
                }
                Text("\(Int(plant.growthValue * 100))%")
                    .font(.system(size: 10, design: .monospaced)).foregroundColor(.inkDim)
            }
            .padding(.horizontal, 16).padding(.bottom, 14)
        }
        .background(Color.paperWhite)
        .overlay(Rectangle().stroke(Color.inkBlack.opacity(0.1), lineWidth: 1))
        .shadow(color: .black.opacity(0.08), radius: 2, y: 1)
        .tornEdge()
    }
    func tagView(_ text: String, color: Color) -> some View {
        Text(text)
            .font(.system(size: 9, weight: .black, design: .monospaced))
            .foregroundColor(color)
            .padding(.horizontal, 8).padding(.vertical, 3)
            .overlay(Rectangle().stroke(color, lineWidth: 1.5))
    }
    func daysSince(_ date: Date) -> Int {
        Calendar.current.dateComponents([.day], from: date, to: Date()).day ?? 0
    }
}

// MARK: - PlantIDCardView
struct PlantIDCardView: View {
    let plant: Plant
    var body: some View {
        VStack(spacing: 0) {
            // 头部
            HStack {
                Text("植物身份证")
                    .font(.system(size: 13, weight: .black, design: .monospaced))
                    .foregroundColor(.newsprint)
                Spacer()
                Text("SUCCULENT ID")
                    .font(.system(size: 10, design: .monospaced))
                    .foregroundColor(.newsprint.opacity(0.8))
                    .kerning(2)
            }
            .padding(.horizontal, 16).padding(.vertical, 8)
            .background(Color.navyBlue)
            // 主体
            HStack(spacing: 16) {
                // 照片区
                VStack(spacing: 6) {
                    Text(plant.emoji).font(.system(size: 44))
                        .frame(width: 80, height: 96)
                        .background(Color.kraftLight)
                        .overlay(Rectangle().stroke(Color.inkBlack, lineWidth: 2))
                        .overlay(alignment: .bottomTrailing) {
                            Text("PHOTO").font(.system(size: 7, design: .monospaced))
                                .foregroundColor(.inkDim.opacity(0.5)).padding(2)
                        }
                    Text("已验证")
                        .font(.system(size: 8, design: .monospaced)).foregroundColor(.inkBlack)
                        .padding(.horizontal, 6).padding(.vertical, 2)
                        .overlay(Rectangle().stroke(Color.inkBlack, lineWidth: 1))
                }
                // 字段
                VStack(spacing: 5) {
                    idField("姓名", plant.name, big: true)
                    idField("编号", "PL-\(String(format: "%04d", abs(plant.name.hashValue) % 10000))")
                    idField("科属", plant.family)
                    idField("别名", plant.alias)
                    idField("原产地", plant.origin)
                }
            }
            .padding(16)
            // 其他字段
            VStack(spacing: 5) {
                idField("浇水", plant.waterInterval)
                idField("光照", plant.light)
                idField("叶片", plant.leafType)
            }.padding(.horizontal, 16)
            Divider().background(Color.inkBlack.opacity(0.15)).padding(.vertical, 8)
            Text(plant.desc).font(.system(size: 12)).foregroundColor(.inkDim)
                .multilineTextAlignment(.center).padding(.bottom, 8)
            // 页脚
            HStack {
                HStack(spacing: 16) {
                    statBlock("128", "天")
                    statBlock("12", "水")
                    statBlock("3", "肥")
                    statBlock("1", "换")
                }
                Spacer()
                Text("有效期至 \(validityDate())")
                    .font(.system(size: 8, design: .monospaced)).foregroundColor(.inkDim)
            }
            .padding(.horizontal, 16).padding(.bottom, 10)
            // 条形码
            barcodeView(widths: [1, 2, 3, 1, 2, 1, 1, 2, 1, 3, 2, 1, 1, 2, 3, 1, 2, 1, 1, 2, 1, 3, 2, 1, 1, 2, 3, 1, 1, 2], height: 28)
                .padding(.bottom, 8)
            Text("ID: #PL-\(String(format: "%04d", abs(plant.name.hashValue) % 10000))")
                .font(.system(size: 9, design: .monospaced)).foregroundColor(.inkDim).kerning(3)
                .padding(.bottom, 10)
        }
        .background(Color.paperWhite)
        .overlay(Rectangle().stroke(Color.inkBlack, lineWidth: 2))
        .overlay(alignment: .topTrailing) {
            Text("健康")
                .font(.system(size: 11, weight: .black, design: .monospaced)).foregroundColor(.accentRed)
                .padding(.horizontal, 10).padding(.vertical, 4)
                .overlay(Rectangle().stroke(Color.accentRed, lineWidth: 2))
                .rotationEffect(.degrees(-8))
                .offset(x: -12, y: 42)
        }
    }
    func idField(_ label: String, _ value: String, big: Bool = false) -> some View {
        HStack(alignment: .baseline) {
            Text(label)
                .font(.system(size: 8, weight: .black, design: .monospaced)).foregroundColor(.inkDim)
                .frame(width: 52, alignment: .leading)
            Text(value)
                .font(.system(size: big ? 15 : 12, weight: big ? .black : .bold, design: .monospaced))
                .foregroundColor(big ? .navyBlue : .inkBlack)
            Spacer()
        }
        .padding(.bottom, 3)
        .overlay(alignment: .bottom) { Rectangle().fill(Color.inkBlack.opacity(0.12)).frame(height: 1) }
    }
    func statBlock(_ value: String, _ label: String) -> some View {
        VStack(spacing: 0) {
            Text(value).font(.system(size: 16, weight: .black, design: .monospaced)).foregroundColor(.navyBlue)
            Text(label).font(.system(size: 8, design: .monospaced)).foregroundColor(.inkDim)
        }
    }
    func validityDate() -> String {
        let f = DateFormatter(); f.dateFormat = "yyyy.MM.dd"; return f.string(from: Date())
    }
    func barcodeView(widths: [CGFloat], height: CGFloat) -> some View {
        HStack(spacing: 1) {
            ForEach(widths.indices, id: \.self) { i in
                Rectangle().fill(Color.inkBlack).frame(width: widths[i], height: height)
            }
        }
    }
}

// MARK: - PlantDetailView
struct PlantDetailView: View {
    let plant: Plant
    @EnvironmentObject var store: PlantStore
    var plantEvents: [CareEvent] { store.events.filter { $0.plantName == plant.name } }

    var body: some View {
        ZStack {
            KraftBackground()
            ScrollView {
                VStack(spacing: 14) {
                    HStack {
                        Text("← 返回花园").font(.system(size: 13)).foregroundColor(.inkDim)
                        Spacer()
                    }.padding(.horizontal, 14).padding(.top, 8)
                    PlantIDCardView(plant: plant).padding(.horizontal, 12)
                    SectionLabel(title: "成长时间轴", color: .navyBlue)
                        .padding(.horizontal, 16).padding(.top, 8)
                    if plantEvents.isEmpty {
                        Text("暂无记录").font(.system(size: 11, design: .monospaced)).foregroundColor(.inkDim).padding()
                    } else {
                        ForEach(plantEvents) { event in timelineRow(event) }
                    }
                }.padding(.bottom, 100)
            }
        }
        .navigationBarHidden(true)
    }
    func timelineRow(_ event: CareEvent) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Rectangle()
                .fill(event.type.eventColor)
                .frame(width: 16, height: 16)
                .overlay(Rectangle().stroke(Color.inkBlack, lineWidth: 2))
            VStack(alignment: .leading, spacing: 4) {
                Text(event.date, style: .date)
                    .font(.system(size: 10, design: .monospaced)).foregroundColor(.inkDim)
                Text("\(event.type.emoji) \(event.type.rawValue)")
                    .font(.system(size: 13, weight: .semibold)).foregroundColor(.inkBlack)
                if !event.note.isEmpty {
                    Text(event.note).font(.system(size: 12)).foregroundColor(.inkDim)
                }
                if !event.photoData.isEmpty {
                    HStack(spacing: 6) {
                        ForEach(event.photoData.indices, id: \.self) { i in
                            if let uiImage = UIImage(data: event.photoData[i]) {
                                Image(uiImage: uiImage).resizable().scaledToFill()
                                    .frame(width: 48, height: 48).clipped()
                                    .overlay(Rectangle().stroke(Color.inkBlack, lineWidth: 1.5))
                            }
                        }
                    }
                }
            }
            Spacer()
        }
        .padding(12).background(Color.paperWhite)
        .overlay(Rectangle().stroke(Color.inkBlack.opacity(0.1), lineWidth: 1))
        .shadow(color: .black.opacity(0.06), radius: 2, y: 1)
        .padding(.horizontal, 12)
    }
}

// MARK: - AddRecordView
struct AddRecordView: View {
    @EnvironmentObject var store: PlantStore; @Environment(\.dismiss) var dismiss
    @State private var selectedPlant = ""; @State private var selectedType: EventType = .water
    @State private var note = ""; @State private var selectedPhotos: [PhotosPickerItem] = []
    @State private var photoDatas: [Data] = []

    var body: some View {
        ZStack {
            Color.bgWarm.ignoresSafeArea()
            ScrollView {
                VStack(spacing: 16) {
                    Text("记录成长").font(.system(size: 22, weight: .black, design: .monospaced))
                        .foregroundColor(.inkBlack).kerning(2).padding(.top, 20)
                    // 选择植物
                    VStack(alignment: .leading, spacing: 8) {
                        Text("选择植物").font(.system(size: 10, weight: .black, design: .monospaced))
                            .foregroundColor(.navyBlue).kerning(2)
                        Picker("植物", selection: $selectedPlant) {
                            Text("-- 请选择 --").tag("")
                            ForEach(store.plants) { plant in
                                Text("\(plant.emoji) \(plant.name)").tag(plant.name)
                            }
                        }.pickerStyle(.menu).padding(10).background(Color.paperWhite)
                            .overlay(Rectangle().stroke(Color.inkBlack, lineWidth: 1))
                    }.padding(.horizontal, 12)
                    // 事件类型
                    VStack(alignment: .leading, spacing: 8) {
                        Text("事件类型").font(.system(size: 10, weight: .black, design: .monospaced))
                            .foregroundColor(.navyBlue).kerning(2)
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: 8) {
                            ForEach(EventType.allCases, id: \.self) { type in
                                Button { selectedType = type } label: {
                                    VStack(spacing: 3) {
                                        Text(type.emoji).font(.title3)
                                        Text(type.rawValue)
                                            .font(.system(size: 7, weight: .black, design: .monospaced))
                                            .foregroundColor(selectedType == type ? .paperWhite : .inkDim)
                                    }
                                    .frame(maxWidth: .infinity).padding(.vertical, 8)
                                    .background(selectedType == type ? Color.accentRed : Color.paperWhite)
                                    .overlay(Rectangle().stroke(
                                        selectedType == type ? Color.accentRed : Color.inkBlack.opacity(0.1), lineWidth: 1))
                                }.buttonStyle(.plain)
                            }
                        }
                    }.padding(.horizontal, 12)
                    // 笔记
                    VStack(alignment: .leading, spacing: 8) {
                        Text("养护笔记").font(.system(size: 10, weight: .black, design: .monospaced))
                            .foregroundColor(.navyBlue).kerning(2)
                        TextField("记录养护细节...", text: $note, axis: .vertical).lineLimit(3...6)
                            .font(.system(size: 13)).padding(12).background(Color.paperWhite)
                            .overlay(Rectangle().stroke(Color.inkBlack.opacity(0.1), lineWidth: 1))
                    }.padding(.horizontal, 12)
                    // 照片
                    VStack(alignment: .leading, spacing: 8) {
                        Text("照片").font(.system(size: 10, weight: .black, design: .monospaced))
                            .foregroundColor(.navyBlue).kerning(2)
                        PhotosPicker(selection: $selectedPhotos, maxSelectionCount: 3, matching: .images) {
                            HStack {
                                Image(systemName: "photo.on.rectangle.angled")
                                Text("选择照片").font(.system(size: 12, weight: .bold, design: .monospaced))
                            }
                            .padding(12).frame(maxWidth: .infinity)
                            .background(Color.paperWhite)
                            .overlay(Rectangle().stroke(Color.inkBlack, lineWidth: 1.5))
                        }
                        if !photoDatas.isEmpty {
                            ScrollView(.horizontal) {
                                HStack {
                                    ForEach(photoDatas.indices, id: \.self) { i in
                                        if let uiImage = UIImage(data: photoDatas[i]) {
                                            Image(uiImage: uiImage).resizable().scaledToFill()
                                                .frame(width: 72, height: 72).clipped()
                                                .overlay(Rectangle().stroke(Color.inkBlack, lineWidth: 2))
                                        }
                                    }
                                }
                            }
                        }
                    }.padding(.horizontal, 12)
                    Button {
                        saveRecord(); dismiss()
                    } label: {
                        Text("保存记录")
                            .font(.system(size: 14, weight: .black, design: .monospaced))
                            .foregroundColor(.paperWhite).kerning(3)
                            .frame(maxWidth: .infinity).padding(.vertical, 14)
                            .background(Color.inkBlack)
                            .overlay(Rectangle().stroke(Color.inkBlack, lineWidth: 2))
                            .shadow(color: .black.opacity(0.1), radius: 3, y: 2)
                    }
                    .disabled(selectedPlant.isEmpty).opacity(selectedPlant.isEmpty ? 0.5 : 1)
                    .padding(.horizontal, 12)
                    Button("取消") { dismiss() }
                        .font(.system(size: 10, design: .monospaced)).foregroundColor(.inkDim).padding(.bottom, 20)
                }
            }
        }
        .onChange(of: selectedPhotos) { _, newItems in
            Task { photoDatas = []; for item in newItems {
                if let data = try? await item.loadTransferable(type: Data.self) { photoDatas.append(data) }
            }}
        }
    }
    func saveRecord() {
        store.addEvent(CareEvent(type: selectedType, plantName: selectedPlant, note: note, date: Date(), photoData: photoDatas))
    }
}

// MARK: - CalendarView
struct CalendarView: View {
    @EnvironmentObject var store: PlantStore
    @State private var currentDate = Date(); @State private var selectedDay: Int?
    private var calendar: Calendar { Calendar.current }
    private var daysInMonth: Int { calendar.range(of: .day, in: .month, for: currentDate)!.count }
    private var firstWeekday: Int {
        let comp = calendar.dateComponents([.year, .month], from: currentDate)
        return calendar.component(.weekday, from: calendar.date(from: comp)!)
    }

    var body: some View {
        ZStack {
            KraftBackground()
            ScrollView {
                VStack(spacing: 14) {
                    HeadlineBanner(title: "养护月历", subtitle: "每月养护记录")
                        .padding(.horizontal, 12).padding(.top, 8)
                    HStack {
                        Button { changeMonth(-1) } label: {
                            Image(systemName: "chevron.left").font(.system(size: 16, weight: .black)).foregroundColor(.inkBlack)
                        }
                        Text(currentDate, format: .dateTime.year().month(.wide))
                            .font(.system(size: 20, weight: .black, design: .monospaced)).foregroundColor(.inkBlack)
                            .frame(maxWidth: .infinity)
                        Button { changeMonth(1) } label: {
                            Image(systemName: "chevron.right").font(.system(size: 16, weight: .black)).foregroundColor(.inkBlack)
                        }
                    }.padding(.horizontal, 20)
                    if let day = selectedDay { dayEventsCard(day).padding(.horizontal, 12) }
                    calendarGrid.padding(.horizontal, 12)
                }.padding(.bottom, 100)
            }
        }
        .navigationBarHidden(true)
    }
    func changeMonth(_ by: Int) {
        if let d = calendar.date(byAdding: .month, value: by, to: currentDate) { currentDate = d; selectedDay = nil }
    }
    var calendarGrid: some View {
        let eventDays = store.daysWithEventsInMonth(currentDate)
        let todayComp = calendar.dateComponents([.year, .month, .day], from: Date())
        let curComp = calendar.dateComponents([.year, .month], from: currentDate)
        let isCurrentMonth = todayComp.year == curComp.year && todayComp.month == curComp.month
        return VStack(spacing: 0) {
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7)) {
                ForEach(["日", "一", "二", "三", "四", "五", "六"], id: \.self) { d in
                    Text(d).font(.system(size: 8, weight: .black, design: .monospaced))
                        .foregroundColor(.inkDim).kerning(1).frame(height: 28)
                }
                ForEach(0..<(firstWeekday - 1), id: \.self) { _ in Color.clear.frame(height: 42) }
                ForEach(1...daysInMonth, id: \.self) { day in
                    let isToday = isCurrentMonth && todayComp.day == day
                    let hasEvent = eventDays.contains(day)
                    Button {
                        selectedDay = (selectedDay == day) ? nil : day
                    } label: {
                        VStack(spacing: 2) {
                            Text("\(day)")
                                .font(.system(size: 14, weight: isToday ? .black : .medium, design: .monospaced))
                                .foregroundColor(isToday ? .paperWhite : .inkBlack)
                            if hasEvent { Rectangle().fill(Color.accentRed).frame(width: 4, height: 4) }
                        }
                        .frame(height: 42).frame(maxWidth: .infinity)
                        .background(isToday ? Color.accentRed : (selectedDay == day ? Color.kraftLight : .clear))
                        .overlay(Rectangle().stroke(selectedDay == day ? Color.inkBlack : .clear, lineWidth: 1))
                    }.buttonStyle(.plain)
                }
            }
        }
        .padding(12).background(Color.paperWhite)
        .overlay(Rectangle().stroke(Color.inkBlack, lineWidth: 1.5))
        .shadow(color: .black.opacity(0.08), radius: 2, y: 1)
    }
    func dayEventsCard(_ day: Int) -> some View {
        let events = store.eventsForDay(day, inMonth: currentDate)
        return VStack(alignment: .leading, spacing: 8) {
            Text("\(calendar.component(.month, from: currentDate))月\(day)日")
                .font(.system(size: 15, weight: .black, design: .monospaced)).foregroundColor(.inkBlack)
            if events.isEmpty {
                Text("无记录").font(.system(size: 8, design: .monospaced)).foregroundColor(.inkDim)
            } else {
                ForEach(events) { event in
                    HStack(spacing: 8) {
                        Text(event.type.emoji).font(.system(size: 18))
                        VStack(alignment: .leading, spacing: 1) {
                            Text("\(event.plantName) · \(event.type.rawValue)")
                                .font(.system(size: 12, weight: .bold)).foregroundColor(.inkBlack)
                            Text(event.note).font(.system(size: 8, design: .monospaced)).foregroundColor(.inkDim)
                        }
                    }
                    .padding(8).frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.kraftLight.opacity(0.3))
                    .overlay(Rectangle().stroke(Color.inkBlack.opacity(0.08), lineWidth: 1))
                }
            }
        }
        .padding(12).background(Color.paperWhite)
        .overlay(Rectangle().stroke(Color.inkBlack.opacity(0.1), lineWidth: 1))
        .shadow(color: .black.opacity(0.04), radius: 1, y: 1)
    }
}

// MARK: - ReminderView
struct ReminderView: View {
    @EnvironmentObject var store: PlantStore
    var body: some View {
        ZStack {
            KraftBackground()
            ScrollView {
                VStack(spacing: 14) {
                    HeadlineBanner(title: "养护提醒", subtitle: "养护计划").padding(.horizontal, 12).padding(.top, 8)
                    ForEach(store.plants) { plant in
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text(plant.emoji).font(.system(size: 24))
                                    .frame(width: 40, height: 40)
                                    .background(Color.kraftLight)
                                    .overlay(Rectangle().stroke(Color.inkBlack, lineWidth: 1.5))
                                VStack(alignment: .leading) {
                                    Text(plant.name).font(.system(size: 15, weight: .black)).foregroundColor(.inkBlack)
                                    Text(plant.sciName)
                                        .font(.system(size: 8, design: .monospaced).italic()).foregroundColor(.inkDim)
                                }
                                Spacer()
                            }
                            reminderRow(plant: plant, type: .water, icon: "💧", freq: "每\(plant.waterInterval)浇一次")
                            reminderRow(plant: plant, type: .fertilize, icon: "🧪", freq: "每30天施一次肥")
                            reminderRow(plant: plant, type: .pesticide, icon: "💊", freq: "每60天检查虫害")
                        }
                        .padding(12).background(Color.paperWhite)
                        .overlay(Rectangle().stroke(Color.inkBlack.opacity(0.1), lineWidth: 1))
                        .shadow(color: .black.opacity(0.05), radius: 2, y: 1)
                        .padding(.horizontal, 12)
                    }
                }.padding(.bottom, 100)
            }
        }
        .navigationBarHidden(true)
    }
    func reminderRow(plant: Plant, type: EventType, icon: String, freq: String) -> some View {
        HStack(spacing: 10) {
            Text(icon).font(.system(size: 18))
                .frame(width: 36, height: 36)
                .background(Color.kraftLight)
                .overlay(Rectangle().stroke(Color.inkBlack, lineWidth: 1.5))
            VStack(alignment: .leading, spacing: 1) {
                Text("\(type.rawValue) \(plant.name)")
                    .font(.system(size: 12, weight: .bold)).foregroundColor(.inkBlack)
                Text(freq).font(.system(size: 8, design: .monospaced)).foregroundColor(.inkDim)
            }
            Spacer()
            Button("完成") {}
                .font(.system(size: 8, weight: .black, design: .monospaced)).foregroundColor(.paperWhite)
                .padding(.horizontal, 12).padding(.vertical, 6)
                .background(Color.inkBlack)
                .overlay(Rectangle().stroke(Color.inkBlack, lineWidth: 1))
        }
        .padding(8).background(Color.kraftLight.opacity(0.2))
        .overlay(Rectangle().stroke(Color.inkBlack.opacity(0.06), lineWidth: 1))
    }
}

// MARK: - ProfileView
struct ProfileView: View {
    @EnvironmentObject var store: PlantStore
    var body: some View {
        ZStack {
            KraftBackground()
            ScrollView {
                VStack(spacing: 14) {
                    HeadlineBanner(title: "我的", subtitle: "工具与知识").padding(.horizontal, 12).padding(.top, 8)
                    sectionView("工具", items: [
                        ("sparkles", "植物纪念碑", AnyView(MemorialView())),
                        ("receipt", "本月账单", AnyView(ReceiptView())),
                        ("square.grid.3x3", "花架摆放", AnyView(ShelfView())),
                        ("camera.macro", "植物标本馆", AnyView(HerbariumView())),
                    ])
                    sectionView("知识库", items: [
                        ("book.pages", "品种图鉴", AnyView(SpeciesGuideView())),
                        ("camera.fill", "成长拍立得", AnyView(GrowthPolaroidView())),
                        ("stethoscope", "病虫害图鉴", AnyView(PestGuideView())),
                    ])
                    sectionView("管理", items: [
                        ("testtube.2", "肥料药品管理", AnyView(SupplyManagerView())),
                        ("heart", "心愿清单", AnyView(WishlistView())),
                    ])
                }.padding(.bottom, 100)
            }
        }
        .navigationBarHidden(true)
    }
    func sectionView(_ title: String, items: [(String, String, AnyView)]) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(title)
                .font(.system(size: 10, weight: .black, design: .monospaced)).foregroundColor(.accentRed)
                .padding(.horizontal, 16).padding(.bottom, 8)
            VStack(spacing: 0) {
                ForEach(0..<items.count, id: \.self) { i in
                    NavigationLink(destination: items[i].2) {
                        HStack {
                            Image(systemName: items[i].0).font(.system(size: 16)).foregroundColor(.inkBlack).frame(width: 32)
                            Text(items[i].1)
                                .font(.system(size: 14, weight: .bold, design: .monospaced)).foregroundColor(.inkBlack)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .font(.system(size: 10, weight: .bold)).foregroundColor(.inkDim)
                        }
                        .padding(.horizontal, 16).padding(.vertical, 12)
                    }
                    if i < items.count - 1 {
                        Divider().background(Color.inkBlack.opacity(0.08)).padding(.leading, 48)
                    }
                }
            }
            .background(Color.paperWhite)
            .overlay(Rectangle().stroke(Color.inkBlack, lineWidth: 1.5))
            .shadow(color: .black.opacity(0.08), radius: 2, y: 1)
        }.padding(.horizontal, 12)
    }
}