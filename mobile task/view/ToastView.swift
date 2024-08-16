//
//  ToastView.swift
//  mobile task
//
//  Created by Philip Oma on 16/08/2024.
//

import Foundation
import SwiftUI


struct ToastView: View {
    var message: String

    var body: some View {
        Text(message)
            .font(.subheadline)
            .foregroundColor(.white)
            .padding()
            .background(Color.gray)
            .cornerRadius(8)
            .padding(.horizontal, 10)
            .transition(.move(edge: .top))
            .animation(.easeInOut, value: 1)
    }
}
