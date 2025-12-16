import SwiftUI
import Foundation

struct JournalSheet: View {
    let date: Date
    @Binding var text: String
    var onSave: () -> Void

    @Environment(\.dismiss) private var dismiss

    private let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateStyle = .full
        return df
    }()
    @FocusState private var isFocused: Bool
    private let glowColor: Color = .green
    
    var body: some View {
        NavigationStack {
            ZStack{
                LinearGradient(
                    colors: [.purple, .black, .green],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea(edges: .all)
            
            VStack(alignment: .leading, spacing: 16) {
                Text("How are you feeling today?")
//                    .font(.headline)
                    .font(.custom("Sketch Block", size: 35))
                    .foregroundColor(Color(.white))
                    .multilineTextAlignment(.center)
                    .offset(x:50, y: 0)

                TextEditor(text: $text)
                    .frame(minHeight: 200)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color(.green).opacity(0.3), lineWidth: 5)
                        
                        //glow
//                            .overlay(
//                                RoundedRectangle,
//                                (cornerRadius: 10)
//                                ignoresSafeAreaEdges:
//                                    .stroke(isFocused ? glowColor : Color.green, lineWidth: 2)
//                            )
                    )
                    .padding(8)
//                    .background(Color(.green))
                    .cornerRadius(10)

                Spacer()
            }
            .padding()
            .navigationTitle(dateFormatter.string(from: date))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") {
                        dismiss()
                    }
                    .tint(Color(.white))
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        onSave()
                        dismiss()
                    }
                    .tint(.white)
                }
            }
        }
        
    }
}
}
struct JournalSheet_Previews: PreviewProvider {
    static var previews: some View {
        JournalSheet(date: Date(), text: .constant(""), onSave: {})
    }
}
