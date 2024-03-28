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
    
}
