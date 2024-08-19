//
//  AuthView.swift
//  ChatMe
//
//  Created by Ivan Magda on 28.07.2024.
//

import Foundation
import SwiftUI

struct AuthView: View {
    @State private var viewModel = AuthViewModel()
    @State private var authType: AuthType = .signIn
    @State private var arePasswordsEqual = true
    @State private var isEmailValid = false
    @State private var isPasswordValid = false
    private var isAuthDataValid: Bool {
        arePasswordsEqual && isEmailValid && isPasswordValid
    }
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack {
                    ImagePickerView(image: $viewModel.avatarImage) {
                        ZStack {
                            if let image = viewModel.avatarImage {
                                Image(uiImage: image)
                                    .resizable()
                                    .clipShape(Circle())
                            } else {
                                Image(systemName: "person.circle")
                                    .resizable()
                                    .foregroundStyle(Color.white)
                            }
                        }
                        .aspectRatio(contentMode: .fill)
                        .frame(
                            width: geometry.size.width / 3,
                            height: geometry.size.width / 3
                        )
                        .padding(.bottom, 20)
                    }
                    
                    Text(authType == .createAccount ? LocalizedStrings.createHeader : LocalizedStrings.signInHeader)
                        .font(.system(size: 22, weight: .heavy))
                        .foregroundStyle(.white)
                    
                    AuthUserNameView(
                        text: $viewModel.email,
                        placeholder: LocalizedStrings.userNamePlaceholder,
                        isEmailValid: $isEmailValid
                    )
                        .padding(.bottom)
                        .onChange(of: viewModel.email) {
                            isEmailValid = viewModel.isEmailValid()
                        }
                    
                    AuthPasswordView(
                        text: $viewModel.password,
                        placeholder: LocalizedStrings.passwordPlaceholder,
                        isPasswordValid: $isPasswordValid
                    )
                        .padding(.bottom)
                        .onChange(of: viewModel.password) {
                            isPasswordValid = viewModel.isPasswordValid()
                        }
                    
                    if authType == .createAccount {
                        AuthPasswordView(
                            text: $viewModel.repeatedPassword,
                            placeholder: LocalizedStrings.repeatPasswordPlaceholder,
                            isPasswordValid: $arePasswordsEqual
                        )
                            .padding(.bottom, 4)
                            .transition(.move(edge: .trailing))
                            .onChange(of: viewModel.repeatedPassword) {
                                withAnimation {
                                    arePasswordsEqual = viewModel.arePasswordsEqual()
                                }
                            }
                        
                        if !arePasswordsEqual {
                            Text(LocalizedStrings.passwordNotMatch)
                                .foregroundStyle(.red)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .transition(.move(edge: .trailing))
                        }
                    }
                    
                    Button {
                        switch authType {
                        case .signIn:
                            Task {
                                await viewModel.signIn()
                            }
                        case .createAccount:
                            Task {
                                await viewModel.createAccount()
                            }
                        }
                    } label: {
                        Text(authType == .createAccount ? LocalizedStrings.createButton : LocalizedStrings.loginButton)
                            .font(.system(size: 20, weight: .bold))
                            .padding(.vertical)
                            .padding(.horizontal, 60)
                    }
                    .buttonStyle(GrowingButtonStyle(backgroundColor: isAuthDataValid ? .blue : .gray))
                    .padding(.bottom)
                    .disabled(!isAuthDataValid)
                    
                    Button {
                        withAnimation {
                            switch authType {
                            case .signIn:
                                authType = .createAccount
                                viewModel.email = ""
                                viewModel.password = ""
                            case .createAccount:
                                authType = .signIn
                                viewModel.email = ""
                                viewModel.password = ""
                                viewModel.repeatedPassword = ""
                            }
                        }
                    } label: {
                        Text(LocalizedStrings.createAccount)
                            .padding(.horizontal)
                            .padding(.vertical, 4)
                    }
                    .buttonStyle(GrowingButtonStyle(backgroundColor: .gray.opacity(0.5)))
                }
                .padding(.horizontal)
                .frame(width: geometry.size.width)
                .frame(minHeight: geometry.size.height)
            }
            .scrollIndicators(.hidden)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background {
                BackgroundView()
            }
            .alert(isPresented: $viewModel.hasError, error: viewModel.error) { error in
                if let recoverySuggestion = error.recoverySuggestion {
                    Button(recoverySuggestion, role: .cancel) {
                        viewModel.error = nil
                    }
                } else {
                    Text(LocalizedStrings.okButton)
                }
            } message: { error in
                if let failureReason = error.failureReason {
                    Text(failureReason)
                } else {
                    Text(LocalizedStrings.unknownError)
                }
            }
        }
    }
}

#Preview {
    AuthView()
}

extension AuthView {
    private enum LocalizedStrings {
        static let createHeader = NSLocalizedString(
            "auth.view.create.header",
            comment: "Header for auth view"
        )
        static let signInHeader = NSLocalizedString(
            "auth.view.sign.in.header",
            comment: "Header for auth view"
        )
        static let userNamePlaceholder = NSLocalizedString(
            "auth.view.user.name.placeholder",
            comment: "Placeholder for user name text field"
        )
        static let passwordPlaceholder = NSLocalizedString(
            "auth.view.password.placeholder",
            comment: "Placeholder for password text field"
        )
        static let repeatPasswordPlaceholder = NSLocalizedString(
            "auth.view.repeat.password.placeholder",
            comment: "Placeholder for repeat password text field"
        )
        static let passwordNotMatch = NSLocalizedString(
            "auth.view.password.not.match.text",
            comment: "Text for error if passwords not match"
        )
        static let createButton = NSLocalizedString(
            "auth.view.create.button",
            comment: "Title for auth view create button"
        )
        static let loginButton = NSLocalizedString(
            "auth.view.login.button",
            comment: "Title for auth view login button"
        )
        static let createAccount = NSLocalizedString(
            "auth.view.create.account.button",
            comment: "Title for auth view create account button"
        )
        static let okButton = NSLocalizedString(
            "ok.button",
            comment: "Title for auth view ok button"
        )
        static let unknownError = NSLocalizedString(
            "unknown.error",
            comment: "Title for alert when unknown error"
        )
    }
    
    enum AuthType {
        case signIn
        case createAccount
    }
}


