//
//  File.swift
//  Festival du Jeu IOS
//
//  Created by Lénaïs Desbos on 17/03/2024.
//

import Foundation
import Combine

class SignInViewModel: ObservableObject {
    @Published var showingAlert = false
    @Published var alertMessage = ""
    @Published var alertTitle = ""
    @Published var isSignedIn = false
    
    private let signInURL = "https://backawi.onrender.com/api/user/"
    
    func signInUser(firstName: String, lastName: String, email: String, password: String, phoneNumber: String, tshirtSize: String) {
        guard let url = URL(string: signInURL) else {
            self.updateAlert(title: "Erreur", message: "URL invalide")
            return
        }
        
        let parameters: [String: Any] = [
            "nom": lastName,
            "prenom": firstName,
            "email": email,
            "motDePasse": password,
            "telephone": phoneNumber,
            "tailleTShirt": tshirtSize
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
                
                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 201 {
                    self?.isSignedIn = true
                } else {
                    if let json = try? JSONSerialization.jsonObject(with: data, options: []),
                       let dictionary = json as? [String: Any],
                       let message = dictionary["message"] as? String {
                        self?.updateAlert(title: "Erreur", message: message)
                    } else {
                        self?.updateAlert(title: "Erreur", message: "Échec de l'inscription.")
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
