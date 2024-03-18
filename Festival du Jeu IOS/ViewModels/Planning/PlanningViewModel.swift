//
//  PlanningViewModel.swift
//  Festival du Jeu IOS
//
//  Created by Lénaïs Desbos on 18/03/2024.
//

import Foundation

class PlanningViewModel: ObservableObject {
    
    private let planningURL = "https://backawi.onrender.com/api/user/"
    
    func getUserIdFromToken() -> String? {
        guard let token = UserDefaults.standard.string(forKey: "token") else {
            print("Token not found in UserDefaults")
            return nil
        }
        
        let tokenParts = token.components(separatedBy: ".")
        guard tokenParts.count >= 2,
              let payloadData = Data(base64Encoded: tokenParts[1], options: .ignoreUnknownCharacters) else {
            print("Invalid token format")
            return nil
        }
        
        do {
            let payload = try JSONSerialization.jsonObject(with: payloadData, options: []) as? [String: Any]
            return payload?["id"] as? String
        } catch {
            print("Error decoding token payload: \(error)")
            return nil
        }
    }

    func getAffectationsByUserId(completion: @escaping ([AffectationViewModel]?) -> Void) {
        
        guard let userId = getUserIdFromToken() else {
            completion(nil)
            return
        }
        
        let url = URL(string: "\(planningURL)/\(userId)")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        //request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }
            do {
                let affectations = try JSONDecoder().decode([AffectationModel].self, from: data)
                let affectationViewModels = affectations.map { AffectationViewModel(affectation: $0)}
                completion(affectationViewModels)
            } catch {
                print("Error decoding JSON: \(error)")
                completion(nil)
            }
        }.resume()
    }
    
}
