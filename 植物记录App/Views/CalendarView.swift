import SwiftUI

struct CalendarView: View {
    @EnvironmentObject var store: PlantStore
    @State private var currentDate = Date()
    @State private var selectedDay: Int?

    private var calendar: Calendar { Calendar.current }
    private var daysInMonth: Int {
        calendar.range(of: .day, in: .month, for: currentDate)!.count
    }
    private var firstWeekday: Int {
        let comp = calendar.dateComponents([.year, .month], from: currentDate)
        let first = calendar.date(from: comp)!
        return calendar.component(.weekday, from: first)
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                // 月份切换
                HStack {
                    Button { changeMonth(-1) } label: { Image(systemName: "chevron.left") }
                    Text(currentDate, format: .dateTime.year().month(.wide))
                        .font(.title2).bold().frame(maxWidth: .infinity)
                    Button { changeMonth(1) } label: { Image(systemName: "chevron.right") }
                }
                .padding(.horizontal)

                // 今日卡片
                if let day = selectedDay {
                    dayEventsCard(day)
                }

                // 日历网格
                calendarGrid
                    .padding(.horizontal)
            }
            .padding(.vertical)
        }
        .navigationTitle("养护月历")
    }

    func changeMonth(_ by: Int) {
        if let newDate = calendar.date(byAdding: .month, value: by, to: currentDate) {
            currentDate = newDate
            selectedDay = nil
        }
    }

    var calendarGrid: some View {
        let eventDays = store.daysWithEventsInMonth(currentDate)
        let todayComp = calendar.dateComponents([.year, .month, .day], from: Date())
        let curComp = calendar.dateComponents([.year, .month], from: currentDate)
        let isCurrentMonth = todayComp.year == curComp.year && todayComp.month == curComp.month

        return LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7)) {
            ForEach(["日","一","二","三","四","五","六"], id: \.self) { d in
                Text(d).font(.caption).bold().foregroundStyle(.secondary)
            }
            ForEach(0..<(firstWeekday - 1), id: \.self) { _ in Color.clear.frame(height: 40) }
            ForEach(1...daysInMonth, id: \.self) { day in
                let isToday = isCurrentMonth && todayComp.day == day
                let hasEvent = eventDays.contains(day)
                Button {
                    selectedDay = (selectedDay == day) ? nil : day
                } label: {
                    VStack(spacing: 2) {
                        Text("\(day)").font(.callout)
                            .foregroundStyle(isToday ? .white : .primary)
                        if hasEvent {
                            Circle().fill(Color.green).frame(width: 4, height: 4)
                        }
                    }
                    .frame(height: 40)
                    .frame(maxWidth: .infinity)
                    .background(isToday ? Color.green : (selectedDay == day ? Color.green.opacity(0.1) : .clear), in: RoundedRectangle(cornerRadius: 8))
                }
                .buttonStyle(.plain)
            }
        }
    }

    func dayEventsCard(_ day: Int) -> some View {
        let events = store.eventsForDay(day, inMonth: currentDate)
        return VStack(alignment: .leading, spacing: 8) {
            Text("\(calendar.component(.month, from: currentDate))月\(day)日").font(.headline)
            if events.isEmpty {
                Text("当天无记录").font(.caption).foregroundStyle(.secondary)
            } else {
                ForEach(events) { event in
                    HStack {
                        Text(event.type.emoji)
                        Text("\(event.plantName) · \(event.type.rawValue)")
                        Spacer()
                        Text(event.note).font(.caption).foregroundStyle(.secondary)
                    }
                    .padding(8)
                    .background(Color(.systemGray6), in: RoundedRectangle(cornerRadius: 8))
                }
            }
        }
        .padding()
        .background(Color(.systemBackground), in: RoundedRectangle(cornerRadius: 12))
        .shadow(color: .black.opacity(0.04), radius: 4, y: 2)
        .padding(.horizontal)
    }
}