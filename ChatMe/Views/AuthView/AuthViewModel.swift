//
//  AuthViewModel.swift
//  ChatMe
//
//  Created by Ivan Magda on 28.07.2024.
//

import Foundation
import SwiftUI
import os

@Observable
final class AuthViewModel {
    private let logger = Logger(
        subsystem: String(describing: Bundle.main.bundleIdentifier),
        category: String(describing: AuthManager.self)
    )
    
    var email = ""
    var password = ""
    var repeatedPassword = ""
    var avatarImage: UIImage?
    var error: AuthViewModelError?
    var hasError = false
    
    private let authManager: AuthManagerProtocol
    private let storeManager: StorageManagerProtocol
    
    init(
        authManager: AuthManagerProtocol = AuthManager.shared,
        storeManager: StorageManagerProtocol = StorageManager.shared
    ) {
        self.authManager = authManager
        self.storeManager = storeManager
    }
    
    func signIn() async {
        do {
            let result = try await authManager.signIn(email: email, password: password)
            logger.info("\(#function) Success: \(result)")
            saveUserAvatarToStore()
        } catch {
            await handleError(.failedSignIn(error))
        }
    }
    
    func createAccount() async {
        do {
            let result = try await authManager.createAccount(email: email, password: password)
            logger.info("\(#function) Success: \(result)")
            saveUserAvatarToStore()
        } catch {
            await handleError(.failedCreateAccount(error))
        }
    }
    
    func signOut() async {
        do {
            try authManager.signOut()
        } catch {
            await handleError(.failedSignOut(error))
        }
    }
    
    func saveUserAvatarToStore() {
        guard let avatarImage else {
            return
        }
        
        guard  let compressedImageData = avatarImage.jpegData(compressionQuality: 0.5) else {
            return
        }
        
        guard let currentUserId = authManager.currentUserId() else {
            return
        }
       
        storeManager.storeImage(compressedImageData, userId: currentUserId)
        logger.info("\(#function) Avatar image for user \(currentUserId) successful stored.")
        
    }
    
    func arePasswordsEqual() -> Bool {
        return password == repeatedPassword
    }
    
    func isEmailValid() -> Bool {
        let emailPattern = Constants.emailPattern
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailPattern)
        let result =  emailPredicate.evaluate(with: email)
        return result
    }
    
    func isPasswordValid() -> Bool {
        let passwordPattern = Constants.passwordPattern
        let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", passwordPattern)
        let result = passwordPredicate.evaluate(with: password)
        return result
    }
    
    private func handleError(_ error: AuthViewModelError) async {
        await MainActor.run {
            self.error = error
            self.hasError = true
        }
    }
}
extension AuthViewModel {
    enum AuthViewModelError: LocalizedError {
        case failedCreateAccount(_ error: Error)
        case failedSignIn(_ error: Error)
        case failedSignOut(_ error: Error)
        
        public var errorDescription: String? {
            switch self {
            case .failedCreateAccount:
                return NSLocalizedString(
                    "failed.create.account.error.description",
                    value: "Failed create user",
                    comment: "Error description when failed create user")
            case .failedSignIn:
                return NSLocalizedString(
                    "failed.sign.in.error.description",
                    value: "Failed sign in to application",
                    comment: "Error when failed sign in")
            case .failedSignOut:
                return NSLocalizedString(
                    "failed.sign.out.error.description",
                    value: "Failed sign out",
                    comment: "Error description when failed sign out")
            }
        }
        
        public var failureReason: String? {
            switch self {
            case .failedCreateAccount(let error):
                return error.localizedDescription
            case .failedSignIn(let error):
                return error.localizedDescription
            case .failedSignOut(let error):
                return error.localizedDescription
            }
        }
        
        public var helpAnchor: String? {
            switch self {
            case .failedCreateAccount(let error):
                return error.localizedDescription
            case .failedSignIn(let error):
                return error.localizedDescription
            case .failedSignOut(let error):
                return error.localizedDescription
            }
        }
        
        public var recoverySuggestion: String? {
            switch self {
            default:
                return NSLocalizedString("ok.button", comment: "Ok")
            }
        }
    }
}
