//
//  LoginViewModel.swift
//  Festival du Jeu IOS
//
//  Created by Mateo iori on 13/03/2024.
//

import Foundation
import Combine

class LoginViewModel: ObservableObject {
    @Published var showingAlert = false
    @Published var alertMessage = ""
    @Published var alertTitle = ""
    @Published var isLoggedIn = false
    
    private let loginURL = "https://backawi.onrender.com/api/user/login"
    
    func loginUser(email: String, password: String) {
        guard let url = URL(string: loginURL) else {
            self.updateAlert(title: "Erreur", message: "URL invalide")
            return
        }
        
        let parameters: [String: Any] = [
            "email": email,
            "motDePasse": password
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: [])
        
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    self?.updateAlert(title: "Erreur", message: error?.localizedDescription ?? "Erreur inconnue")
                    return
                }
                
                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                    if let token = try? JSONDecoder().decode(Token.self, from: data) {
                        UserDefaults.standard.set(token.accessToken, forKey: "token")
                        self?.isLoggedIn = true
                    }
                } else {
                    if let json = try? JSONSerialization.jsonObject(with: data, options: []),
                       let dictionary = json as? [String: Any],
                       let message = dictionary["message"] as? String {
                        self?.updateAlert(title: "Erreur", message: message)
                    } else {
                        self?.updateAlert(title: "Erreur", message: "Échec de la connexion.")
                    }
                }
            }
        }.resume()
    }
    
    private func updateAlert(title: String, message: String) {
        self.showingAlert = true
        self.alertTitle = title
        self.alertMessage = message
    }
}

struct Token: Codable {
    let accessToken: String
}
