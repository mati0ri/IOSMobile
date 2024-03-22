//
//  ChercherHebergementViewModel.swift
//  Festival du Jeu IOS
//
//  Created by Lénaïs Desbos on 22/03/2024.
//

import SwiftUI

class ChercherHebergementViewModel: ObservableObject {
    
    private let hebergementsURL = "https://backawi.onrender.com/api/hebergement"
    private let reservationURL = "https://backawi.onrender.com/api/reservation"
    
    func getHebergements(completion: @escaping ([ReservationViewModel]?) -> Void) {
        
        let url = URL(string: "\(hebergementsURL)")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }
            do {
                let choix = try JSONDecoder().decode([HebergementModel].self, from: data)
                let reservationViewModels = choix.map { ReservationViewModel(hebergement: $0)}
                completion(reservationViewModels)
            } catch {
                print("Error decoding JSON: \(error)")
                completion(nil)
            }
        }.resume()
    }
    
    func getNbReservationByHebergementId(id: String, date: String, completion: @escaping (Int?) -> Void) {
        
        let endpoint = "\(reservationURL)/nb/\(id)/\(date)"
        guard let url = URL(string: endpoint) else {
            completion(nil)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                if let nbReservations = json?["nbReservations"] as? Int {
                    completion(nbReservations)
                } else {
                    completion(0)
                }
            } catch {
                print("Error decoding JSON: \(error)")
                completion(nil)
            }
        }.resume()
        
    }
    
}
