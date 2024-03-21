//
//  NextAffectationViewModel.swift
//  Festival du Jeu IOS
//
//  Created by Mateo iori on 21/03/2024.
//

import Foundation

class NextAffectationViewModel: ObservableObject {
    @Published var nextAffectation: NextAffectationModel?
    @Published var isLoading = false
    @Published var errorMessage: String?

    func fetchNextAffectation() {
        print("nextFA")
        guard let userId = TokenManager.getUserIdFromToken() else {
            errorMessage = "User ID not found."
            return
        }

        isLoading = true
        let urlString = "https://backawi.onrender.com/api/affectation/next/\(userId)"
        print(urlString)
        guard let url = URL(string: urlString) else {
            errorMessage = "Invalid URL."
            isLoading = false
            return
        }

        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                if let error = error {
                    self?.errorMessage = "Request error: \(error.localizedDescription)"
                    return
                }
                guard let data = data else {
                    self?.errorMessage = "No data received."
                    return
                }
                do {
                    self?.nextAffectation = try JSONDecoder().decode(NextAffectationModel.self, from: data)
                } catch {
                    self?.errorMessage = "Decoding error: \(error.localizedDescription)"
                }
            }
        }.resume()
    }
}
