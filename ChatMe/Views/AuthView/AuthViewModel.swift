//
//  AuthViewModel.swift
//  ChatMe
//
//  Created by Ivan Magda on 28.07.2024.
//

import Foundation
import SwiftUI

@Observable
final class AuthViewModel {
    
    var email = ""
    var password = ""
    var repeatedPassword = ""
    
    private let authManager: AuthManageable
    
    init(authManager: AuthManageable = AuthManager.shared) {
        self.authManager = authManager
    }
    
    func signIn() async {
        do {
            let result = try await authManager.signIn(email: email, password: password)
            print(result.user)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func createAccount() async {
        do {
            let result = try await authManager.createAccount(email: email, password: password)
            print(result.user)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func signOut() {
    }
    
    func arePasswordsEqual() -> Bool {
        return password == repeatedPassword
    }
    
    func isEmailValid() -> Bool {
        let emailPattern = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailPattern)
        let result =  emailPredicate.evaluate(with: email)
        return result
    }
    
    func isPasswordValid() -> Bool {
        let passwordPattern = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[@$!%*?&])[A-Za-z\\d@$!%*?&]{8,}$"
        let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", passwordPattern)
        let result = passwordPredicate.evaluate(with: password)
        return result
    }
    
    
}
