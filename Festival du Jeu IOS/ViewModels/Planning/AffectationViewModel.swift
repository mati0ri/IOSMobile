//
//  AffectationViewModel.swift
//  Festival du Jeu IOS
//
//  Created by Lénaïs Desbos on 18/03/2024.
//

import SwiftUI

class AffectationViewModel: ObservableObject {
    
    private let equipeURL = "https://backawi.onrender.com/api/affectation/confirmed/"
    
    let id = UUID();
    var affectation : AffectationModel
    
    init(affectation: AffectationModel) {
        self.affectation = affectation
    }
    
    func getUsersWithConfirmedAffectation(horaireId: String, posteId: String, completion: @escaping ([EquipeViewModel]?) -> Void) {
        
        let url = URL(string: "\(equipeURL)\(horaireId)/\(posteId)")!
        print(url)
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                completion(nil)
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) {
                do {
                    let users = try JSONDecoder().decode([UserModel].self, from: data)
                    print("Users : \(users)")
                    let equipe = users.map { EquipeViewModel(membre: $0)}
                    print("Equipe : \(equipe)")
                    completion(equipe)
                } catch {
                    print("Error decoding JSON: \(error.localizedDescription)")
                    completion(nil)
                }
            } else {
                print("HTTP response not successful: \(response?.description ?? "Unknown response")")
                completion(nil)
            }
        }
        
        task.resume()
    }
    
    
    
}
