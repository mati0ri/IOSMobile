//
//  PlanningViewModel.swift
//  Festival du Jeu IOS
//
//  Created by Lénaïs Desbos on 18/03/2024.
//

import Foundation

class PlanningViewModel: ObservableObject {
    
    private let planningURL = "https://backawi.onrender.com/api/affectation/user/"
    
    func getUserIdFromToken() -> String? {
        guard let token = UserDefaults.standard.string(forKey: "token") else {
            print("Token not found in UserDefaults")
            return nil
        }
        
        let tokenParts = token.components(separatedBy: ".")
        guard tokenParts.count >= 2,
              let payloadData = Data(base64Encoded: tokenParts[1] + paddingIfNeeded(tokenParts[1])),
              let payload = try? JSONSerialization.jsonObject(with: payloadData, options: []) as? [String: Any],
              let userId = payload["id"] as? String else {
            print("Invalid token format")
            return nil
        }
        
        return userId
    }
    
    private func paddingIfNeeded(_ base64String: String) -> String {
        let paddingLength = base64String.count % 4
        if paddingLength == 0 { return "" }
        return String(repeating: "=", count: 4 - paddingLength)
    }

    func getAffectationsByUserId(completion: @escaping ([AffectationViewModel]?) -> Void) {
        
        guard let userId = getUserIdFromToken() else {
            completion(nil)
            return
        }
        
        let url = URL(string: "\(planningURL)\(userId)")!
        print(url)
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
