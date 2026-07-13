import SwiftUI

struct ContentView: View {
    @EnvironmentObject var store: PlantStore
    @State private var selectedTab = 0
    @State private var showAddRecord = false

    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationStack { HomeView() }
                .tabItem { Label("花园", systemImage: "leaf.fill") }
                .tag(0)

            NavigationStack { CalendarView() }
                .tabItem { Label("月历", systemImage: "calendar") }
                .tag(1)

            Color.clear
                .tabItem { Label("", systemImage: "") }
                .tag(2)

            NavigationStack { ReminderView() }
                .tabItem { Label("提醒", systemImage: "bell.fill") }
                .tag(3)

            NavigationStack { ProfileView() }
                .tabItem { Label("我的", systemImage: "person.fill") }
                .tag(4)
        }
        .overlay(alignment: .bottom) {
            Button {
                showAddRecord = true
            } label: {
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 48))
                    .foregroundStyle(.white, Color.green)
                    .shadow(radius: 4)
            }
            .offset(y: -8)
        }
        .sheet(isPresented: $showAddRecord) {
            AddRecordView()
        }
    }
}