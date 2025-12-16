import SwiftUI

// Emoji setup
enum Mood: String, CaseIterable, Identifiable {
    case depressed
    case sad
    case angry
    case neutral
    case happy
    case overjoyed

    var id: String { rawValue }

    var emoji: String {
        switch self {
        case .depressed: return "😵‍💫"
        case .sad:       return "☹️"
        case .angry:     return "😠"
        case .neutral:   return "😐"
        case .happy:     return "😊"
        case .overjoyed: return "🥰"
        }
    }

    var description: String {
        switch self {
        case .depressed: return "I feel depressed"
        case .sad:       return "I feel sad"
        case .angry:     return "I feel angry"
        case .neutral:   return "I feel neutral"
        case .happy:     return "I feel happy"
        case .overjoyed: return "I feel overjoyed"
        }
    }
}

struct MoodCheckInView: View {

    enum Section: Hashable {
        case home, commitment, calendar, journal, selfCare
    }

    @State private var selection: Section = .home
    @State private var selectedMood: Mood = .neutral
    @State private var name: String = ""
    @State private var isSpinningGear = false
    @State private var isShowingHoroscopeSheet = false

//For horoscope
    @State private var horoscopeMessage: String = ""
    @State private var isLoadingHoroscope = false
    @State private var horoscopeError: String?

    private var displayName: String { name.isEmpty ? "Raven" : name }

    var body: some View {
        NavigationStack {
            ZStack(alignment: .topLeading) {
//                Image("galaxy")
//                    .resizable()
//                    .scaledToFill()
//                    .ignoresSafeArea()
//
//                LinearGradient(
//                    colors:
//                        [
//                        Color.black.opacity(0.55),
//                        Color.purple.opacity(0.55)
//                    ],
//               [.purple, .black, .green]
//                    startPoint: .top,
//                    endPoint: .bottom)
                
                
                LinearGradient(
                    colors: [
                        Color.black.opacity(1),
                        Color.black.opacity(1),
                        Color.purple.opacity(1),
                        Color.black.opacity(1),
                        Color.green.opacity(1)],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                                

//Name
                VStack(spacing: 0) {
                    VStack(spacing: 20) {
                        VStack(alignment: .center, spacing: 16) {
                            Text("\nHello \(displayName),")
//                                .font(.system(size: 35, weight: .bold))
                                .font(.custom("Sketch Block", size: 35))
                                .foregroundStyle(.white)
                                .fixedSize(horizontal: false, vertical: true)

                            VStack(alignment: .center, spacing: 12) {
                                TextField("", text: $name)
                                    .textFieldStyle(.plain)
                                    .foregroundColor(.white)
                                    .font(.system(size: 24, weight: .semibold))
                                    .disableAutocorrection(true)
                                    .textInputAutocapitalization(.words)

                                Text("Tell me how you're feeling today")
//                                    .font(.system(size: 30, weight: .bold))
                                    .font(.custom("Sketch Block", size: 35))
                                    .multilineTextAlignment(.center)
                                    .fixedSize(horizontal: false, vertical: true)
                                    .foregroundStyle(.white)
//                                    .frame(maxWidth: .infinity, alignment: .center)
                                    .lineLimit(nil)
                                    
                            }
                        }
                    }
//                    .padding(.top, 90)
//                    .padding(.horizontal, 60)

                    Spacer(minLength: 0)

//Zigzag
                    VStack {
                        HStack(spacing: 80) {
                            Image("zigzag")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 75)
                                .padding(.top, 60)
                                .offset(y: -40)
                        }
                    }
//                    .padding(.horizontal, 70)

                    Spacer().frame(height: 10)

//Big Emoji
                    VStack(spacing: 25) {
                        VStack(spacing: 12) {
                            Text(selectedMood.emoji)
                                .font(.system(size: 150))
                            Text(selectedMood.description)
                                .font(.title2)
                                .foregroundStyle(.white)
                                .bold()
                        }
//Small Emoji's
                        HStack(spacing: 10) {
                            ForEach(Mood.allCases) { mood in
                                Button {
                                    selectedMood = mood
                                } label: {
                                    Text(mood.emoji)
                                        .font(.title)
                                        .padding(10)
                                        .background(
                                            Circle()
                                                .fill(selectedMood == mood ?
                                                      Color.white.opacity(0.2) :
                                                      Color.clear)
                                        )
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.white.opacity(0.08))
                        )
                        .padding(.horizontal, 24)

//Horoscope
                        if isLoadingHoroscope {
                            ProgressView("Updating your stars…")
                                .tint(.white)
                                .foregroundStyle(.white)
                                .padding(.top, 8)
                        } else if let error = horoscopeError {
                            Text(error)
                                .font(.footnote)
                                .foregroundStyle(.red.opacity(0.8))
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 24)
                                .padding(.top, 4)
                        }
                    }
                    .padding(.top, 1)
                    .padding(.bottom, 60)
                    .padding(.bottom, -10)
                }
            }
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
                        isShowingHoroscopeSheet = true
                    } label: {
                        Image("cancerImage")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 60, height: 40)
                    }
                }
            }

//Navigation bar
//            .safeAreaInset(edge: .bottom) {
//                HStack(spacing: 25) {
//                    Button {
//                        selection = .home
//                    } label: {
//                        VStack {
//                            Image(systemName: "house.fill")
//                            Text("Home")
//                                .font(.caption)
//                                .opacity(0.9)
//                        }
//                    }
//                    .buttonStyle(.plain)
//                    .foregroundStyle(selection == .home ? .white : .white.opacity(0.9))
//
//                    Button {
//                        selection = .commitment
//                    } label: {
//                        VStack {
//                            Image(systemName: "ring.dashed")
//                            Text("Commitment")
//                                .font(.caption)
//                                .opacity(0.9)
//                        }
//                    }
//                    .buttonStyle(.plain)
//                    .foregroundStyle(selection == .commitment ? .white : .white.opacity(0.9))
//
//                    Button {
//                        selection = .calendar
//                    } label: {
//                        VStack {
//                            Image(systemName: "calendar")
//                            Text("Calendar")
//                                .font(.caption)
//                                .opacity(0.9)
//                        }
//                    }
//                    .buttonStyle(.plain)
//                    .foregroundStyle(selection == .calendar ? .white : .white.opacity(0.9))
//
//                    Button {
//                        selection = .journal
//                    } label: {
//                        VStack {
//                            Image(systemName: "pencil.and.scribble")
//                            Text("Journal")
//                                .font(.caption)
//                                .opacity(0.9)
//                        }
//                    }
//                    .buttonStyle(.plain)
//                    .foregroundStyle(selection == .journal ? .white : .white.opacity(0.9))
//
//                    Button {
//                        selection = .selfCare
//                    } label: {
//                        VStack {
//                            Image(systemName: "person.fill")
//                            Text("Self Care")
//                                .font(.caption)
//                                .opacity(0.9)
//                        }
//                    }
//                    .buttonStyle(.plain)
//                    .foregroundStyle(selection == .selfCare ? .white : .white.opacity(0.9))
//                }
//                .font(.title2)
//                .frame(maxWidth: .infinity)
//                .padding(.vertical, 10)
//                .padding(.horizontal)
//                .background(.ultraThinMaterial.opacity(0.5))
//                .foregroundStyle(.white)
//            }

//Horoscope Sheet
            .sheet(isPresented: $isShowingHoroscopeSheet) {
                HoroscopeSheetView(
                    sign: "Cancer",
                    message: horoscopeMessage.isEmpty
                        ? HoroscopeGenerator.cancerHoroscope(for: Date(), mood: selectedMood)
                        : horoscopeMessage
                )
            }

//Mood changing horoscope
            .task {
                await loadHoroscope()
            }
            .task(id: selectedMood) {
                await loadHoroscope()
            }

            .onAppear {
                withAnimation(.linear(duration: 6).repeatForever(autoreverses: false)) {
                    isSpinningGear = true
                }
            }
        }
    }

    @MainActor
    private func loadHoroscope() async {
        isLoadingHoroscope = true
        horoscopeError = nil

        do {
            let text = try await HoroscopeAPI.shared.fetchHoroscope(
                sign: "Cancer",
                mood: selectedMood
            )
            horoscopeMessage = text
        } catch {
            // Fallback: use local generator
            horoscopeMessage = HoroscopeGenerator.cancerHoroscope(
                for: Date(),
                mood: selectedMood
            )
           
        }

        isLoadingHoroscope = false
    }
}

#Preview {
    NavigationStack {
        MoodCheckInView()
    }
}
