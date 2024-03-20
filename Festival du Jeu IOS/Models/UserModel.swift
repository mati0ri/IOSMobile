//
//  UserModel.swift
//  Festival du Jeu IOS
//
//  Created by Lénaïs Desbos on 18/03/2024.
//

import SwiftUI

struct UserModel: Codable {
    
    let id: String
    var nom: String
    var prenom: String
    var email: String
    let motDePasse: String
    var association: String?
    var choixHebergement: String
    var nombreEditionPrecedente: Int?
    var role: String
    var pseudo: String
    var telephone: String
    var photoDeProfil: String
    var tailleTShirt: String
    var vegetarien: Bool
    var jeuPrefere: String?
    
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
