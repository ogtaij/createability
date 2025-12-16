//
//  ReplayStackView.swift
//  Creatability Version 2
//
//  Created by Taijah Johnson on 12/3/25.
//

import SwiftUI

struct ReplayStackView: View {
    let cards: [ReplayCard]
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                
                //Background
                LinearGradient(
                    colors: [.purple, .black, .green],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea(.all)
                
                ScrollView {
                Text("\nSelf Care")
                    .font(.custom("Sketch Block", size: 45))
                    .foregroundColor(.white)
                          
                          
                          //                        .foregroundStyle(.white)
                          //                        .padding(.top, 40)
                          //                        .padding(.bottom, 10)
                          
                          
                        VStack(spacing: 40) {
                            ForEach(cards) { card in
                                GeometryReader { geo in
                                    let minY = geo.frame(in: .global).minY
                                    let scale = max(0.85, 1 - (minY / 1000))
                                    let offset = minY / -6
                                    
                                    
                                    
                                    NavigationLink {
                                        destinationView(for: card)
                                    } label: {
                                        ReplayCardView(card: card)
                                            .scaleEffect(scale)
                                            .offset(y: offset)
                                            .animation(.easeOut(duration: 0.25), value: scale)
                                    }
                                    .buttonStyle(.plain)
                                }
                                .frame(height: 350)
                            }
                        }
                        //.padding(.top, 130)
                        //.padding(.bottom, 300)
                    }
                    
            }
        }
    }
    
    
    @ViewBuilder
    private func destinationView(for card: ReplayCard) -> some View {
        switch card.title {
        case "Affirmations":
            AffirmationsView()
        case "Stretches":
            StretchesView()
        case "Breath Work":
            BreathWorkView()
        default:
            Text(card.title)
        }
    }
}


#Preview {
    NavigationStack {
        ReplayStackView(cards: [
            ReplayCard(title: "Affirmations",
                       subtitle: "Recieve Daily Affirmations",
                       imageName: "affirmationimage2"),
            ReplayCard(title: "Stretches",
                       subtitle: "Suggested stretches to minimize tension",
                       imageName: "stretchimage2"),
            ReplayCard(title: "Breath Work",
                       subtitle: "Deep breathing to calm your nervous system",
                       imageName: "breatheimage2")
        ])
    }
}

