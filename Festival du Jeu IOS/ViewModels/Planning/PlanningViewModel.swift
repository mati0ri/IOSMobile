//
//  PlanningViewModel.swift
//  Festival du Jeu IOS
//
//  Created by Lénaïs Desbos on 18/03/2024.
//

import Foundation

class PlanningViewModel: ObservableObject {
    
    private let planningURL = "https://backawi.onrender.com/api/affectation/user/"
    
    func getAffectationsByUserId(completion: @escaping ([AffectationViewModel]?) -> Void) {
        
        guard let userId = TokenManager.getUserIdFromToken() else {
            completion(nil)
            return
        }
        
        let url = URL(string: "\(planningURL)\(userId)")!
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
