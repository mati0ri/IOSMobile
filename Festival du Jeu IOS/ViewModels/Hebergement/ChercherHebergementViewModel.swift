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
    
    let tokenM: TokenManager = TokenManager()
    
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
    
    func getReservationsByUserId(completion: @escaping ([ReservationViewModel]?) -> Void) {
            
        guard let token = tokenM.getToken() else {
            completion(nil)
            return
        }
        
        let url = URL(string: "\(reservationURL)/of/user")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Erreur de requête: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Réponse serveur invalide")
                completion(nil)
                return
            }
            
            if httpResponse.statusCode == 404 {
                print("Aucune réservation trouvée pour cet utilisateur")
                completion([])
                return
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                print("Erreur de requête: Statut HTTP invalide - \(httpResponse.statusCode)")
                completion(nil)
                return
            }
            
            guard let data = data else {
                print("Aucune donnée reçue")
                completion(nil)
                return
            }
            
            do {
                let reservations = try JSONDecoder().decode([ReservationModel].self, from: data)
                let reservationViewModels = reservations.map { reservation in
                    return ReservationViewModel(hebergement: reservation.hebergement, reservation: reservation)
                }
                completion(reservationViewModels)
            } catch {
                print("Erreur de décodage JSON: \(error)")
                completion(nil)
            }
        }.resume()
    }

    
}
