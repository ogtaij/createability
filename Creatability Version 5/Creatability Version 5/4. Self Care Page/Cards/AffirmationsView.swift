//
//  Affirmations.swift
//  Creatability Version 2
//
//  Created by Rhonda Davis on 12/5/25.
//

import SwiftUI


struct AffirmationsView: View {
//Affirmations
    private let affirmations = [
        "I am safe, I am enough, and I deserve peace.",
        "My feelings are valid, and I honor them with kindness.",
        "I am learning to care for my mind, body, and spirit.",
        "I don’t have to be perfect to be worthy of rest.",
        "I am allowed to take up space and set boundaries.",
        "Every small step I take still counts as progress."
    ]

//Pick an affirmation-Based on the date
    private var todayAffirmation: String {
        let dayOfYear = Calendar.current.ordinality(of: .day, in: .year, for: Date()) ?? 1
        let index = dayOfYear % affirmations.count
        return affirmations[index]
    }

    @State private var extraAffirmation: String? = nil

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [.purple, .black, .green],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 24) {
                Text("\nAffirmations")
//                    .font(.system(size: 34, weight: .bold))
                    .font(.custom("Sketch Block", size: 35))
                    .foregroundStyle(.white)

                Text("\nHere is your affirmation for today:\n")
//                    .font(.headline)
                    .font(.system(size: 25, weight: .bold))
                    .foregroundStyle(.white.opacity(0.9))
                    .multilineTextAlignment(.center)

                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.white.opacity(0.12))
                    .overlay(
                        Text(todayAffirmation)
                            .foregroundStyle(.white)
                            .multilineTextAlignment(.center)
                            .padding()
                            .bold()
                    )
                    .frame(height: 180)

                if let extra = extraAffirmation {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.white.opacity(0.08))
                        .overlay(
                            Text(extra)
                                .foregroundStyle(.white)
                                .multilineTextAlignment(.center)
                                .padding()
                                .bold()
                        )
                        .transition(.opacity.combined(with: .scale))
                }

                Button("New affirmation") {
//Random affirmations
                    let others = affirmations.filter { $0 != todayAffirmation }
                    extraAffirmation = others.randomElement()
                }
                .padding(.top, 2)
                .padding(.horizontal, 24)
                .padding(.vertical, 10)
//                .background(Color.white.opacity(0.18))
                .background(
                    AnimatedMeshGradient())
                .clipShape(Capsule())
                .foregroundStyle(.white)
                .bold()
                

                Spacer()
            }
            .padding()
        }
    }
}



#Preview {
    NavigationStack {
        AffirmationsView()
    }
}
