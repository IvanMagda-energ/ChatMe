//
//  AuthManager.swift
//  ChatMe
//
//  Created by Ivan Magda on 31.07.2024.
//

import SwiftUI
import FirebaseAuth
import os

final class AuthManager: AuthManagerProtocol {
    private let logger = Logger(
        subsystem: String(describing: Bundle.main.bundleIdentifier),
        category: String(describing: AuthManager.self)
    )
    
    static let shared = AuthManager()
    
    private let auth: Auth
    
    init() {
        self.auth = Auth.auth()
        NSLog("<< initAuth")
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
    
    func currentUserId() -> String? {
        return auth.currentUser?.uid
    }
}

protocol AuthManagerProtocol {
    func createAccount(email: String, password: String) async throws -> AuthDataResult
    func signIn(email: String, password: String) async throws -> AuthDataResult
    func signOut() throws
    func currentUserId() -> String?
}
