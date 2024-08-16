//
//  RegisterView.swift
//  mobile task
//
//  Created by Philip Oma on 16/08/2024.
//

import Foundation
import SwiftUI

struct RegisterView: View {
    @ObservedObject var viewModel = RegisterViewModel()
    @State private var formSubmitted: Bool = false  // Track form submission
    @State private var showToast = false

    var body: some View {
            VStack(spacing: 20) {
                TextField("Email", text: $viewModel.email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)

                if formSubmitted && viewModel.emailError != nil {
                    Text(viewModel.emailError!)
                        .foregroundColor(.red)
                        .font(.caption)
                }

                SecureField("Password", text: $viewModel.password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.none)
                    .disableAutocorrection(true)

                if formSubmitted && viewModel.passwordError != nil {
                    Text(viewModel.passwordError!)
                        .foregroundColor(.red)
                        .font(.caption)
                }

                TextField("First Name", text: $viewModel.firstName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.words)
                    .disableAutocorrection(true)

                if formSubmitted && viewModel.firstNameError != nil {
                    Text(viewModel.firstNameError!)
                        .foregroundColor(.red)
                        .font(.caption)
                }

                TextField("Last Name", text: $viewModel.lastName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.words)
                    .disableAutocorrection(true)

                if formSubmitted && viewModel.lastNameError != nil {
                    Text(viewModel.lastNameError!)
                        .foregroundColor(.red)
                        .font(.caption)
                }

                Button(action: {
                    formSubmitted = true  // Mark the form as submitted

                    // Trigger validation
                    viewModel.validateFields()

                    if !viewModel.hasValidationErrors {
                        viewModel.register { result in
                            switch result {
                            case .success(let response):
                                print("Registration successful: \(response)")
                                showToast = true
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                        showToast = false
                                    viewModel.registrationSuccess = true
                                    }                            case .failure(let error):
                                print("Registration failed with error: \(error)")
                                viewModel.errorMessage = "Login failed: \(error.localizedDescription)"
                            }
                        }
                    }
                }) {
                    Text("Register")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }

                .navigationDestination(isPresented: $viewModel.registrationSuccess) {
                    LoginView(isAuthenticated: $viewModel.isAuthenticated)
                }

                if viewModel.isRequesting {
                    ProgressView()
                        .padding()
                }
                
                if viewModel.showError {
                    Text(viewModel.errorMessage)
                        .foregroundColor(.red)
                        .font(.caption)
                }
            }
            .padding()
            .navigationTitle("Login")
        
        if showToast {
                    Spacer()
                    ToastView(message: "Success!")
                        .padding(.bottom, 50)
                        .zIndex(1)
                    }
    }
}
