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
    @State private var isNewAccount = false
    @State private var firstPassword = ""
    @State private var secondPassword = ""
    @State private var isPasswordsTheSame = true
    
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
                    
                    Text(isNewAccount ? "CREATE ACCOUNT" : "LOGIN")
                        .font(.system(size: 22, weight: .heavy))
                        .foregroundStyle(.white)
                    
                    AuthUserNameView(text: $authViewModel.userName)
                        .padding(.bottom)
                    
                    AuthPasswordView(text: $firstPassword, placeholder: "Password")
                        .padding(.bottom)
                    
                    if isNewAccount {
                        AuthPasswordView(text: $secondPassword, placeholder: "Repeat password")
                            .padding(.bottom, 4)
                            .transition(.move(edge: .trailing))
                        
                        if !isPasswordsTheSame {
                            Text("*Passwords not match")
                                .foregroundStyle(.red)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                    
                    Button {
                        if isNewAccount {
                            if authViewModel.arePasswordsEqual(firstPassword, secondPassword) {
                                isPasswordsTheSame = true
                                authViewModel.createAccount()
                            } else {
                                isPasswordsTheSame = false
                            }
                            
                        } else {
                            authViewModel.login()
                        }
                    } label: {
                        Text(isNewAccount ? "Create" : "Login")
                            .font(.system(size: 20, weight: .bold))
                            .padding(.vertical)
                            .padding(.horizontal, 60)
                    }
                    .buttonStyle(GrowingButtonStyle(backgroundColor: Color(red: 0, green: 0, blue: 0.5)))
                    .padding(.bottom)
                    
                    Text("Not a member?")
                        .foregroundStyle(.white)
                        .padding(.bottom)
                    
                    Button {
                        withAnimation {
                            isNewAccount.toggle()
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
