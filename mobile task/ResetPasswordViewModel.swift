//
//  ResetPasswordViewModel.swift
//  mobile task
//
//  Created by Philip Oma on 16/08/2024.
//

import Foundation
import Combine

class ResetPasswordViewModel: ObservableObject{
    @Published var otp: String = ""
    @Published var password: String = ""
    @Published var otpError: String? = nil
    @Published var showError: Bool = false
    @Published var errorMessage: String = ""
    @Published var passwordError: String? = nil
    @Published var isRequesting: Bool = false
    @Published var resetSuccess: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    

    
    func validateFields() {
            otpError = validateOtp(otp) // Join array to validate as a single string
            passwordError = validatePassword(password)
        }
    
    func validateOtp(_ otp: String) -> String? {
        if otp.isEmpty {
            return "OTP is required"
        } else if otp.count != 6 {
            return "OTP must be 6 digits"
        }
        return nil
    }

func validatePassword(_ newPassword: String) -> String? {
    if newPassword.isEmpty{
        return "New Password is Required"
    }
    return nil
}
    
    func resetPassword() {
        guard let url = URL(string: "https://reacttask.mkdlabs.com/v2/api/lambda/reset") else {
            print("Invalid URL")
            return
        }
        guard let token = UserDefaults.standard.string(forKey: "token") else {
            return
        }
        print("token: \(token)")
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("cmVhY3R0YXNrOjVmY2h4bjVtOGhibzZqY3hpcTN4ZGRvZm9kb2Fjc2t5ZQ==", forHTTPHeaderField: "x-project")
        
        let body: [String: Any] = [
            "token": "1181961E-45A2-479B-B43F-69C5817258B5-57D2-16489608", 
            "code": otp,
            "password": password
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        
        isRequesting = true
        
        URLSession.shared.dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: ResetPasswordResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                self.isRequesting = false
                switch completion {
                case .failure(let error):
                    self.showError = true
                    self.errorMessage = "Reset Password request failed: \(error.localizedDescription)"
                case .finished:
                    break
                }
            }, receiveValue: { response in
                if response.error == false {
                    // Handle success, e.g., show success message, navigate to login, etc.
                    self.errorMessage = "Password reset successfully!"
                    self.resetSuccess = true
                } else {
                    self.showError = true
                    self.errorMessage = response.message
                }
            })
            .store(in: &cancellables)
    }
}
