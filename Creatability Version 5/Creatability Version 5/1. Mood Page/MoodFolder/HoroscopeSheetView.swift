//
//  HoroscopeSheetView.swift
//  PracticingXcode
//
//  Created by Rhonda Davis on 12/4/25.
//

import SwiftUI

struct HoroscopeSheetView: View {
    let sign: String
    let message: String

    private let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateStyle = .full
        return df
    }()

    var body: some View {
        NavigationStack {
            
            ZStack {
                
                LinearGradient(
                    colors: [.purple, .black, .green],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                
                VStack(alignment: .leading, spacing: 20) {
                    Text("Today’s Horoscope")
//                        .font(.title2.bold())
                        .font(.custom("Sketch Block", size: 35))
                        .foregroundStyle(.white)
                        .multilineTextAlignment(.center)
                    
                    Text(sign)
//                        .font(.title3)
//                        .foregroundStyle(.purple.opacity(0.8))
                        .font(.system(size: 25, weight: .bold))
                        .bold()
                        .foregroundStyle(.green.opacity(0.8))
                        .multilineTextAlignment(.center)

                    
                    Text(dateFormatter.string(from: Date()))
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .font(.system(size: 20, weight: .bold))
                        .bold()
                        .foregroundStyle(.white.opacity(0.7))
                        .multilineTextAlignment(.center)
                    
                    Divider()
                    
                    Text(message)
//                        .font(.body)
//                        .padding(.top, 4)
                        .font(.system(size: 25, weight: .bold))
                        .bold()
                        .foregroundStyle(.white.opacity(0.9))
                        .multilineTextAlignment(.center)
                    
                    Spacer()
                }
                .padding()
                .navigationTitle("Your Stars ✨")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Close") {
                            // the sheet dismisses automatically with .dismiss()
                            // but here we can use the environment dismiss:
                            dismiss()
                        }
//                        .tint(.white)
                        .bold()
//                        .background(Color.white.opacity(0.2))
                        .clipShape(Capsule())
                        .foregroundStyle(.white)
                    }
                }
            }
        }
    }
    @Environment(\.dismiss) private var dismiss
}

#Preview {
    NavigationStack {
        HoroscopeSheetView(sign: "Cancer", message: "Testtttttkjdfznbgvnzdflbkjnzd;kfjbnv;lkszd;flvnzd;fjlbn;vzaejdkfbndzsfmjgv;lzdvkjfng;dz;alkfgn;zdfnb'locnb ;zndfb;nsa'drokgldfrzngb;lzdfjcknbd;lfkxbn;dfzjcbhd;ofzlkhcHoroscopeSheetViewn;bl")
    }
}
