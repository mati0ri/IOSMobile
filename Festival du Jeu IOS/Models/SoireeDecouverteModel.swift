//
//  SoiréeModel.swift
//  Festival du Jeu IOS
//
//  Created by Mateo iori on 21/03/2024.
//

struct SoireeDecouverteModel: Identifiable, Codable {
    var id: String
    var nom: String
    var date: String
    var lieu: String
    var jeux: [Jeu]
    var inscrits: [Inscrit]

    struct Jeu: Identifiable, Codable {
        var id: String
        var nom: String
    }

    struct Inscrit: Identifiable, Codable {
        var id: String
        var nom: String
    }

    // Add this computed property to determine if the user is registered
    var estInscrit: Bool {
        let userId = TokenManager.getUserIdFromToken()
        return inscrits.contains { $0.id == userId }
    }
}
