//
//  Requests.swift
//  Festival du Jeu IOS
//
//  Created by Mateo iori on 22/03/2024.
//

import Foundation

func performPostRequest(urlString: String, requestBody: Data, completion: @escaping (Bool, Error?) -> Void) {
    guard let url = URL(string: urlString) else {
        completion(false, NSError(domain: "Invalid URL", code: -1, userInfo: nil))
        return
    }

    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.httpBody = requestBody

    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            completion(false, error)
            return
        }
        completion(true, nil)
    }
    task.resume()
}
