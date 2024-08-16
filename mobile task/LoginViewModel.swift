//
//  LoginViewModel.swift
//  mobile task
//
//  Created by Philip Oma on 16/08/2024.
//

import Foundation
//import SwiftUI
import Combine

class LoginViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var showError: Bool = false
    @Published var errorMessage: String = ""
    @Published var isRequesting: Bool = false
    @Published var isAuthenticated: Bool = false
    
    @Published var emailError: String? = nil
    @Published var passwordError: String? = nil
    
    private var cancellables = Set<AnyCancellable>()
    
    func validateFields() {
        emailError = validateEmail(email)
        passwordError = validatePassword(password)
    }
    
    func login(completion: @escaping (Result<String, Error>) -> Void) {
        guard let url = URL(string: "https://reacttask.mkdlabs.com/v2/api/lambda/login") else {
            isRequesting = false
            print("Invalid URL")
            return
        }
        
        isRequesting = true
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("cmVhY3R0YXNrOjVmY2h4bjVtOGhibzZqY3hpcTN4ZGRvZm9kb2Fjc2t5ZQ==", forHTTPHeaderField: "x-project")
        
        let body: [String: Any] = [
            "email": email,
            "password": password,
            "role": "admin"
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let self = self else { return }
            
            if let error = error {
                DispatchQueue.main.async {
                    self.isRequesting = false
                    self.errorMessage = "Login failed: \(error.localizedDescription)"
                    self.showError = true
                }
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                let error = NSError(domain: "InvalidResponse", code: 0, userInfo: nil)
                DispatchQueue.main.async {
                    self.isRequesting = false
                    self.errorMessage = "Invalid response received"
                    self.showError = true
                }
                completion(.failure(error))
                return
            }
            
            if httpResponse.statusCode == 200, let data = data {
                if let responseString = String(data: data, encoding: .utf8) {
                    do {
                        if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                           let token = json["token"] as? String {
                            // Save the token to UserDefaults
                            
                            UserDefaults.standard.set(token, forKey: "token")
                            UserDefaults.standard.set(true, forKey: "isAuthenticated")
                            
                            DispatchQueue.main.async {
                                self.isAuthenticated = true
                                self.isRequesting = false
                            }
                            
                            completion(.success(responseString))
                        } else {
                            let error = NSError(domain: "InvalidData", code: 0, userInfo: nil)
                            DispatchQueue.main.async {
                                self.isRequesting = false
                                self.errorMessage = "Invalid data received"
                                self.showError = true
                            }
                            completion(.failure(error))
                        }
                    } catch {
                        DispatchQueue.main.async {
                            self.isRequesting = false
                            self.errorMessage = "Error parsing response"
                            self.showError = true
                        }
                        completion(.failure(error))
                    }
                } else {
                    let error = NSError(domain: "InvalidData", code: 0, userInfo: nil)
                    DispatchQueue.main.async {
                        self.isRequesting = false
                        self.errorMessage = "Invalid data received"
                        self.showError = true
                    }
                    completion(.failure(error))
                }
            } else {
                let error = NSError(domain: "HTTPError", code: httpResponse.statusCode, userInfo: nil)
                DispatchQueue.main.async {
                    self.isRequesting = false
                    self.errorMessage = "HTTP Error: \(httpResponse.statusCode)"
                    self.showError = true
                }
                completion(.failure(error))
            }
        }.resume()
    }
    
    private func validateEmail(_ email: String) -> String? {
        if email.isEmpty {
            return "Email is required"
        } else if !isValidEmail(email) {
            return "Invalid email address"
        }
        return nil
    }

    private func validatePassword(_ password: String) -> String? {
        if password.isEmpty {
            return "Password is required"
        }
        return nil
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}$"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
}
