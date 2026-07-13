import SwiftUI

struct SupplyManagerView: View {
    @EnvironmentObject var store: PlantStore
    @State private var showAdd = false
    @State private var filter: SupplyType?
    @State private var newName = ""
    @State private var newType: SupplyType = .fertilizer
    @State private var newDate = ""
    @State private var newNote = ""

    var filtered: [Supply] {
        if let filter { store.supplies.filter { $0.type == filter } } else { store.supplies }
    }

    var body: some View {
        List {
            Section {
                HStack {
                    TextField("名称", text: $newName)
                    Picker("类型", selection: $newType) {
                        ForEach(SupplyType.allCases, id: \.self) { t in Text(t.rawValue).tag(t) }
                    }
                }
                HStack {
                    TextField("购买日期", text: $newDate)
                    TextField("备注", text: $newNote)
                }
                Button("添加记录") {
                    guard !newName.isEmpty else { return }
                    store.addSupply(Supply(name: newName, type: newType, date: newDate.isEmpty ? "未知" : newDate, note: newNote))
                    newName = ""; newDate = ""; newNote = ""
                }
                .disabled(newName.isEmpty)
            }

            Section {
                Picker("筛选", selection: $filter) {
                    Text("全部 (\(store.supplies.count))").tag(nil as SupplyType?)
                    ForEach(SupplyType.allCases, id: \.self) { t in
                        Text("\(t.rawValue) (\(store.supplies.filter{$0.type==t}.count))").tag(t as SupplyType?)
                    }
                }
            }

            Section {
                ForEach(filtered) { item in
                    HStack {
                        Text(item.type.icon)
                        VStack(alignment: .leading) {
                            Text(item.name).font(.subheadline)
                            Text("\(item.date) · \(item.note)").font(.caption).foregroundStyle(.secondary)
                        }
                        Spacer()
                        Text(item.type.rawValue).font(.caption2).padding(.horizontal, 6).padding(.vertical, 2)
                            .background(item.type == .fertilizer ? Color.green.opacity(0.15) : item.type == .pesticide ? Color.orange.opacity(0.15) : Color.blue.opacity(0.15), in: Capsule())
                    }
                }
                .onDelete { idx in
                    for i in idx {
                        store.deleteSupply(filtered[i])
                    }
                }
            }
        }
        .navigationTitle("肥料药品管理")
    }
}

struct WishlistView: View {
    @EnvironmentObject var store: PlantStore
    @State private var showAdd = false
    @State private var newName = ""
    @State private var newPhoto: UIImage?
    @State private var showPhotoPicker = false
    @State private var photoItem: PhotosPickerItem?

    var body: some View {
        List {
            Section {
                HStack {
                    TextField("植物名称", text: $newName)
                    Button {
                        showPhotoPicker = true
                    } label: {
                        Image(systemName: newPhoto == nil ? "photo.badge.plus" : "photo.fill")
                            .foregroundStyle(newPhoto == nil ? .secondary : .green)
                    }
                }
                Button("加入心愿") {
                    guard !newName.isEmpty else { return }
                    var wish = WishItem(name: newName)
                    if let img = newPhoto {
                        wish.photoData = img.jpegData(compressionQuality: 0.7)
                    }
                    store.addWish(wish)
                    newName = ""; newPhoto = nil
                }
                .disabled(newName.isEmpty)
            }

            Section("心愿清单") {
                ForEach(store.wishes) { wish in
                    HStack {
                        if let data = wish.photoData, let uiImage = UIImage(data: data) {
                            Image(uiImage: uiImage).resizable().scaledToFill()
                                .frame(width: 44, height: 44).clipShape(RoundedRectangle(cornerRadius: 8))
                        } else {
                            RoundedRectangle(cornerRadius: 8).fill(Color(.systemGray6))
                                .frame(width: 44, height: 44)
                                .overlay(Image(systemName: "photo").foregroundStyle(.secondary))
                        }
                        Text(wish.name).font(.subheadline)
                            .strikethrough(wish.owned).foregroundStyle(wish.owned ? .secondary : .primary)
                        Spacer()
                        Button {
                            store.toggleWishOwned(wish)
                        } label: {
                            Image(systemName: wish.owned ? "checkmark.circle.fill" : "circle")
                                .foregroundStyle(wish.owned ? .green : .secondary)
                        }
                    }
                }
                .onDelete { idx in
                    for i in idx { store.deleteWish(store.wishes[i]) }
                }
            }
        }
        .navigationTitle("心愿清单")
        .photosPicker(isPresented: $showPhotoPicker, selection: $photoItem, matching: .images)
        .onChange(of: photoItem) { _, item in
            Task {
                if let data = try? await item?.loadTransferable(type: Data.self),
                   let img = UIImage(data: data) {
                    newPhoto = img
                }
            }
        }
    }
}