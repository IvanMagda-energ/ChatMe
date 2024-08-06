//
//  AuthView.swift
//  ChatMe
//
//  Created by Ivan Magda on 28.07.2024.
//

import Foundation
import SwiftUI

struct AuthView: View {
    @State private var authViewModel = AuthViewModel()
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
                    Image(systemName: "person.circle")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: geometry.size.width / 3)
                        .padding(.bottom, 20)
                        .foregroundStyle(Color.white)
                    
                    Text(authType == .createAccount ? "CREATE ACCOUNT" : "LOGIN")
                        .font(.system(size: 22, weight: .heavy))
                        .foregroundStyle(.white)
                    
                    AuthUserNameView(text: $authViewModel.email, isEmailValid: $isEmailValid)
                        .padding(.bottom)
                        .onChange(of: authViewModel.email) {
                            isEmailValid = authViewModel.isEmailValid()
                        }
                    
                    AuthPasswordView(
                        text: $authViewModel.password,
                        placeholder: "Password",
                        isPasswordValid: $isPasswordValid
                    )
                        .padding(.bottom)
                        .onChange(of: authViewModel.password) {
                            isPasswordValid = authViewModel.isPasswordValid()
                        }
                    
                    if authType == .createAccount {
                        AuthPasswordView(
                            text: $authViewModel.repeatedPassword,
                            placeholder: "Repeat password",
                            isPasswordValid: $arePasswordsEqual
                        )
                            .padding(.bottom, 4)
                            .transition(.move(edge: .trailing))
                            .onChange(of: authViewModel.repeatedPassword) {
                                withAnimation {
                                    arePasswordsEqual = authViewModel.arePasswordsEqual()
                                }
                            }
                        
                        if !arePasswordsEqual {
                            Text("*Passwords not match")
                                .foregroundStyle(.red)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .transition(.move(edge: .trailing))
                        }
                    }
                    
                    Button {
                        switch authType {
                        case .signIn:
                            Task {
                                await authViewModel.signIn()                            }
                        case .createAccount:
                            Task {
                                await authViewModel.createAccount()
                            }
                        }
                    } label: {
                        Text(authType == .createAccount ? "Create" : "Login")
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
                                authViewModel.email = ""
                                authViewModel.password = ""
                            case .createAccount:
                                authType = .signIn
                                authViewModel.email = ""
                                authViewModel.password = ""
                                authViewModel.repeatedPassword = ""
                            }
                        }
                    } label: {
                        Text("Create account")
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
        }
    }
}

#Preview {
    AuthView()
}

enum AuthType {
    case signIn
    case createAccount
}
