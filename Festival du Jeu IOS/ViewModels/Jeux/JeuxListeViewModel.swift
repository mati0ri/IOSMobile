//
//  JeuxListeViewModel.swift
//  Festival du Jeu IOS
//
//  Created by Lénaïs Desbos on 16/03/2024.
//

import Foundation

class JeuxListeViewModel: ObservableObject {
    private let jeuxURL = "https://backawi.onrender.com/api/jeu"
    
    func getJeux(completion: @escaping ([JeuViewModel]?) -> Void) {
        guard let url = URL(string: jeuxURL) else {
                    completion(nil)
                    return
                }
                
                URLSession.shared.dataTask(with: url) { data, response, error in
                    guard let data = data, error == nil else {
                        completion(nil)
                        return
                    }
                    
                    do {
                        let jeux = try JSONDecoder().decode([JeuModel].self, from: data)
                        let jeuViewModels = jeux.map { JeuViewModel(jeu: $0) }
                        completion(jeuViewModels)
                    } catch {
                        print("Error decoding JSON: \(error)")
                        completion(nil)
                    }
                }.resume()
    }
    
}
