//
//  ProposerHebergementViewModel.swift
//  Festival du Jeu IOS
//
//  Created by Lénaïs Desbos on 19/03/2024.
//

import SwiftUI

class ProposerHebergementViewModel: ObservableObject {
    
    private let propositionURL = "https://backawi.onrender.com/api/hebergement/proposition"
    private let hergementsProposesURL = "https://backawi.onrender.com/api/hebergement/hebergeur/propositions"
    
    private let tokenH = TokenManager()
    
    func createProposition(nbPlace: Int, adresse: String, jours: [String], completion: @escaping (Error?) -> Void) {

        guard let token = tokenH.getToken() else {
            completion(nil)
            return
        }

        let parameters: [String: Any] = [
            "nbPlace": nbPlace,
            "adresse": adresse,
            "jours": jours
        ]

        guard let postData = try? JSONSerialization.data(withJSONObject: parameters) else {
            completion(nil)
            return
        }

        let url = URL(string: propositionURL)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpBody = postData

        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                completion(error)
                return
            }

            if let httpResponse = response as? HTTPURLResponse {
                switch httpResponse.statusCode {
                case 201:
                    completion(nil)
                case 400:
                    completion(NSError(domain: "Bad Request", code: httpResponse.statusCode, userInfo: nil))
                case 401:
                    completion(NSError(domain: "Unauthorized", code: httpResponse.statusCode, userInfo: nil))
                case 404:
                    completion(NSError(domain: "Not Found", code: httpResponse.statusCode, userInfo: nil))
                case 500:
                    let errorMessage = String(data: data, encoding: .utf8) ?? "Internal Server Error"
                    print("Internal server error: \(errorMessage)")
                    completion(NSError(domain: errorMessage, code: httpResponse.statusCode, userInfo: nil))
                default:
                    completion(NSError(domain: "Unknown", code: httpResponse.statusCode, userInfo: nil))
                }
            } else {
                print("HTTP response not successful: \(response?.description ?? "Unknown response")")
                completion(NSError(domain: "Unknown response", code: 0, userInfo: nil))
            }
        }.resume()
            
    }
    
    func getHebergementByHebergeur(completion: @escaping ([HebergeurViewModel]?) -> Void) {
        
        guard let token = tokenH.getToken() else {
            completion(nil)
            return
        }
        
        let url = URL(string: hergementsProposesURL)!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }
            do {
                let propositions = try JSONDecoder().decode([HebergementModel].self, from: data)
                let hebergementViewModels = propositions.map { HebergeurViewModel(hebergement: $0)}
                completion(hebergementViewModels)
            } catch {
                print("Error decoding JSON: \(error)")
                completion(nil)
            }
        }.resume()
        
    }
    
}
