//
//  CommitmentsPage.swift
//  Creatability
//
//  Created by Taijah Johnson on 11/26/25.
//

import SwiftUI

// MODELS

struct Subtask: Identifiable, Hashable {
    let id = UUID()
    var title: String
    var isDone: Bool = false
}


struct Commitment: Identifiable, Hashable {
    let id = UUID()
    var title: String
    var subtasks: [Subtask]

    var progress: Double {
        if subtasks.isEmpty { return 0 }
        let done = subtasks.filter { $0.isDone }.count
        return Double(done) / Double(subtasks.count)
    }
}




// MAIN COMMITMENT PAGE

struct CommitmentsPage: View {

    @State private var commitments: [Commitment] = [
        
        // DEFAULT SAMPLE DATA
        Commitment(
            title: "Gym Routine",
            subtasks: [
                Subtask(title: "Warm-up 10 min", isDone: true),
                Subtask(title: "Upper-body workout"),
                Subtask(title: "Stretch before leaving")
            ]
        ),

        Commitment(
            title: "Study Session",
            subtasks: [
                Subtask(title: "Review lecture notes"),
                Subtask(title: "Complete homework", isDone: true),
                Subtask(title: "Practice problems")
            ]
        ),

        Commitment(
            title: "Self Care",
            subtasks: [
                Subtask(title: "Drink 2 bottles of water"),
                Subtask(title: "Journal for 5 minutes", isDone: true),
                Subtask(title: "Meditate before bed")
            ]
        )
    ]

    @State private var showAddCommitment = false

    var body: some View {
        NavigationStack {
            ZStack {
                GalaxyBackground()

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 30) {

                        //  PROGRESS RINGS
                        RingsView(commitments: commitments)

                        //  BUTTONS
                        HStack {
                            Text("Commitments")
//                                .font(.largeTitle)
                                .font(.custom("Sketch Block", size: 35))
                                .bold()
                                .foregroundColor(.white)

                            Spacer()

                            Button {
                                showAddCommitment = true
                            } label: {
                                Text("Add +")
                                    .foregroundColor(.white)
                                    .padding(.vertical, 8)
                                    .padding(.horizontal, 12)
                                    .background(Color.green.opacity(0.8))
                                    .cornerRadius(10)
                            }
                        }
                        .padding(.horizontal)

                        // COMMITMENT CARDS LIST
                        VStack(spacing: 20) {
                            ForEach(commitments.indices, id: \.self) { i in
                                NavigationLink {
                                    CommitmentDetailView(commitment: $commitments[i])
                                } label: {
                                    CommitmentCard(commitment: commitments[i])
                                }
                            }
                        }

                        Spacer().frame(height: 80)
                    }
                }
            }
        }
        .sheet(isPresented: $showAddCommitment) {
            AddCommitmentView(commitments: $commitments)
        }
    }
}



// RINGS

struct RingsView: View {

    let commitments: [Commitment]

    var body: some View {
        ZStack {

            ForEach(commitments.indices, id: \.self) { i in

                // Dynamic ring sizes
                let size = CGFloat(250 - (i * 50)) // 250, 200, 150, ...

                // Dynamic color set
                let colors: [Color] = [.green, .purple, .white, .pink, .blue]
                let ringColor = colors[i % colors.count]

                ProgressRing(progress: commitments[i].progress,
                             color: ringColor,
                             size: size)
            }

            // Profile image centered
            Image("profilePic")
                .resizable()
                .frame(width: 65, height: 85)
                .clipShape(Circle())
                .shadow(radius: 10)
        }
        .padding(.top, 70)
    }
}



// DETAIL PAGE


struct CommitmentDetailView: View {

    @Binding var commitment: Commitment
    @State private var showAddSubtask = false

    var body: some View {
        ZStack {
            GalaxyBackground()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 30) {

                    // HEADER
                    HStack {
                        Text(commitment.title)
                            .font(.largeTitle)
                            .bold()
                            .foregroundColor(.white)

                        Spacer()

                        ProgressRing(
                            progress: commitment.progress,
                            color: .white,
                            size: 70
                        )
                    }
                    .padding(.horizontal)
                    .padding(.top, 40)

                    // SUBTASKS
                    VStack(spacing: 25) {
                        ForEach(commitment.subtasks.indices, id: \.self) { i in
                            HStack(spacing: 15) {

                                // TIMELINE DOT
                                VStack {
                                    Circle()
                                        .fill(commitment.subtasks[i].isDone ? .green : .red)
                                        .frame(width: 12, height: 12)

                                    if i < commitment.subtasks.count - 1 {
                                        Rectangle()
                                            .fill(Color.white.opacity(0.4))
                                            .frame(width: 2, height: 40)
                                    }
                                }

                                // SUBTASK CARD
                                HStack {
                                    Text(commitment.subtasks[i].title)
                                        .foregroundColor(.white)

                                    Spacer()

                                    Button {
                                        commitment.subtasks[i].isDone.toggle()
                                    } label: {
                                        Circle()
                                            .stroke(.white, lineWidth: 4)
                                            .frame(width: 35, height: 35)
                                            .overlay(
                                                Circle()
                                                    .fill(commitment.subtasks[i].isDone ? .green : .clear)
                                                    .frame(width: 20, height: 20)
                                            )
                                    }
                                }
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 25)
                                        .fill(Color.white.opacity(0.05))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 25)
                                                .stroke(Color.green, lineWidth: 2)
                                        )
                                )
                            }
                            .padding(.horizontal)
                        }
                    }

                    // ADD SUBTASK BUTTON
                    Button {
                        showAddSubtask = true
                    } label: {
                        Text("➕ Add Subtask")
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.green.opacity(0.8))
                            .cornerRadius(15)
                            .padding(.horizontal)
                    }
                    .sheet(isPresented: $showAddSubtask) {
                        AddSubtaskView(commitment: $commitment)
                    }

                    Spacer().frame(height: 120)
                }
            }
        }
    }
}



// ADDING COMMITMENT SHEET


struct AddCommitmentView: View {

    @Binding var commitments: [Commitment]
    @Environment(\.dismiss) var dismiss

    @State private var title = ""

    var body: some View {
        NavigationStack {
            Form {
                TextField("Commitment title", text: $title)
            }
            .navigationTitle("New Commitment")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        commitments.append(Commitment(title: title, subtasks: []))
                        dismiss()
                    }
                    .disabled(title.isEmpty)
                }

                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
    }
}



//ADDING SUBTASK SHEET

struct AddSubtaskView: View {

    @Binding var commitment: Commitment
    @Environment(\.dismiss) var dismiss

    @State private var title = ""

    var body: some View {
        NavigationStack {
            
            Form {
                TextField("Subtask name", text: $title)
            }
            .navigationTitle("New Subtask")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        commitment.subtasks.append(Subtask(title: title))
                        dismiss()
                    }
                    .disabled(title.isEmpty)
                }

                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
    }
}




// COMPONENTS

struct ProgressRing: View {
    let progress: Double
    let color: Color
    let size: CGFloat

    var body: some View {
        Circle()
            .trim(from: 0, to: progress)
            .stroke(color,
                    style: StrokeStyle(lineWidth: 22,
                                       lineCap: .round))
            .rotationEffect(.degrees(-90))
            .frame(width: size, height: size)
            .animation(.easeInOut, value: progress)
    }
}

struct CommitmentCard: View {

    let commitment: Commitment

    var body: some View {
        HStack {
            Text(commitment.title)
                .foregroundColor(.white)
                .font(.title3)
                .fontWeight(.semibold)

            Spacer()

            ZStack {
                Circle()
                    .stroke(.white.opacity(0.25), lineWidth: 5)
                    .frame(width: 55, height: 55)

                Circle()
                    .trim(from: 0, to: commitment.progress)
                    .stroke(.white,
                            style: StrokeStyle(lineWidth: 5,
                                               lineCap: .round))
                    .rotationEffect(.degrees(-90))
                    .frame(width: 55, height: 55)

                Text("\(Int(commitment.progress * 100))%")
                    .foregroundColor(.white)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(.white.opacity(0.05))
                .overlay(
                    RoundedRectangle(cornerRadius: 25)
                        .stroke(.green, lineWidth: 1.5)
                )
        )
        .padding(.horizontal)
    }
}




//BACKGROUND

struct GalaxyBackground: View {
    var body: some View {
        ZStack {
        
             
            
            
//            // GRADIENT
//            LinearGradient(
//                colors: [
//                    Color.purple.opacity(0.90),
//                    Color.black.opacity(0.95)
//                ],
//                startPoint: .top,
//                endPoint: .bottom
//            )
//            .ignoresSafeArea()
//
//            
//
//            // DARK
//            LinearGradient(
//                colors: [
//                    Color.black.opacity(0.0),
//                    Color.black.opacity(0.6)
//                ],
//                startPoint: .center,
//                endPoint: .bottom
//            )
//            .ignoresSafeArea()
            LinearGradient(
                colors: [.purple, .black, .green],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

        }
    }
}

//Bottom Navigation Bar Struct

struct NavigationView: View {
    enum Section: Hashable {
        case home, commitment, calendar, journal, selfCare
    }
    
    @State private var selection: Section = .home
    
    
//Bottom Navigation Bar
    var body: some View {
       
        
        NavigationStack {
            
                    HStack(spacing: 25) {
                        Button {
                            selection = .home
                        } label: {
                            VStack {
                                Image(systemName: "house.fill")
                                Text("Home")
                                    .font(.caption)
                                    .opacity(0.9)
                            }
                        }
                        .buttonStyle(.plain)
                        .foregroundStyle(selection == .home ? .white : .white.opacity(0.9))
                        
                        Button {
                            selection = .commitment
                        } label: {
                            VStack {
                                Image(systemName: "ring.dashed")
                                Text("Commitment")
                                    .font(.caption)
                                    .opacity(0.9)
                            }
                        }
                        .buttonStyle(.plain)
                        .foregroundStyle(selection == .commitment ? .white : .white.opacity(0.9))
                        
                        Button {
                            selection = .calendar
                        } label: {
                            VStack {
                                Image(systemName: "calendar")
                                Text("Calendar")
                                    .font(.caption)
                                    .opacity(0.9)
                            }
                        }
                        .buttonStyle(.plain)
                        .foregroundStyle(selection == .calendar ? .white : .white.opacity(0.9))
                        
                        Button {
                            selection = .journal
                        } label: {
                            VStack {
                                Image(systemName: "pencil.and.scribble")
                                Text("Journal")
                                    .font(.caption)
                                    .opacity(0.9)
                            }
                        }
                        .buttonStyle(.plain)
                        .foregroundStyle(selection == .journal ? .white : .white.opacity(0.9))
                        
                        Button {
                            selection = .selfCare
                        } label: {
                            VStack {
                                Image(systemName: "person.fill")
                                Text("Self Care")
                                    .font(.caption)
                                    .opacity(0.9)
                            }
                        }
                        .buttonStyle(.plain)
                        .foregroundStyle(selection == .selfCare ? .white : .white.opacity(0.9))
                    }
                    .font(.title2)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .padding(.horizontal)
                    .background(.ultraThinMaterial.opacity(0.5))
                    .foregroundStyle(.white)
                    
                    //        .padding()
                }
            }
        }


#Preview {
    CommitmentsPage()
}

