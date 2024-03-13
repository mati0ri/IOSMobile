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
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @State private var alertTitle = ""  // Ajouter une nouvelle variable pour le titre de l'alerte
    
    var viewModel = LoginViewModel()
    
    var body: some View {
        VStack {
            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            SecureField("Mot de passe", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            Button("Se connecter") {
                viewModel.loginUser(email: email, password: password) { success, message in
                    if success {
                        alertTitle = "Succès"
                        alertMessage = "OK"
                        // Ici, vous pouvez naviguer vers la page suivante ou fermer la vue de connexion
                    } else {
                        alertTitle = "Erreur"
                        alertMessage = message ?? "Pas OK"
                    }
                    showingAlert = true
                }
            }
            .alert(isPresented: $showingAlert) {
                Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
        .padding()
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
