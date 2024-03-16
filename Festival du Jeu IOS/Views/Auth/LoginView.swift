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
        
        if viewModel.isLoggedIn {
            WelcomeView()
        } else {
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
                
            }
            .padding()
            .alert(isPresented: $viewModel.showingAlert) {
                Alert(title: Text(viewModel.alertTitle), message: Text(viewModel.alertMessage), dismissButton: .default(Text("OK")))
            }
            
            VStack{
                HStack{
                    Text("Pas encore de Compte ?").foregroundColor(.secondary)
                    //Text("S'inscrire").foregroundColor(.blue)
                    Button("S'inscrire") {
                        print("Redirection vers inscription à faire")
                    }.foregroundColor(.blue).background(Color.white)
                }
            }
        }
    }
}


struct LoginView_Previews: PreviewProvider {
static var previews: some View {
LoginView()
}
}



