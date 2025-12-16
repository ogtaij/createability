//
//  Calendar.swift
//  PracticingXcode
//
//  Created by Rhonda Davis on 12/1/25.
//


import SwiftUI


struct GalaxyCalendarScreen: View {
    @State private var isSpinningGear = false
    @State private var showHoroscope = false

    // State for the calendar’s horoscope (separate from MoodCheckInView)
    @State private var calendarHoroscopeMessage: String = ""
    @State private var calendarIsLoadingHoroscope = false
    @State private var calendarHoroscopeError: String?

    var body: some View {
        NavigationStack {
            GalaxyCalendarView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .navigationTitle("")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button {
                            withAnimation(.linear(duration: 1)) {
                                isSpinningGear.toggle()
                            }
                        } label: {
                            Image(systemName: "gearshape")
                                .foregroundStyle(.white)
                                .rotationEffect(.degrees(isSpinningGear ? 360 : 0))
                                .accessibilityLabel("Settings")
                                .font(.title)
                        }
                    }
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            // When Cancer icon is tapped, load horoscope via API then show sheet
                            Task {
                                await loadCalendarHoroscope()
                                showHoroscope = true
                            }
                        } label: {
                            ZStack {
                                Image("cancerImage")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 60, height: 40)
                            }
                        }
                    }
                }
                // Horoscope sheet
                .sheet(isPresented: $showHoroscope) {
                    HoroscopeSheetView(
                        sign: "Cancer",
                        message: calendarHoroscopeMessage.isEmpty
                            // Fallback if API hasn’t filled yet
                            ? HoroscopeGenerator.cancerHoroscope(
                                for: Date(),
                                mood: .neutral
                              )
                            : calendarHoroscopeMessage
                    )
                }
        }
    }

   

    @MainActor
    private func loadCalendarHoroscope() async {
        calendarIsLoadingHoroscope = true
        calendarHoroscopeError = nil

        do {
            // Calendar doesn't track mood, so we use .neutral here
            let text = try await HoroscopeAPI.shared.fetchHoroscope(
                sign: "Cancer",
                mood: .neutral
            )
            calendarHoroscopeMessage = text
        } catch {
         
            calendarHoroscopeMessage = HoroscopeGenerator.cancerHoroscope(
                for: Date(),
                mood: .neutral
            )
            calendarHoroscopeError = "Using offline horoscope today."
        }

        calendarIsLoadingHoroscope = false
    }
}



enum Tab: Hashable {
    case home, commitment, calendar, journal, selfCare
}



struct GalaxyCalendarView: View {

    // State & helpers
    @State private var displayedMonth: Date = Date()
    @State private var selectedDate: Date? = Date()
    @State private var selection: Tab = .home
    
    @StateObject private var journalStore = JournalStore()
    @State private var isShowingJournal = false
    @State private var journalText: String = ""

    private let calendar = Calendar.current

    private let monthFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "LLLL yyyy"   // e.g. "December 2025"
        return df
    }()

    private let weekdaySymbols = ["Sun","Mon","Tue","Wed","Thu","Fri","Sat"]

    private var daysInDisplayedMonth: [Date?] {
        makeDaysForMonth()
    }

    // Background - Galaxy
    var body: some View {
        ZStack {
//            GeometryReader { geo in
//                Image("galaxy")
//                    .resizable()
//                    .scaledToFill()
//                    .frame(
//                        width: geo.size.width,
//                        height: geo.size.height
//                    )
//                    .clipped()
//                    .overlay(Color.black.opacity(0.55))
//                    .overlay(
//                        LinearGradient(
//                            colors: [
//                                .purple.opacity(0.25),
//                                .black.opacity(0.7)
//                            ],
//                            startPoint: .top,
//                            endPoint: .bottom
//                        )
//                    )
//                    .ignoresSafeArea()
//            }
//            .ignoresSafeArea(edges: .all)
            
            LinearGradient(
                colors: [.black, .purple, .black,.green],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()


            // Everything for the journal
           
                
                VStack(spacing: 30) {

                    // ✅ Title above the calendar
                    Text("Calendar")
//                        .font(.system(size: 36, weight: .bold))
                        .font(.custom("Sketch Block", size: 45))
                        .foregroundStyle(.white)
                        .padding(.bottom, 25)

                header
                weekdayRow
                daysGrid
                Spacer()
            }
            .padding(.top, 140)
            .padding(.horizontal, 1)
            .foregroundStyle(.white)
        }
      
//        .safeAreaInset(edge: .bottom) {
//            bottomBar
//        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .sheet(isPresented: $isShowingJournal) {
            if let selectedDate {
                JournalSheet(
                    date: selectedDate,
                    text: $journalText
                ) {
                    journalStore.setText(journalText, for: selectedDate)
                }
            }
        }
    }

    // Chevrons
    private var header: some View {
        HStack {
            Button { changeMonth(by: -1) } label: {
                Image(systemName: "chevron.left")
                    .font(.title3)
            }
            .padding(.horizontal)

            Spacer()

            Text(monthFormatter.string(from: displayedMonth))
                .font(.title)
                .bold()

            Spacer()

            Button { changeMonth(by: 1) } label: {
                Image(systemName: "chevron.right")
                    .font(.title3)
            }
            .padding(.horizontal)
        }
    }

    // Body of the calendar
    private var weekdayRow: some View {
        HStack {
            ForEach(weekdaySymbols, id: \.self) { symbol in
                Text(symbol)
                    .font(.subheadline)
                    .bold()
                    .frame(maxWidth: .infinity)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal)
    }

    private var daysGrid: some View {
        LazyVGrid(
            columns: Array(repeating: GridItem(.flexible(), spacing: 0), count: 7),
            spacing: 12
        ) {
            ForEach(daysInDisplayedMonth.indices, id: \.self) { index in
                if let date = daysInDisplayedMonth[index] {
                    dayCell(for: date)
                } else {
                    // empty slot
                    Rectangle()
                        .opacity(0)
                        .frame(height: 40)
                }
            }
        }
        .padding(.horizontal)
    }
    

    // Calendar day cell
    private func dayCell(for date: Date) -> some View {
        let isToday = calendar.isDateInToday(date)
        let isSelected = selectedDate.map { calendar.isDate($0, inSameDayAs: date) } ?? false
        let hasJournal = journalStore.hasEntry(for: date)

        return Button {
            selectedDate = date
            journalText = journalStore.text(for: date)   // load saved entry if it exists
            isShowingJournal = true                      // open the sheet
        } label: {
            VStack(spacing: 4) {
                Text("\(calendar.component(.day, from: date))")
                    .font(.body)
                    .bold()
                    .foregroundStyle(.white)
                    .frame(height: 40)
                    .padding(4)
                    .background(
                        Circle()
                            .foregroundStyle(
                                isSelected ? Color.pink.opacity(0.6) :
                                (isToday ? Color.pink.opacity(0.3) : Color.clear)
                            )
                    )

                // The dot when a journal entry is entered
                if hasJournal {
                    Circle()
                        .frame(width: 4, height: 4)
                        .foregroundStyle(.pink)
                } else {
                    Color.clear.frame(height: 4)
                }
            }
        }
        .buttonStyle(.plain)
    }

    // Bottom Navigation Bar
//    private var bottomBar: some View {
//        HStack(spacing: 25) {
//            Button { selection = .home } label: {
//                VStack {
//                    Image(systemName: "house.fill")
//                    Text("Home")
//                        .font(.caption)
//                        .opacity(0.9)
//                }
//            }
//            .buttonStyle(.plain)
//            .foregroundStyle(selection == .home ? .white : .white.opacity(0.9))
//
//            Button { selection = .commitment } label: {
//                VStack {
//                    Image(systemName: "ring.dashed")
//                    Text("Commitment")
//                        .font(.caption)
//                        .opacity(0.9)
//                }
//            }
//            .buttonStyle(.plain)
//            .foregroundStyle(selection == .commitment ? .white : .white.opacity(0.9))
//
//            Button { selection = .calendar } label: {
//                VStack {
//                    Image(systemName: "calendar")
//                    Text("Calendar")
//                        .font(.caption)
//                        .opacity(0.9)
//                }
//            }
//            .buttonStyle(.plain)
//            .foregroundStyle(selection == .calendar ? .white : .white.opacity(0.9))
//
//            Button { selection = .journal } label: {
//                VStack {
//                    Image(systemName: "pencil.and.scribble")
//                    Text("Journal")
//                        .font(.caption)
//                        .opacity(0.9)
//                }
//            }
//            .buttonStyle(.plain)
//            .foregroundStyle(selection == .journal ? .white : .white.opacity(0.9))
//
//            Button { selection = .selfCare } label: {
//                VStack {
//                    Image(systemName: "person.fill")
//                    Text("Self Care")
//                        .font(.caption)
//                        .opacity(0.9)
//                }
//            }
//            .buttonStyle(.plain)
//            .foregroundStyle(selection == .selfCare ? .white : .white.opacity(0.9))
//        }
//        .font(.title2)
//        .frame(maxWidth: .infinity)
//        .padding(.vertical, 10)
//        .padding(.horizontal)
//        .background(
//            ZStack {
//                LinearGradient(
//                    colors: [
//                        .purple.opacity(0.25),
//                        .black.opacity(0.7)
//                    ],
//                    startPoint: .top,
//                    endPoint: .bottom
//                )
//                .ignoresSafeArea(edges: .bottom)
//
//                Color.black.background(.ultraThinMaterial.opacity(0.1))
//            }
//        )
//        .foregroundStyle(.white)
//    }

    // Calendar Logic
    private func changeMonth(by value: Int) {
        if let newMonth = calendar.date(byAdding: .month, value: value, to: displayedMonth) {
            displayedMonth = newMonth
        }
    }

    private func makeDaysForMonth() -> [Date?] {
        guard let monthInterval = calendar.dateInterval(of: .month, for: displayedMonth),
              let firstDayOfMonth = calendar.date(
                from: calendar.dateComponents([.year, .month], from: displayedMonth)
              )
        else {
            return Array(repeating: nil, count: 42)
        }

        // 1 = Sun ... 7 = Sat
        let weekday = calendar.component(.weekday, from: firstDayOfMonth)
        let firstWeekdayIndex = (weekday - 1 + 7) % 7   // Sun -> 0

        var cells: [Date?] = Array(repeating: nil, count: firstWeekdayIndex)

        var current = monthInterval.start
        while current < monthInterval.end {
            cells.append(current)
            current = calendar.date(byAdding: .day, value: 1, to: current)!
        }

        if cells.count < 42 {
            cells.append(contentsOf: Array(repeating: nil, count: 42 - cells.count))
        } else if cells.count > 42 {
            cells = Array(cells.prefix(42))
        }

        return cells
    }
}

#Preview {
    GalaxyCalendarScreen()
}



#Preview {
    GalaxyCalendarScreen()
}
