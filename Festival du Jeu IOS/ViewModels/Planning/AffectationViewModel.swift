//
//  AffectationViewModel.swift
//  Festival du Jeu IOS
//
//  Created by Lénaïs Desbos on 18/03/2024.
//

import SwiftUI

class AffectationViewModel: ObservableObject {
    
    
    private let equipeURL = "https://backawi.onrender.com/api/affectation/confirmed/"
    private let affectationURL = "https://backawi.onrender.com/api/affectation/"
    
    let id = UUID();
    var affectation : AffectationModel
    
    init(affectation: AffectationModel) {
        self.affectation = affectation
    }
    
    func getUsersWithConfirmedAffectation(horaireId: String, posteId: String, completion: @escaping ([EquipeViewModel]?) -> Void) {
        
        let url = URL(string: "\(equipeURL)\(horaireId)/\(posteId)")!
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
                    let equipe = users.map { EquipeViewModel(membre: $0)}
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
    
    func deleteAffectation(affectationId: String, completion: @escaping (Error?) -> Void) {
        let url = URL(string: "\(affectationURL)\(affectationId)")!
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(error)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                let statusCode = (response as? HTTPURLResponse)?.statusCode ?? -1
                let error = NSError(domain: "HTTPError", code: statusCode, userInfo: nil)
                completion(error)
                return
            }
            
            completion(nil)
        }
        task.resume()
    }
    
    
}
