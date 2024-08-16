//
//  ResetPasswordView.swift
//  mobile task
//
//  Created by Philip Oma on 16/08/2024.
//

import Foundation
import SwiftUI

struct ResetPasswordView: View {
    @StateObject private var viewModel = ResetPasswordViewModel()
    @Binding var isAuthenticated: Bool
    @State private var showToast = false


    var body: some View {
        VStack {
            TextField("Enter OTP", text: $viewModel.otp)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.numberPad)
                    .textContentType(.oneTimeCode)
                
                if let otpError = viewModel.otpError {
                    Text(otpError)
                        .foregroundColor(.red)
                        .font(.caption)
                        .padding(.top)
                }
            
            SecureField("New Password", text: $viewModel.password)
                           .textFieldStyle(RoundedBorderTextFieldStyle())
                           .autocapitalization(.none)
                           .disableAutocorrection(true)

            if let passwordError = viewModel.passwordError {
                           Text(passwordError)
                               .foregroundColor(.red)
                               .font(.caption)
                               .padding(.top)
                       }


            Button(action: {
                viewModel.validateFields()
                
                if viewModel.passwordError == nil && viewModel.otpError == nil{
                    
                    viewModel.resetPassword()
                }
            })
            {
                Text("Reset Password")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .navigationDestination(isPresented: $viewModel.resetSuccess) {
                DashboardView(isAuthenticated: $isAuthenticated)
            }
            
            .disabled(viewModel.isRequesting)

            if viewModel.isRequesting {
                ProgressView()
                    .padding()
            }
        }
        .padding()
        .navigationTitle("Reset Password")
        .navigationBarTitleDisplayMode(.inline)
        
        if showToast {
                    Spacer()
                    ToastView(message: "Success!")
                        .padding(.bottom, 50)
                        .zIndex(1)
                    }
    }
}

struct ResetPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ResetPasswordView(isAuthenticated: .constant(true))
    }
}
