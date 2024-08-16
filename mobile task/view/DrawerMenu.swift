//
//  DrawerMenu.swift
//  mobile task
//
//  Created by Philip Oma on 16/08/2024.
//

import Foundation
import SwiftUI

struct DrawerMenu: View {
    @Binding var selectedSection: DashboardSection
    @Binding var isDrawerOpen: Bool
    @Binding var isAuthenticated: Bool

    
    var body: some View {
        VStack(alignment: .leading) {
            
            Button(action: {
                selectedSection = .home
                isDrawerOpen = false
            }) {
                Text("Home")
                    .font(.headline)
                    .padding(.vertical, 10)
            }
            .padding(.leading, 16)
            
            Button(action: {
                selectedSection = .profile
                isDrawerOpen = false
            }) {
                Text("Profile")
                    .font(.headline)
                    .padding(.vertical, 10)
            }
            .padding(.leading, 16)
            
            Button(action: {
                selectedSection = .settings
                isDrawerOpen = false
            }) {
                Text("Settings")
                    .font(.headline)
                    .padding(.vertical, 10)
            }
            
            .padding(.leading, 16)
                
                Button(action: {
                    selectedSection = .resetPassword
                    isDrawerOpen = false
                }) {
                    Text("Reset Password")
                        .font(.headline)
                        .padding(.vertical, 10)
                }
            
            .padding(.leading, 16)
            Button(action: {
                    logout()
                isDrawerOpen = false
                }) {
                    Text("Logout")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.red)
                        .cornerRadius(10)
                }
                
            
            Spacer()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.gray.opacity(0.2))
        .padding(.top, 44) // Top padding to avoid the notch area
    }
    
    private func logout() {
        // Clear the authentication token and user info
        UserDefaults.standard.removeObject(forKey: "token")
        UserDefaults.standard.set(false, forKey: "isAuthenticated")
        
        // Update the authentication state
        isAuthenticated = false
    }
}

enum DashboardSection {
    case home, profile, settings, resetPassword
}



