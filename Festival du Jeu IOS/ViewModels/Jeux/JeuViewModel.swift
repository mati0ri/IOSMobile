//
//  JeuViewModel.swift
//  Festival du Jeu IOS
//
//  Created by Lénaïs Desbos on 16/03/2024.
//

import SwiftUI

class JeuViewModel: ObservableObject {
    private let loginURL = "https://backawi.onrender.com/api/user/login"
    
    let id = UUID();
    var jeu : JeuModel
    @Published var nom: String {
        didSet {
            if nom != jeu.nom {
                jeu.nom = nom
            }
        }
    }
    @Published public var editeur: String
    @Published public var type: String
    @Published public var notice: String
    @Published public var video: String
    @Published public var zoneId: String
    
    static func == (lhs: JeuViewModel, rhs: JeuViewModel) -> Bool { return lhs.id == rhs.id }
    func hash(into hasher: inout Hasher){
        hasher.combine(self.id)
    }
    
    init(jeu: JeuModel){
        
        self.jeu = jeu
        self.nom = jeu.nom
        self.editeur = jeu.editeur
        self.type = jeu.type
        self.notice = jeu.notice
        self.video = jeu.video
        self.zoneId = jeu.zoneId
    }
    
    private let zoneURL = "https://backawi.onrender.com/api/zone/"
    
    func getZoneJeu(zoneId: String, completion: @escaping (String?) -> Void) {
        
        guard let url = URL(string: "\(zoneURL)\(zoneId)") else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }
            
            do {
                let decodedData = try JSONDecoder().decode(ZoneResponse.self, from: data)
                completion(decodedData.nom)
            } catch {
                print("Erreur de décodage : \(error)")
                completion(nil)
            }

        }.resume()
    }
    
}

struct ZoneResponse: Codable {
    let id: String
    let nom: String
}
