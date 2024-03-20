//
//  ProfilModel.swift
//  Festival du Jeu IOS
//
//  Created by Mateo iori on 19/03/2024.
//

import Foundation

enum Association: String, Codable {
    case aucune = "AUCUNE", aeg = "AEG", aid = "AID", aiesec = "AIESEC", aisec = "AISEC", ajso = "AJSO", amnesty = "AMNESTY", anim = "ANIM"
}

enum TailleTShirt: String, Codable {
    case XS, S, M, L, XL, XXL
}

struct ProfileModel: Decodable {
    var nom: String
    var prenom: String
    var email: String
    var motDePasse: String
    var nombreEditionPrecedente: Int?
    var pseudo: String
    var telephone: String
    var photoDeProfil: String
    var vegetarien: Bool
    var association: Association
    var tailleTShirt: TailleTShirt

    init(nom: String, prenom: String, email: String, motDePasse: String, nombreEditionPrecedente: Int? = nil, pseudo: String, telephone: String, photoDeProfil: String, vegetarien: Bool, association: Association, tailleTShirt: TailleTShirt) {
        self.nom = nom
        self.prenom = prenom
        self.email = email
        self.motDePasse = motDePasse
        self.nombreEditionPrecedente = nombreEditionPrecedente
        self.pseudo = pseudo
        self.telephone = telephone
        self.photoDeProfil = photoDeProfil
        self.vegetarien = vegetarien
        self.association = association
        self.tailleTShirt = tailleTShirt
    }
}
