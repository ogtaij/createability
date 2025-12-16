//
//  Stretches.swift
//  Creatability Version 2
//
//  Created by Rhonda Davis on 12/5/25.
//


import SwiftUI
internal import Combine

//A model for each stretch 
struct Stretch: Identifiable, Equatable {
    let id = UUID()
    let name: String
    let description: String
    let durationSeconds: Int
}

struct StretchesView: View {
//Some basic stretches - you can change later
    private let stretches: [Stretch] = [
        Stretch(
            name: "Neck Roll",
            description: "Gently roll your head in a slow circle, switching directions halfway.",
            durationSeconds: 30
        ),
        Stretch(
            name: "Shoulder Rolls",
            description: "Roll your shoulders up, back, and down to release desk tension.",
            durationSeconds: 45
        ),
        Stretch(
            name: "Seated Forward Fold",
            description: "From a seated position, gently fold forward and let your arms hang.",
            durationSeconds: 60
        )
    ]
    
    @State private var selectedStretch: Stretch? = nil
    @State private var remainingSeconds: Int = 0
    @State private var isTimerActive: Bool = false
    
// A 1-second ticking timer
    @State private var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [.purple, .black, .green],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 24) {
                Text("\nStretches")
//                    .font(.system(size: 34, weight: .bold))
                    .font(.custom("Sketch Block", size: 35))
                    .foregroundStyle(.white)

                Text("\nChoose a stretch and use the timer to release tension in your body\n")
                    .font(.system(size: 25, weight: .bold))
                    .bold()
                    .foregroundStyle(.white.opacity(0.8))
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.horizontal)

//Active stretch and timer
                if let stretch = selectedStretch {
                    VStack(spacing: 12) {
                        Text(stretch.name)
                            .font(.title2.bold())
                            .foregroundStyle(.white)
                            .fixedSize(horizontal: false, vertical: true)

                        Text(stretch.description)
                            .font(.subheadline)
                            .foregroundStyle(.white.opacity(0.8))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                            .fixedSize(horizontal: false, vertical: true)
                            

//Timer display
                        Text(formattedTime(remainingSeconds))
                            .font(.system(size: 40, weight: .bold, design: .monospaced))
                            .foregroundStyle(.white)
                            .padding(.top, 8)

                        HStack(spacing: 16) {
                            Button(isTimerActive ? "Pause" : "Start") {
                                if remainingSeconds == 0 {
                                    remainingSeconds = stretch.durationSeconds
                                }
                                isTimerActive.toggle()
                            }
                            .padding(.horizontal, 24)
                            .padding(.vertical, 10)
//                            .background(Color.white.opacity(0.2))
                            .background(
                                AnimatedMeshGradient())
                            .clipShape(Capsule())
                            .foregroundStyle(.white)
                            .bold()
                            .clipShape(Capsule())
                            .foregroundStyle(.white)

                            Button("Reset") {
                                isTimerActive = false
                                remainingSeconds = stretch.durationSeconds
                            }
                            
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
//                            .background(Color.white.opacity(0.15))
                            .background(
                                AnimatedMeshGradient())
                            .clipShape(Capsule())
                            .foregroundStyle(.white)
                            .bold()
                            
                        }
                        .padding(.top, 4)
                    }
                    .padding()
                    .background(Color.white.opacity(0.08))
                    .cornerRadius(20)
                    .padding(.horizontal)
                    .transition(.opacity.combined(with: .move(edge: .top)))
                }

//List of stretches
                VStack(alignment: .leading, spacing: 16) {
                    Text("Pick a stretch:")
//                        .font(.headline)
                        .font(.system(size: 20, weight: .bold))
                        .foregroundStyle(.white.opacity(0.9))
                        .frame(maxWidth: .infinity, alignment: .leading)

                    ForEach(stretches) { stretch in
                        Button {
                            withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                                selectedStretch = stretch
                                remainingSeconds = stretch.durationSeconds
                                isTimerActive = false
                            }
                        } label: {
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(stretch.name)
                                        .font(.system(size: 18, weight: .semibold))
                                        .foregroundStyle(.white)

                                    Text("\(stretch.durationSeconds) seconds")
                                        .font(.system(size: 14))
                                        .foregroundStyle(.white.opacity(0.85))
                                }

                                Spacer()

                                if selectedStretch == stretch {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundStyle(.green.opacity(0.9))
                                }
                            }
                            .padding()
                            .background(Color.white.opacity(0.08))
                            .cornerRadius(14)
                        }
                        .buttonStyle(.plain)
                    }
                    .foregroundStyle(.white)

                    
                }
                .padding(.horizontal)

                Spacer()
            }
            .padding(.top)
        }
        
        .onReceive(timer) { _ in
            if isTimerActive && remainingSeconds > 0 {
                remainingSeconds -= 1
                if remainingSeconds == 0 {
                    isTimerActive = false
                }
            }
        }
    }

    private func formattedTime(_ seconds: Int) -> String {
        let m = seconds / 60
        let s = seconds % 60
        return String(format: "%02d:%02d", m, s)
    }
}

#Preview {
    NavigationStack {
        StretchesView()
    }
}
