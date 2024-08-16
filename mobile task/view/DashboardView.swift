//
//  DashboardView.swift
//  mobile task
//
//  Created by Philip Oma on 15/08/2024.
//

import Foundation
import SwiftUI

struct DashboardView: View {
    @Binding var isAuthenticated: Bool
    @State private var selectedSection: DashboardSection = .home
    @State private var isDrawerOpen: Bool = false
    
    var body: some View {
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    // Main content view
                    DashboardContentView(isAuthenticated: $isAuthenticated, selectedSection: selectedSection)
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .offset(x: isDrawerOpen ? geometry.size.width * 0.4 : 0) // Shift content when drawer is open
                        .disabled(isDrawerOpen) // Disable interaction when drawer is open
                        .navigationBarTitle("Dashboard", displayMode: .inline)
                        .navigationBarItems(leading: Button(action: {
                            withAnimation {
                                isDrawerOpen.toggle()
                            }
                        }) {
                            Image(systemName: "line.horizontal.3")
                                .imageScale(.large)
                        })
                    
                    // Drawer menu
                    if isDrawerOpen {
                        DrawerMenu(selectedSection: $selectedSection, isDrawerOpen: $isDrawerOpen, isAuthenticated: $isAuthenticated)
                            .frame(width: geometry.size.width * 0.4) // Drawer takes up 40% of the screen width
                            .background(Color.gray.opacity(0.2))
                            .transition(.move(edge: .leading)) // Slide-in transition from the left
                    }
                }
                .edgesIgnoringSafeArea(.all)
                .background(Color.white)
                .navigationBarBackButtonHidden(true)
            }
        }
    
    
    
}

struct ProfileView: View {
    var body: some View {
        Text("Profile View")
    }
}

struct SettingsView: View {
    var body: some View {
        Text("Settings View")
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView(isAuthenticated: .constant(true))
    }
}

