//
//  BreathWorks.swift
//  Creatability Version 2
//
//  Created by Rhonda Davis on 12/5/25.
//

import SwiftUI
internal import Combine

struct BreathWorkView: View {
    enum Phase: String {
        case inhale = "Inhale"
        case hold = "Hold"
        case exhale = "Exhale"
    }

//How long the phase last per seconds
    private let phaseDurations: [Phase: Int] = [
        .inhale: 4,
        .hold: 4,
        .exhale: 6
    ]

    @State private var currentPhase: Phase? = nil
    @State private var remainingSeconds: Int = 0
    @State private var isRunning: Bool = false
    @State private var completedCycles: Int = 0

//Ticking timer (seconds)
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
                Text("\nBreath Work")
//                    .font(.system(size: 34, weight: .bold))
                    .font(.custom("Sketch Block", size: 35))
                    .foregroundStyle(.white)

                Text("\nFollow this gentle 4–4–6 breathing pattern to calm your nervous system\n")
//                    .font(.body)
                    .font(.system(size: 25, weight: .bold))
                    .bold()
                    .foregroundStyle(.white.opacity(0.8))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)

//Phase and timer
                VStack(spacing: 12) {
                    Text(currentPhase?.rawValue ?? "Ready")
                        .font(.title.bold())
                        .foregroundStyle(.white)

                    Text(phaseInstructionText)
                        .font(.subheadline)
                        .bold()
                        .foregroundStyle(.white.opacity(0.8))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)

                    Text(formattedTime(remainingSeconds))
                        .font(.system(size: 44, weight: .bold, design: .monospaced))
                        .foregroundStyle(.white)
                        .padding(.top, 8)
                }
                .padding()
                .background(Color.white.opacity(0.08))
                .cornerRadius(20)
                .padding(.horizontal)

//Cycle count
                if completedCycles > 0 {
                    Text("Cycles completed: \(completedCycles)")
                        .font(.footnote)
                        .foregroundStyle(.white.opacity(0.8))
                }

//Controll
                HStack(spacing: 16) {
                    Button(isRunning ? "Pause" : "Start") {
                        if !isRunning {
//If not running, resume or start fresh 
                            if currentPhase == nil {
                                startNewCycle()
                            }
                        }
                        isRunning.toggle()
                    }
                    .padding(.horizontal, 30)
                    .padding(.vertical, 12)
//                    .background(Color.white.opacity(0.22))
                    .background(
                        AnimatedMeshGradient())
                    .clipShape(Capsule())
                    .foregroundStyle(.white)
                    .bold()
                    

                    Button("Reset") {
                        resetBreathing()
                    }
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
//                    .background(Color.white.opacity(0.16))
                    .background(
                        AnimatedMeshGradient())
                    .clipShape(Capsule())
                    .foregroundStyle(.white)
                    .bold()
                    
                }
                .padding(.top, 8)

                Spacer()
            }
            .padding(.top)
        }
        
        .onReceive(timer) { _ in
            guard isRunning else { return }
            guard remainingSeconds > 0 else {
                advancePhase()
                return
            }
            remainingSeconds -= 1
        }
    }

//Helpers

    private var phaseInstructionText: String {
        switch currentPhase {
        case .inhale:
            return "Breathe in slowly through your nose."
        case .hold:
            return "Hold your breath gently."
        case .exhale:
            return "Exhale slowly through your mouth."
        case .none:
            return "Tap Start to begin: Inhale 4 • Hold 4 • Exhale 6."
        }
    }
    

    private func startNewCycle() {
        currentPhase = .inhale
        remainingSeconds = phaseDurations[.inhale] ?? 4
    }

    private func advancePhase() {
        guard let phase = currentPhase else {
            startNewCycle()
            return
        }

        switch phase {
        case .inhale:
            currentPhase = .hold
            remainingSeconds = phaseDurations[ .hold ] ?? 4
        case .hold:
            currentPhase = .exhale
            remainingSeconds = phaseDurations[ .exhale ] ?? 6
        case .exhale:
// Completed one full inhale–hold–exhale cycle
            completedCycles += 1
            currentPhase = .inhale
            remainingSeconds = phaseDurations[ .inhale ] ?? 4
        }
    }

    private func resetBreathing() {
        isRunning = false
        currentPhase = nil
        remainingSeconds = 0
        completedCycles = 0
    }

    private func formattedTime(_ seconds: Int) -> String {
        let m = seconds / 60
        let s = seconds % 60
        return String(format: "%02d:%02d", m, s)
    }
}

#Preview {
    NavigationStack {
        BreathWorkView()
    }
}

