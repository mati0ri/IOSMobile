//
//  LoginViewModel.swift
//  Festival du Jeu IOS
//
//  Created by Mateo iori on 13/03/2024.
//

import Foundation

class LoginViewModel {
    private let loginURL = "https://backawi.onrender.com/api/user/login"
    
    func loginUser(email: String, password: String, completion: @escaping (Bool, String?) -> Void) {
        guard let url = URL(string: loginURL) else {
            completion(false, "Invalid URL")
            return
        }
        
        let parameters: [String: Any] = [
            "email": email,
            "motDePasse": password
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: [])
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                completion(false, error?.localizedDescription ?? "Unknown Error")
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                // Handle successful login, parsing token etc.
                completion(true, nil)
            } else {
                // Handle failure
                let message = String(data: data, encoding: .utf8) ?? "Login failed"
                completion(false, message)
            }
        }.resume()
    }
}
