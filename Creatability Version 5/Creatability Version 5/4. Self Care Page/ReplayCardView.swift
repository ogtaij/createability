//
//  ReplayCardView.swift
//  Creatability Version 2
//
//  Created by Taijah Johnson on 12/3/25.
//

import SwiftUI

struct ReplayCardView: View {
    let card: ReplayCard
    
    var body: some View {
        ZStack {
            
        //Card background settings
            RoundedRectangle(cornerRadius: 32)
                .fill(.black.opacity(0.70))
                .shadow(radius: 10)

            VStack(alignment: .leading, spacing: 12) {
                Image(card.imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 220)
                    .clipped()
                    .cornerRadius(20)

                Text(card.title)
                    .font(.title2.bold())
                    .foregroundColor(.white)

                Text(card.subtitle)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .foregroundColor(.white)
                    .bold()

                Spacer()
            }
            .padding()
        }
        
        .overlay(
                    RoundedRectangle(cornerRadius: 32)
                        .stroke(Color.green, lineWidth: 1.5)
                        .shadow(color: Color.green.opacity(0.8), radius: 8)
                        .shadow(color: Color.green.opacity(0.4), radius: 16)
                )
    }
}
//
//#Preview {
//    ReplayCardView(card: ReplayCard(title: "Affirmations", subtitle: "Recieve Daily Affirmations", imageName: "example1"))
//}

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
