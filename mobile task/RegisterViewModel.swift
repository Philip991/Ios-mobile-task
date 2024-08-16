//
//  RegisterViewModel.swift
//  mobile task
//
//  Created by Philip Oma on 16/08/2024.
//

import Foundation
import Combine

class RegisterViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var registrationSuccess: Bool = false
    @Published var showError: Bool = false
    @Published var errorMessage: String = ""
    @Published var isAuthenticated: Bool = false
    @Published var isRequesting: Bool = false

    @Published var emailError: String? = nil
    @Published var passwordError: String? = nil
    @Published var firstNameError: String? = nil
    @Published var lastNameError: String? = nil

    var hasValidationErrors: Bool {
        return emailError != nil || passwordError != nil || firstNameError != nil || lastNameError != nil
    }

    func validateFields() {
        emailError = validateEmail(email)
        passwordError = validatePassword(password)
        firstNameError = validateFirstName(firstName)
        lastNameError = validateLastName(lastName)
    }

    func validateEmail(_ email: String) -> String? {
        if email.isEmpty {
            return "Email is required"
        } else if !isValidEmail(email) {
            return "Invalid email address"
        }
        return nil
    }

    func validatePassword(_ password: String) -> String? {
        if password.isEmpty {
            return "Password is required"
        }
        return nil
    }

    func validateFirstName(_ firstName: String) -> String? {
        if firstName.isEmpty {
            return "First name is required"
        }
        return nil
    }

    func validateLastName(_ lastName: String) -> String? {
        if lastName.isEmpty {
            return "Last name is required"
        }
        return nil
    }

    func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}$"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }

    func register(completion: @escaping (Result<String, Error>) -> Void) {
        guard let url = URL(string: "https://reacttask.mkdlabs.com/v2/api/lambda/register") else {
            isRequesting = false
            print("Invalid URL")
            return
        }
        
        isRequesting = true

        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("cmVhY3R0YXNrOmQ5aGVkeWN5djZwN3p3OHhpMzR0OWJtdHNqc2lneTV0Nw==", forHTTPHeaderField: "x-project")

        let body: [String: Any] = [
            "email": email,
            "password": password,
            "role": "member",
            "is_refresh": false
        ]

        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Registration request failed: \(error)")
                self.isRequesting = false
                completion(.failure(error))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                let error = NSError(domain: "InvalidResponse", code: 0, userInfo: nil)
                self.isRequesting = false
                print("Invalid response received")
                self.showError = true
                completion(.failure(error))
                return
            }

            if httpResponse.statusCode == 200, let data = data {
                if let responseDict = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let token = responseDict["token"] as? String {
                    // Save the token using UserDefaults
                    UserDefaults.standard.setValue(token, forKey: "token")

                    // Call the profile update function
                    self.saveProfile { success in
                        if success {
                            DispatchQueue.main.async {
                                self.registrationSuccess = true
                                self.isRequesting = false
                            }
                        } else {
                            DispatchQueue.main.async {
                                self.errorMessage = "Failed to update profile"
                                self.showError = true
                            }
                        }
                    }
                    completion(.success("Registration successful"))
                } else {
                    let error = NSError(domain: "InvalidData", code: 0, userInfo: nil)
                    self.isRequesting = false
                    completion(.failure(error))
                }
            } else {
                if let data = data {
                    print("Server response: \(String(data: data, encoding: .utf8) ?? "No data")")
                    self.isRequesting = false
                }
                let error = NSError(domain: "HTTPError", code: httpResponse.statusCode, userInfo: nil)
                completion(.failure(error))
            }
        }.resume()
    }
    
    private func saveProfile(completion: @escaping (Bool) -> Void) {
            guard let token = UserDefaults.standard.string(forKey: "token") else {
                completion(false)
                return
            }
            print("token: \(token)")

            let url = URL(string: "https://reacttask.mkdlabs.com/v2/api/lambda/profile")!
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            request.setValue("cmVhY3R0YXNrOjVmY2h4bjVtOGhibzZqY3hpcTN4ZGRvZm9kb2Fjc2t5ZQ==", forHTTPHeaderField: "x-project")

            let body: [String: Any] = [
                "payload": [
                    "first_name": firstName,
                    "last_name": lastName
                ]
            ]
            request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])

            URLSession.shared.dataTask(with: request) { data, response, error in
                DispatchQueue.main.async {
                    if let error = error {
                        print("API call failed with error: \(error.localizedDescription)")
                        completion(false)
                        return
                    }

                    guard let data = data else {
                        print("No data received")
                        completion(false)
                        return
                    }

                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                        let errorOccurred = json?["error"] as? Bool ?? true

                        if errorOccurred {
                            print("Error updating profile \(String(describing: json))")
                            completion(false)
                        } else {
                            print("Profile updated successfully \(String(describing: json))")

                            completion(true)
                        }
                    } catch {
                        print("Failed to parse response: \(error.localizedDescription)")
                        completion(false)
                    }
                }
            }.resume()
        }
}
