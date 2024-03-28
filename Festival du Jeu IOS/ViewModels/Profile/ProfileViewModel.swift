//
//  ProfileViewModel.swift
//  Festival du Jeu IOS
//
//  Created by Mateo iori on 19/03/2024.
//

import Foundation
import SwiftUI

class ProfileViewModel: ObservableObject {
    private let profileURL = "https://backawi.onrender.com/api/user/"
    
    @Published var profileData: UserModel?
    @Published var isLoading = true
    @Published var errorMessage: String?
    
    init() {
        fetchProfileData()
    }
    
    func fetchProfileData() {
        guard let userId = TokenManager.getUserIdFromToken() else {
            self.errorMessage = "Erreur d'authentification."
            self.isLoading = false
            return
        }
        
        guard let url = URL(string: "\(profileURL)\(userId)") else {
            self.errorMessage = "URL invalide."
            self.isLoading = false
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                self.isLoading = false
                if let error = error {
                    self.errorMessage = "Erreur réseau : \(error.localizedDescription)"
                    return
                }
                
                guard let data = data else {
                    self.errorMessage = "Données manquantes."
                    return
                }
                
                do {
                    self.profileData = try JSONDecoder().decode(UserModel.self, from: data)
                } catch {
                    self.errorMessage = "Erreur de décodage : \(error.localizedDescription)"
                }
            }
        }.resume()
    }
    
    
    func updateProfile(with updatedData: UserModel) {
        guard let userId = TokenManager.getUserIdFromToken(), let url = URL(string: "\(profileURL)\(userId)") else {
            self.errorMessage = "Erreur de configuration URL ou d'authentification."
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let jsonData = try JSONEncoder().encode(updatedData)
            request.httpBody = jsonData
        } catch {
            self.errorMessage = "Erreur lors de l'encodage des données : \(error.localizedDescription)"
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    self.errorMessage = "Erreur réseau : \(error.localizedDescription)"
                    return
                }
                
                self.profileData = updatedData
            }
        }.resume()
    }

    
}
