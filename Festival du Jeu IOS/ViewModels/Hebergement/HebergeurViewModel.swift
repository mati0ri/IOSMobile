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
    
    
    
    init(hebergement: HebergementModel) {
        self.hebergement = hebergement
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
                    completion(nil)
                case 400: // Bad Request
                    completion(NSError(domain: "Bad Request", code: httpResponse.statusCode, userInfo: nil))
                case 401: // Unauthorized
                    completion(NSError(domain: "Unauthorized", code: httpResponse.statusCode, userInfo: nil))
                case 404: // Not Found
                    completion(NSError(domain: "Not Found", code: httpResponse.statusCode, userInfo: nil))
                case 500: // Internal Server Error
                    let errorMessage = String(data: data, encoding: .utf8) ?? "Internal Server Error"
                    print("Internal server error: \(errorMessage)")
                    completion(NSError(domain: errorMessage, code: httpResponse.statusCode, userInfo: nil))
                default:
                    completion(NSError(domain: "Unknown", code: httpResponse.statusCode, userInfo: nil))
                }
            } else {
                print("HTTP response not successful: \(response?.description ?? "Unknown response")")
                completion(NSError(domain: "Unknown response", code: 0, userInfo: nil))
            }
        }.resume()
    }
    
}
