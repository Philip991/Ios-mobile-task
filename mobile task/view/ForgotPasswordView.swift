//
//  ForgotPasswordView.swift
//  mobile task
//
//  Created by Philip Oma on 16/08/2024.
//

import Foundation
import SwiftUI

struct ForgotPasswordView: View {
    @StateObject private var viewModel = ForgotPasswordViewModel()

    var body: some View {
        VStack {
            TextField("Email", text: $viewModel.email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.emailAddress)

            if let emailError = viewModel.emailError {
                Text(emailError)
                    .foregroundColor(.red)
                    .font(.caption)
                    .padding(.top)
            }


            Button(action: {
                viewModel.validateFields()
                
                if viewModel.emailError == nil {
                    viewModel.forgotPassword()
                }
            }) 
            {
                Text("Reset Password")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .disabled(viewModel.isRequesting)

            if viewModel.isRequesting {
                ProgressView()
                    .padding()
            }
        }
        .padding()
        .navigationTitle("Forgot Password")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ForgotPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ForgotPasswordView()
    }
}
