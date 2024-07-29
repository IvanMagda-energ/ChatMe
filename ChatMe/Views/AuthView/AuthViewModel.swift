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
    var userName: String = ""
    var password: String = ""
    var repeatedPassword: String = ""
    
    func login() {
        print("Login")
    }
    
    func createAccount() {
        guard arePasswordsEqual() else {
            print("Passwords is not equal")
            return
        }
        print("Create account")
    }
    
    func arePasswordsEqual() -> Bool {
        return password == repeatedPassword
    }
}
