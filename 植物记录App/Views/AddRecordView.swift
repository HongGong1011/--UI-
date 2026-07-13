import SwiftUI
import PhotosUI

struct AddRecordView: View {
    @EnvironmentObject var store: PlantStore
    @Environment(\.dismiss) var dismiss

    @State private var selectedPlant = ""
    @State private var selectedType: EventType = .water
    @State private var note = ""
    @State private var selectedPhotos: [PhotosPickerItem] = []
    @State private var photoDatas: [Data] = []

    var body: some View {
        NavigationStack {
            Form {
                Section("选择植物") {
                    Picker("植物", selection: $selectedPlant) {
                        Text("请选择").tag("")
                        ForEach(store.plants) { plant in
                            Text("\(plant.emoji) \(plant.name)").tag(plant.name)
                        }
                    }
                }

                Section("事件类型") {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 60))], spacing: 8) {
                        ForEach(EventType.allCases, id: \.self) { type in
                            Button {
                                selectedType = type
                            } label: {
                                VStack(spacing: 4) {
                                    Text(type.emoji).font(.title2)
                                    Text(type.rawValue).font(.caption2)
                                }
                                .padding(8)
                                .background(selectedType == type ? Color.green.opacity(0.15) : Color(.systemGray6), in: RoundedRectangle(cornerRadius: 10))
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }

                Section("养护笔记") {
                    TextField("记录养护细节...", text: $note, axis: .vertical)
                        .lineLimit(3...6)
                }

                Section("添加照片") {
                    PhotosPicker(selection: $selectedPhotos, maxSelectionCount: 3, matching: .images) {
                        Label("选择照片", systemImage: "photo.on.rectangle.angled")
                    }
                    if !photoDatas.isEmpty {
                        ScrollView(.horizontal) {
                            HStack {
                                ForEach(photoDatas.indices, id: \.self) { i in
                                    if let uiImage = UIImage(data: photoDatas[i]) {
                                        Image(uiImage: uiImage)
                                            .resizable().scaledToFill()
                                            .frame(width: 80, height: 80)
                                            .clipShape(RoundedRectangle(cornerRadius: 8))
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("记录成长")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("取消") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("保存") {
                        saveRecord()
                        dismiss()
                    }
                    .disabled(selectedPlant.isEmpty)
                }
            }
            .onChange(of: selectedPhotos) { _, newItems in
                Task {
                    photoDatas = []
                    for item in newItems {
                        if let data = try? await item.loadTransferable(type: Data.self) {
                            photoDatas.append(data)
                        }
                    }
                }
            }
        }
    }

    func saveRecord() {
        let event = CareEvent(
            type: selectedType,
            plantName: selectedPlant,
            note: note,
            date: Date(),
            photoData: photoDatas
        )
        store.addEvent(event)
    }
}