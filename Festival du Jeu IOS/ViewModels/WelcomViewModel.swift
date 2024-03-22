//
//  WelcomViewModel.swift
//  Festival du Jeu IOS
//
//  Created by Mateo iori on 15/03/2024.
//

import Foundation
import Combine

class WelcomeViewModel: ObservableObject {
    @Published var soireesDecouvertes: [SoireeDecouverteModel] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private var subscriptions = Set<AnyCancellable>()

    init() {
        fetchSoireesDecouvertes()
    }

    func fetchSoireesDecouvertes() {
        isLoading = true
        guard let requestURL = URL(string: "https://backawi.onrender.com/api/soireeDecouverte") else {
            self.errorMessage = "Invalid URL"
            return
        }
        
        URLSession.shared.dataTaskPublisher(for: requestURL)
            .map(\.data)
            .decode(type: [SoireeDecouverteModel].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                self?.isLoading = false
                switch completion {
                case .failure(let error):
                    self?.errorMessage = "Fetch error: \(error.localizedDescription)"
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] soirees in
                self?.soireesDecouvertes = soirees
            })
            .store(in: &subscriptions)
    }
    
    func registerForSoiree(userId: String, soireeId: String) {
        print("registration")
        let urlString = "https://backawi.onrender.com/api/soireeDecouverte/\(soireeId)/inscrire"
        print(urlString)
        let requestBody = ["userId": userId]
        print(userId)
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: requestBody) else {
            print("Error: Cannot create JSON from requestBody")
            return
        }

        performPostRequest(urlString: urlString, requestBody: jsonData) { success, error in
            if success {
                // Handle successful registration
                print("Successfully registered for the soiree")
            } else {
                // Handle error
                print("Failed to register for the soiree: \(String(describing: error))")
            }
        }
    }

    func deregisterFromSoiree(userId: String, soireeId: String) {
        let urlString = "https://backawi.onrender.com/api/soireeDecouverte/\(soireeId)/desinscrire"
        let requestBody = ["userId": userId]
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: requestBody) else {
            print("Error: Cannot create JSON from requestBody")
            return
        }

        performPostRequest(urlString: urlString, requestBody: jsonData) { success, error in
            if success {
                // Handle successful deregistration
                print("Successfully deregistered from the soiree")
            } else {
                // Handle error
                print("Failed to deregister from the soiree: \(String(describing: error))")
            }
        }
    }

}
