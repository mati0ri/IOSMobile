//
//  ReservationViewModel.swift
//  Festival du Jeu IOS
//
//  Created by Lénaïs Desbos on 22/03/2024.
//

import SwiftUI

class ReservationViewModel: ObservableObject {
    
    let id = UUID()
    var hebergement: HebergementModel
    let tokenM: TokenManager = TokenManager()
    
    private let reservationURL = "https://backawi.onrender.com/api/reservation"
    
    init(hebergement: HebergementModel) {
        self.hebergement = hebergement
    }
    
    func makeReservation(date: String, completion: @escaping (Result<Void, Error>) -> Void) {
        
        guard let token = tokenM.getToken() else {
            print("Token not available")
            return
        }
        
        guard let url = URL(string: "\(reservationURL)/\(hebergement.hebergementId)/\(date)") else {
            print("Invalid URL: \(reservationURL)/\(hebergement.hebergementId)/\(date)")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                switch httpResponse.statusCode {
                case 200...299:
                    print("Reservation created successfully")
                case 400:
                    print("Bad request")
                case 401:
                    print("Unauthorized")
                case 500:
                    print("Internal server error")
                default:
                    print("Unhandled status code: \(httpResponse.statusCode)")
                }
            }
            
            if let responseString = String(data: data, encoding: .utf8) {
                print("Response: \(responseString)")
                // Handle response data, if needed
            }
        }.resume()
    }
    
    func deleteReservation(completion: @escaping (Result<Void, Error>) -> Void) {
        guard let token = tokenM.getToken() else {
            print("Token not available")
            return
        }
        
        guard let reservationId = reservation.id else {
            self.deleteReservationStatus = .failure("Invalid reservation ID")
            return
        }
        
        guard let url = URL(string: "\(reservationURL)/\(reservationId)") else {
            print("Invalid URL: \(reservationURL)/\(reservationId)")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        self.deleteReservationStatus = .loading
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                DispatchQueue.main.async {
                    self.deleteReservationStatus = .failure(error?.localizedDescription ?? "Unknown error")
                }
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                switch httpResponse.statusCode {
                case 200...299:
                    DispatchQueue.main.async {
                        self.deleteReservationStatus = .success
                    }
                    // Handle successful response, if needed
                case 400:
                    DispatchQueue.main.async {
                        self.deleteReservationStatus = .failure("Bad request")
                    }
                    // Handle bad request response
                case 401:
                    DispatchQueue.main.async {
                        self.deleteReservationStatus = .failure("Unauthorized")
                    }
                    // Handle unauthorized response
                case 500:
                    DispatchQueue.main.async {
                        self.deleteReservationStatus = .failure("Internal server error")
                    }
                    // Handle internal server error response
                default:
                    DispatchQueue.main.async {
                        self.deleteReservationStatus = .failure("Unhandled status code: \(httpResponse.statusCode)")
                    }
                }
            }
            
            if let responseString = String(data: data, encoding: .utf8) {
                print("Response: \(responseString)")
                // Handle response data, if needed
            }
        }.resume()
    }
    
}
