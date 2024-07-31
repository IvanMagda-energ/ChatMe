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
    
    
    func login() {
        print("Login")
    }
    
    func createAccount() {
        print("Create account")
    }
    
    func arePasswordsEqual(_ firstPassword: String, _ secondPassword: String) -> Bool {
        return firstPassword == secondPassword
    }
}
