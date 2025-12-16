//
//  ContentView.swift
//  Creatability Version 2
//
//  Created by Taijah Johnson on 12/2/25.
//

import SwiftUI

struct BottomNavigationTabView: View {
    var body: some View {
        
        ZStack{
           
                TabView{
                    MoodCheckInView()
                        .tabItem {
                            Image(systemName: "house.fill")
                            Text("Home")
                        }
                    
                    CommitmentsPage()
                        .tabItem {
                            Image(systemName: "ring.dashed")
                            Text("Commitments")
                            
                        }
                    
                    ReplayStackView(cards: [ReplayCard(title: "Affirmations", subtitle: "Recieve Daily Affirmations", imageName: "affirmationimage2"),
                        
                                            ReplayCard(title: "Stretches", subtitle: "Suggested stretches to minimize tension", imageName: "stretchimage2"),
                                            ReplayCard(title: "Breath Work", subtitle: "Deep breathing to calm your nervous system", imageName: "breatheimage2"),])
                    .tabItem {
                        Image(systemName: "person.fill")
                        Text("Self Care")
                        
                    }
                    
//                    JournalPage()
//                        .tabItem {
//                                     Image(systemName: ".journal")
//                                     Text("Journal")
//                                     
//                                 }
                    
                    GalaxyCalendarView()
                        .tabItem {
                                     Image(systemName: "calendar")
                                     Text("Calendar")
                                     
                                 }
                        
                        
                        }
                
                }
        .tint(.black)
                
                
                
//            RoundedRectangle(cornerRadius: 40, style: .continuous)
//            .frame(width: 365, height: 50)
//            .offset(x: 0, y: 355)
//            .opacity(0.2)
            
        }
    }

#Preview {
    BottomNavigationTabView()
}
