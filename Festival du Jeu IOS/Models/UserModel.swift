//
//  UserModel.swift
//  Festival du Jeu IOS
//
//  Created by Lénaïs Desbos on 18/03/2024.
//

import SwiftUI

struct UserModel: Decodable {
    
    let id: String
    let nom: String
    let prenom: String
    let email: String
    let motDePasse: String
    let association: String?
    let choixHebergement: String
    let nombreEditionPrecedente: Int?
    let role: String
    let pseudo: String
    let telephone: String
    let photoDeProfil: String
    let tailleTShirt: String
    let vegetarien: Bool
    let jeuPrefere: String?
    
    init(id: String, nom: String, prenom: String, email: String, motDePasse: String, association: String, choixHebergement: String, nombreEditionPrecedente: Int?, role: String, pseudo: String, telephone: String, photoDeProfil: String, tailleTShirt: String, vegetarien: Bool, jeuPrefere: String?) {
        self.id = id
        self.nom = nom
        self.prenom = prenom
        self.email = email
        self.motDePasse = motDePasse
        self.association = association
        self.choixHebergement = choixHebergement
        self.nombreEditionPrecedente = nombreEditionPrecedente
        self.role = role
        self.pseudo = pseudo
        self.telephone = telephone
        self.photoDeProfil = photoDeProfil
        self.tailleTShirt = tailleTShirt
        self.vegetarien = vegetarien
        self.jeuPrefere = jeuPrefere
    }
    
}
