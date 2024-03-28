//
//  ReservationViewModel.swift
//  Festival du Jeu IOS
//
//  Created by Lénaïs Desbos on 22/03/2024.
//

import SwiftUI

enum ReservationError: Error {
    case tokenUnavailable
    case invalidURL
    case badRequest
    case unauthorized
    case internalServerError
    case invalidReservationID
    case unknownStatusCode(Int)
    case unknownError
    case unknownResponse
    case httpError(Int)
    case invalidData
}

class ReservationViewModel: ObservableObject {
    
    let id = UUID()
    var hebergement: HebergementModel
    var reservation: ReservationModel?
    
    let tokenM: TokenManager = TokenManager()
    
    private let reservationURL = "https://backawi.onrender.com/api/reservation"
    
    init(hebergement: HebergementModel, reservation: ReservationModel? = nil) {
        self.hebergement = hebergement
        self.reservation = reservation
    }
    
    func makeReservation(date: String, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let token = tokenM.getToken() else {
            print("Token not available")
            completion(.failure(ReservationError.tokenUnavailable))
            return
        }

        guard let url = URL(string: "\(reservationURL)/\(hebergement.hebergementId)/\(date)") else {
            print("Invalid URL: \(reservationURL)/\(hebergement.hebergementId)/\(date)")
            completion(.failure(ReservationError.invalidURL))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                completion(.failure(error ?? ReservationError.unknownError))
                return
            }

            if let httpResponse = response as? HTTPURLResponse {
                switch httpResponse.statusCode {
                case 200...299:
                    print("Reservation created successfully")
                    completion(.success(()))
                case 400:
                    print("Bad request")
                    completion(.failure(ReservationError.badRequest))
                case 401:
                    print("Unauthorized")
                    completion(.failure(ReservationError.unauthorized))
                case 500:
                    print("Internal server error")
                    completion(.failure(ReservationError.internalServerError))
                default:
                    print("Unhandled status code: \(httpResponse.statusCode)")
                    completion(.failure(ReservationError.unknownStatusCode(httpResponse.statusCode)))
                }
            }

            if let responseString = String(data: data, encoding: .utf8) {
                print("Response: \(responseString)")
            }
        }.resume()
    }

    func deleteReservation(completion: @escaping (Result<Void, Error>) -> Void) {
        guard let token = tokenM.getToken() else {
            print("Token not available")
            completion(.failure(ReservationError.tokenUnavailable))
            return
        }

        guard let reservationId = reservation?.reservationId else {
            print("Invalid reservation ID")
            completion(.failure(ReservationError.invalidReservationID))
            return
        }

        guard let url = URL(string: "\(reservationURL)/\(reservationId)") else {
            print("Invalid URL: \(reservationURL)/\(reservationId)")
            completion(.failure(ReservationError.invalidURL))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "Unknown error")
                completion(.failure(error ?? ReservationError.unknownError))
                return
            }

            if let httpResponse = response as? HTTPURLResponse {
                switch httpResponse.statusCode {
                case 200...299:
                    print("Réservation supprimée")
                    completion(.success(()))
                case 400:
                    print("Bad request")
                    completion(.failure(ReservationError.badRequest))
                case 401:
                    print("Unauthorized")
                    completion(.failure(ReservationError.unauthorized))
                case 500:
                    print("Internal server error")
                    completion(.failure(ReservationError.internalServerError))
                default:
                    print("Unhandled status code: \(httpResponse.statusCode)")
                    completion(.failure(ReservationError.unknownStatusCode(httpResponse.statusCode)))
                }
            }

            if let responseString = String(data: data, encoding: .utf8) {
                print("Response: \(responseString)")
            }
        }.resume()
    }
    
    func getReservations(completion: @escaping (Result<[ReservationModel], Error>) -> Void) {
        guard let url = URL(string: reservationURL) else {
            print("Invalid URL: \(reservationURL)")
            completion(.failure(ReservationError.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                completion(.failure(error ?? ReservationError.unknownError))
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                switch httpResponse.statusCode {
                case 200...299:
                    do {
                        let reservations = try JSONDecoder().decode([ReservationModel].self, from: data)
                        completion(.success(reservations))
                    } catch {
                        print("Error decoding JSON: \(error)")
                        completion(.failure(error))
                    }
                case 400:
                    print("Bad request")
                    completion(.failure(ReservationError.badRequest))
                case 401:
                    print("Unauthorized")
                    completion(.failure(ReservationError.unauthorized))
                case 500:
                    print("Internal server error")
                    completion(.failure(ReservationError.internalServerError))
                default:
                    print("Unhandled status code: \(httpResponse.statusCode)")
                    completion(.failure(ReservationError.unknownStatusCode(httpResponse.statusCode)))
                }
            }
        }.resume()
    }
    
    // Fonction pour récupérer une réservation par son ID
    func getReservationById(reservationId: String, completion: @escaping (Result<ReservationModel, Error>) -> Void) {
        // URL de l'endpoint pour récupérer une réservation par son ID
        let reservationURL = "https://backawi.onrender.com/api/reservation/\(reservationId)"
        
        // Création de l'URL à partir de la string
        guard let url = URL(string: reservationURL) else {
            completion(.failure(ReservationError.invalidURL))
            return
        }
        
        // Création de la requête GET
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        // Création de la session URLSession pour effectuer la requête
        URLSession.shared.dataTask(with: request) { data, response, error in
            // Vérification des erreurs potentielles
            if let error = error {
                completion(.failure(error))
                return
            }
            
            // Vérification de la réponse HTTP
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(ReservationError.unknownResponse))
                return
            }
            
            // Vérification du statut de la réponse HTTP
            guard (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(ReservationError.unknownError))
                //completion(.failure(ReservationError.httpError(statusCode: httpResponse.statusCode)))
                return
            }
            
            // Vérification des données reçues
            guard let data = data else {
                completion(.failure(ReservationError.invalidData))
                return
            }
            
            do {
                // Décodage des données JSON en objet ReservationModel
                let decodedReservation = try JSONDecoder().decode(ReservationModel.self, from: data)
                completion(.success(decodedReservation))
            } catch {
                // Gestion des erreurs de décodage
                completion(.failure(error))
            }
        }.resume() // Lancement de la tâche URLSession
    }
    
}
