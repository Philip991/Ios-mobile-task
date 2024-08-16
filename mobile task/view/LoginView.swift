//
//  LoginView.swift
//  mobile task
//
//  Created by Philip Oma on 16/08/2024.
//

import Foundation
import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel = LoginViewModel()
    @Binding var isAuthenticated: Bool
    @State private var showToast = false

    
    var body: some View {
        ZStack{ }
            VStack {
                TextField("Email", text: $viewModel.email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                
                if let emailError = viewModel.emailError {
                    Text(emailError)
                        .foregroundColor(.red)
                        .font(.caption)
                }
                
                SecureField("Password", text: $viewModel.password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                
                if let passwordError = viewModel.passwordError {
                    Text(passwordError)
                        .foregroundColor(.red)
                        .font(.caption)
                }
                
                HStack {
                    NavigationLink(destination: ForgotPasswordView()) {
                        Text("Forgot Password?")
                            .font(.system(size: 14))
                            .foregroundColor(.blue)
                    }
                    .disabled(viewModel.isRequesting)
                    
                    if viewModel.isRequesting {
                        ProgressView()
                            .padding()
                    }
                    
                    Spacer()
                    
                    NavigationLink(destination: RegisterView()) {
                        Text("Register")
                            .font(.system(size: 14))
                            .foregroundColor(.blue)
                    }
                }
                .padding(.horizontal)
                
                Button(action: {
                    viewModel.validateFields()
                    
                    if viewModel.emailError == nil && viewModel.passwordError == nil {
                        viewModel.login { result in
                            switch result {
                            case .success(let response):
                                print("Login successful: \(response)")
                                UserDefaults.standard.set(true, forKey: "isAuthenticated")
                                viewModel.showError = false
                                showToast = true
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                        showToast = false
                                        isAuthenticated = true
                                    }
                            case .failure(let error):
                                print("Login failed with error: \(error)")
                                viewModel.errorMessage = "Login failed: \(error.localizedDescription)"
                                viewModel.showError = true
                            }
                        }
                    }
                }) {
                    Text("Login")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .disabled(viewModel.isRequesting)
                .navigationDestination(isPresented: $isAuthenticated) {
                        DashboardView(isAuthenticated: $isAuthenticated)
                    }
                
                if viewModel.showError {
                    Text(viewModel.errorMessage)
                        .foregroundColor(.red)
                        .font(.caption)
                        .padding(.top)
                }
            }
            .padding()
            .navigationTitle("Login")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
        
        if showToast {
                    Spacer()
                    ToastView(message: "Login Success")
                        .padding(.bottom, 50)
                        .zIndex(1)
                    }
        
        if isAuthenticated {
            DashboardView(isAuthenticated: $isAuthenticated)
        }
    }
}



struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(isAuthenticated: .constant(false))
    }
}
