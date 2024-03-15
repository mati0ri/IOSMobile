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
    @State private var navigateToWelcome = false
    
    @ObservedObject var viewModel: LoginViewModel
    
    init(viewModel: LoginViewModel = LoginViewModel()) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Se connecter")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                    .padding(.bottom, 20)
                
                TextField("Email", text: $email)
                    .textFieldStyle(PlainTextFieldStyle())
                    .padding()
                
                SecureField("Mot de passe", text: $password)
                    .textFieldStyle(PlainTextFieldStyle())
                    .padding()
                    .padding(.bottom, 20)
                Button("Se connecter") {
                    viewModel.loginUser(email: email, password: password)
                }
                .padding()
                .foregroundColor(.white)
                .background(Color.blue)
                .cornerRadius(8)
                .disabled(email.isEmpty || password.isEmpty)

                NavigationLink(destination: WelcomeView(), isActive: $viewModel.isLoggedIn) {
                    EmptyView()
                }.hidden()
            }
            .padding()
            .alert(isPresented: $viewModel.showingAlert) {
                Alert(title: Text(viewModel.alertTitle), message: Text(viewModel.alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
static var previews: some View {
LoginView()
}
}



