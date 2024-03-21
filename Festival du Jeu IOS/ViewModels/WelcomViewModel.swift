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
}
