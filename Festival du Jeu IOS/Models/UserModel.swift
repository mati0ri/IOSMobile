//
//  UserModel.swift
//  Festival du Jeu IOS
//
//  Created by Lénaïs Desbos on 18/03/2024.
//

import SwiftUI

struct UserModel: Decodable {
    
    let nom: String
    let prenom: String
    let email: String
    let motDePasse: String
    let association: String
    let hebergement: String
    let nombreEditionPrecedente: Int?
    let role: String
    let pseudo: String
    let telephone: String
    let photoDeProfil: String
    let tailleTShirt: String
    let vegetarien: Bool
    let jeuPrefere: String?
    
    init(nom: String, prenom: String, email: String, motDePasse: String, association: String, hebergement: String, nombreEditionPrecedente: Int?, role: String, pseudo: String, telephone: String, photoDeProfil: String, tailleTShirt: String, vegetarien: Bool, jeuPrefere: String?) {
        self.nom = nom
        self.prenom = prenom
        self.email = email
        self.motDePasse = motDePasse
        self.association = association
        self.hebergement = hebergement
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
