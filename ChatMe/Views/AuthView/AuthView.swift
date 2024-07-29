//
//  AuthView.swift
//  ChatMe
//
//  Created by Ivan Magda on 28.07.2024.
//

import Foundation
import SwiftUI

struct AuthView: View {
    @State var authViewModel = AuthViewModel()
    @State private var isNewAccount = false
    
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
                    
                    AuthPasswordView(text: $authViewModel.password, passwordFieldType: .password)
                        .padding(.bottom)
                    
                    if isNewAccount {
                        AuthPasswordView(text: $authViewModel.repeatedPassword, passwordFieldType: .repeatPassword)
                            .padding(.bottom)
                            .transition(.move(edge: .trailing))
                    }
                    
                    Button {
                        if isNewAccount {
                            authViewModel.createAccount()
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
