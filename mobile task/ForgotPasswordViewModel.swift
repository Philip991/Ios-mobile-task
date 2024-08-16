//
//  ForgotPasswordViewModel.swift
//  mobile task
//
//  Created by Philip Oma on 16/08/2024.
//

import Foundation
import Combine

class ForgotPasswordViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var isRequesting: Bool = false
    @Published var responseMessage: String? = nil
    @Published var showAlert: Bool = false
    @Published var emailError: String? = nil
    @Published var otp: String = ""
    @Published var otpError: String? = nil
    @Published var showError: Bool = false
    @Published var errorMessage: String = ""
    @Published var newPassword: String = ""
    @Published var passwordError: String? = nil
    @Published var newPasswordError: String? = nil
    
    private var cancellables = Set<AnyCancellable>()
    
    func validateFields() {
            emailError = validateEmail(email)
        }
    
    func validateEmail(_ email: String) -> String? {
            if email.isEmpty {
                return "Email is required"
            } else if !isValidEmail(email) {
                return "Invalid email address"
            }
            return nil
        }
    
    func isValidEmail(_ email: String) -> Bool {
            let emailRegex = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}$"
            let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
            return emailPredicate.evaluate(with: email)
        }
    
    // Call this method to request an OTP to be sent to the user's email
    func forgotPassword() {
        guard !email.isEmpty else {
            responseMessage = "Email field is empty."
            showAlert = true
            return
        }
        
        isRequesting = true
        
        guard let url = URL(string: "https://reacttask.mkdlabs.com/v2/api/lambda/forgot") else {
            responseMessage = "Invalid URL."
            showAlert = true
            isRequesting = false
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("cmVhY3R0YXNrOjVmY2h4bjVtOGhibzZqY3hpcTN4ZGRvZm9kb2Fjc2t5ZQ==", forHTTPHeaderField: "x-project")
        
        let body: [String: String] = ["email": email]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            DispatchQueue.main.async {
                guard let self = self else { return }
                
                self.isRequesting = false
                
                if let error = error {
                    self.responseMessage = "Request failed with error: \(error.localizedDescription)"
                    self.showAlert = true
                    return
                }
                
                guard let data = data else {
                    self.responseMessage = "No data received."
                    self.showAlert = true
                    return
                }
                
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                    let errorOccurred = json?["error"] as? Bool ?? true
                    let message = json?["message"] as? String ?? "Unknown error"
                    
                    if errorOccurred {
                        self.responseMessage = message
                    } else {
                        self.responseMessage = "Success: \(message)"
                    }
                    
                    self.showAlert = true
                } catch {
                    self.responseMessage = "Failed to parse response: \(error.localizedDescription)"
                    self.showAlert = true
                }
            }
        }.resume()
    }
}
    

struct ResetPasswordResponse: Codable {
    let error: Bool
    let message: String
}
