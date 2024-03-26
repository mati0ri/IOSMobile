//
//  LoginView.swift
//  Festival du Jeu IOS
//
//  Created by Mateo iori on 13/03/2024.
//

import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var pageInscription = false
    @State private var isLoggingIn = false
    
    @ObservedObject var viewModel: LoginViewModel
    
    init(viewModel: LoginViewModel = LoginViewModel()) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ZStack {
            Image("fond")
                .resizable()
                .edgesIgnoringSafeArea(.all)
                .scaledToFill()
            
            if viewModel.isLoggedIn {
                WelcomeView()
            } else if pageInscription {
                SignInView()
            } else {
                VStack {
                    Image("logo-FDJ")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 150)
                        .padding()
                    
                    TextField("Email", text: $email)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding([.top, .leading, .trailing])
                        .shadow(radius: 1)
                    
                    SecureField("Mot de passe", text: $password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                        .padding(.bottom, 0)
                        .shadow(radius: 1)

                    
                    Button(action: {
                        isLoggingIn = true
                        viewModel.loginUser(email: email, password: password)
                    }) {
                        if isLoggingIn {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                .frame(width: 100, height: 50)
                        } else {
                            Text("Se connecter")
                                .frame(width: 135, height: 50)
                        }
                    }
                    .disabled(isLoggingIn || email.isEmpty || password.isEmpty)
                    .background(isLoggingIn ? Colors.GrisClair : Colors.BleuMoyen)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .padding()
                    
                    VStack {
                        HStack {
                            Text("Pas encore de Compte ?").foregroundColor(.secondary)
                            Button("S'inscrire") {
                                pageInscription = true
                            }.foregroundColor(.blue)
                        }
                    }.padding()
                }
                .padding()
                .alert(isPresented: $viewModel.showingAlert) {
                    Alert(title: Text(viewModel.alertTitle), message: Text(viewModel.alertMessage), dismissButton: .default(Text("OK")))
                }
            }
        }
        .onChange(of: viewModel.isLoggedIn) { _ in
            isLoggingIn = false
        }
        .onChange(of: viewModel.showingAlert) { _ in
            isLoggingIn = false
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
