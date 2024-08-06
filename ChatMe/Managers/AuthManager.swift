//
//  AuthManager.swift
//  ChatMe
//
//  Created by Ivan Magda on 31.07.2024.
//

import SwiftUI
import Firebase
import FirebaseAuth
import os

final class AuthManager: AuthManageable {
    private let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier ?? "ChatMe",
        category: String(describing: AuthManager.self)
    )
    
    static let shared = AuthManager()
    
    private let auth: Auth
    
    init() {
        FirebaseApp.configure()
        self.auth = Auth.auth()
    }
    
    func createAccount(email: String, password: String) async throws -> AuthDataResult {
        logger.info("\(#function) Start creating account with credentials: \(email)")
        let result = try await auth.createUser(withEmail: email, password: password)
        return result
    }
    
    func signIn(email: String, password: String) async throws -> AuthDataResult {
        logger.info("\(#function) Start signIn with credentials: \(email)")
        let result = try await auth.signIn(withEmail: email, password: password)
        return result
    }
    
    func signOut() throws {
        logger.info(#function)
        try auth.signOut()
    }
}

protocol AuthManageable {
    func createAccount(email: String, password: String) async throws -> AuthDataResult
    func signIn(email: String, password: String) async throws -> AuthDataResult
    func signOut() throws
}
