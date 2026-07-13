import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var store: PlantStore

    var body: some View {
        List {
            Section("工具") {
                NavigationLink(destination: MemorialView()) {
                    Label("植物纪念碑", systemImage: "sparkles")
                }
                NavigationLink(destination: ReceiptView()) {
                    Label("本月账单", systemImage: "receipt")
                }
                NavigationLink(destination: ShelfView()) {
                    Label("花架摆放", systemImage: "square.grid.3x3")
                }
                NavigationLink(destination: HerbariumView()) {
                    Label("植物标本馆", systemImage: "camera.macro")
                }
            }
            Section("知识库") {
                NavigationLink(destination: SpeciesGuideView()) {
                    Label("品种图鉴", systemImage: "book.pages")
                }
                NavigationLink(destination: GrowthPolaroidView()) {
                    Label("成长拍立得", systemImage: "camera.fill")
                }
                NavigationLink(destination: PestGuideView()) {
                    Label("病虫害图鉴", systemImage: "stethoscope")
                }
            }
            Section("管理") {
                NavigationLink(destination: SupplyManagerView()) {
                    Label("肥料药品管理", systemImage: "testtube.2")
                }
                NavigationLink(destination: WishlistView()) {
                    Label("心愿清单", systemImage: "heart")
                }
            }
        }
        .navigationTitle("我的")
    }
}