//
//  HebergeurViewModel.swift
//  Festival du Jeu IOS
//
//  Created by Lénaïs Desbos on 22/03/2024.
//

//
//  File.swift
//  Festival du Jeu IOS
//
//  Created by Lénaïs Desbos on 20/03/2024.
//

import SwiftUI

class HebergeurViewModel: ObservableObject {
    
    private let hebergementURL = "https://backawi.onrender.com/api/hebergement/"
    
    let id = UUID()
    var hebergement: HebergementModel
    @Published var reservations: [ReservationModel] = []
    var userIds: [String] = []
    @Published var users: [UserModel] = []
    
    
    init(hebergement: HebergementModel) {
        self.hebergement = hebergement
        DispatchQueue.main.async {
            self.getReservationsHeb()
            self.fetchUsers()
        }
    }
    
    public func fetchUsers() {
        for userId in userIds {
            getUserById(userId: userId) { result in
                switch result {
                case .success(let user):
                    // Ajouter l'utilisateur récupéré à la liste des utilisateurs
                    self.users.append(user)
                case .failure(let error):
                    print("Failed to fetch user: \(error.localizedDescription)")
                    // Gérer l'erreur de manière appropriée, par exemple, afficher un message d'erreur à l'utilisateur.
                }
            }
        }
    }
    
    func deleteHebergement(hebergementId: String, completion: @escaping (Error?) -> Void) {
        let url = URL(string: "\(hebergementURL)\(hebergementId)")!
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
    
    func updateHebergement(hebergementId: String, nbPlace: Int, adresse: String, jours: [String], completion: @escaping (Error?) -> Void) {
        
        let parameters: [String: Any] = [
            "nbPlace": nbPlace,
            "adresse": adresse,
            "jours": jours
        ]

        guard let postData = try? JSONSerialization.data(withJSONObject: parameters) else {
            completion(nil)
            return
        }
        
        let url = URL(string: "\(hebergementURL)\(hebergementId)")!
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = postData
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                completion(error)
                return
            }

            if let httpResponse = response as? HTTPURLResponse {
                switch httpResponse.statusCode {
                case 200: // Created
                    print("Modification réussi")
                    completion(nil)
                case 400: // Bad Request
                    print("Modification Bad Request")
                    completion(NSError(domain: "Bad Request", code: httpResponse.statusCode, userInfo: nil))
                case 401: // Unauthorized
                    print("Modification Unauthorized")
                    completion(NSError(domain: "Unauthorized", code: httpResponse.statusCode, userInfo: nil))
                case 404: // Not Found
                    print("Modification Not Found")
                    completion(NSError(domain: "Not Found", code: httpResponse.statusCode, userInfo: nil))
                case 500: // Internal Server Error
                    let errorMessage = String(data: data, encoding: .utf8) ?? "Internal Server Error"
                    print("Internal server error: \(errorMessage)")
                    completion(NSError(domain: errorMessage, code: httpResponse.statusCode, userInfo: nil))
                default:
                    print("Modification Unknown Error")
                    completion(NSError(domain: "Unknown", code: httpResponse.statusCode, userInfo: nil))
                }
            } else {
                print("HTTP response not successful: \(response?.description ?? "Unknown response")")
                completion(NSError(domain: "Unknown response", code: 0, userInfo: nil))
            }
        }.resume()
    }
    
    public func getReservationsHeb() {
        let reservationViewModel = ReservationViewModel(hebergement: hebergement)
        reservationViewModel.getReservations { result in
            switch result {
            case .success(let reservations):
                // Filtrer les réservations pour l'hébergement concerné
                let reservationsForHebergement = reservations.filter { $0.hebergement.hebergementId == self.hebergement.hebergementId }
                // Mettre à jour la liste des réservations avec les réservations filtrées
                DispatchQueue.main.async {
                    self.reservations = reservationsForHebergement
                    // Récupérer les IDs d'utilisateur à partir des réservations
                    self.userIds = reservationsForHebergement.map { $0.userId }
                }
            case .failure(let error):
                print("Failed to fetch reservations: \(error.localizedDescription)")
                // Peut-être gérer l'erreur d'une manière appropriée, par exemple, afficher un message d'erreur à l'utilisateur.
            }
        }
    }
    
    // Fonction pour récupérer un utilisateur par son ID
    func getUserById(userId: String, completion: @escaping (Result<UserModel, Error>) -> Void) {
        // Construire l'URL de l'endpoint pour récupérer un utilisateur par son ID
        let userURL = "https://backawi.onrender.com/api/user/\(userId)"
        
        // Création de l'URL à partir de la string
        guard let url = URL(string: userURL) else {
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
                completion(.failure(ReservationError.httpError(httpResponse.statusCode)))
                return
            }
            
            // Vérification des données reçues
            guard let data = data else {
                completion(.failure(ReservationError.invalidData))
                return
            }
            
            do {
                // Décodage des données JSON en objet UserModel
                let decodedUser = try JSONDecoder().decode(UserModel.self, from: data)
                completion(.success(decodedUser))
            } catch {
                // Gestion des erreurs de décodage
                completion(.failure(error))
            }
        }.resume() // Lancement de la tâche URLSession
    }
    
}
