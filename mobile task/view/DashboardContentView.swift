//
//  DashboardContentView.swift
//  mobile task
//
//  Created by Philip Oma on 16/08/2024.
//

import Foundation
import SwiftUI

struct DashboardContentView: View {
    @Binding var isAuthenticated: Bool
    let selectedSection: DashboardSection
    
    var body: some View {
        switch selectedSection {
        case .home:
            Text("Home Page")
                .font(.largeTitle)
        case .profile:
            Text("Profile Page")
                .font(.largeTitle)
        case .settings:
            Text("Settings View")
                .font(.largeTitle)
        case .resetPassword:
                    ResetPasswordView(isAuthenticated: .constant(true))
        }
    }
}
