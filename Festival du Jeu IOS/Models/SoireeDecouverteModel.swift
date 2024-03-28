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

    var estInscrit: Bool {
        let userId = TokenManager.getUserIdFromToken()
        return inscrits.contains { $0.id == userId }
    }
    
    func isUserRegistered(userId: String) -> Bool {
            return self.inscrits.contains { $0.id == userId }
        }

    mutating func toggleRegistration(for userId: String) {
            if isUserRegistered(userId: userId) {
                self.inscrits.removeAll { $0.id == userId }
            } else {
                let newUser = Inscrit(id: userId, nom: "User Name")
                self.inscrits.append(newUser)
            }
        }
}
