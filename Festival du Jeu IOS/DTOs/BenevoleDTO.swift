//
//  BenevoleDTO.swift
//  Festival du Jeu IOS
//
//  Created by Mateo iori on 13/03/2024.
//

import Foundation

struct BenevoleDTO: Codable, Hashable, Equatable {
    var id: String
    var nom: String
    var prenom: String
    var email: String
    var motDePasse: String
    var nombreEditionPrecedente: Int?
    var pseudo: String
    var telephone: String
    var photoDeProfil: String
    var vegetarien: Bool
    var jeuPrefereId: String?
    var association: String
    var choixHebergement: String
    var role: String
    var tailleTShirt: String
    
    // Les relations comme `affectations`, `heberge`, etc., si vous souhaitez les inclure, devraient être des tableaux de leurs DTO respectifs.
    // var affectations: [AffectationDTO]
    // var heberge: [HebergementDTO]
    // etc...

    // Initialiser tous les champs. Les champs optionnels sont initialisés avec des valeurs par défaut si non spécifiés.
    init(id: String = "", nom: String = "", prenom: String = "", email: String = "", motDePasse: String = "", nombreEditionPrecedente: Int? = nil, pseudo: String = "", telephone: String = "", photoDeProfil: String = "https://www.pngitem.com/pimgs/m/146-1468479_my-profile-icon-blank-profile-picture-circle-hd.png", vegetarien: Bool = false, jeuPrefereId: String? = nil, association: String = "AUCUNE", choixHebergement: String = "PAS_CONCERNE", role: String = "BENEVOLE", tailleTShirt: String = "M") {
        self.id = id
        self.nom = nom
        self.prenom = prenom
        self.email = email
        self.motDePasse = motDePasse
        self.nombreEditionPrecedente = nombreEditionPrecedente
        self.pseudo = pseudo
        self.telephone = telephone
        self.photoDeProfil = photoDeProfil
        self.vegetarien = vegetarien
        self.jeuPrefereId = jeuPrefereId
        self.association = association
        self.choixHebergement = choixHebergement
        self.role = role
        self.tailleTShirt = tailleTShirt
    }

    // La fonction hash pour conformer à Hashable.
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    // La fonction pour comparer deux `BenevoleDTO`.
    static func == (lhs: BenevoleDTO, rhs: BenevoleDTO) -> Bool {
        lhs.id == rhs.id
    }

    // Les CodingKeys pour déterminer comment les propriétés correspondent aux clés JSON lors de la codification et de la décodification.
    enum CodingKeys: String, CodingKey {
        case id
        case nom
        case prenom
        case email
        case motDePasse
        case nombreEditionPrecedente
        case pseudo
        case telephone
        case photoDeProfil
        case vegetarien
        case jeuPrefereId
        case association
        case choixHebergement
        case role
        case tailleTShirt
    }
    
    // Fonction pour obtenir le corps de la requête sous forme de dictionnaire pour l'envoi de données via des requêtes réseau.
    func getBody() -> [String: Any] {
        return [
            "id": id,
            "nom": nom,
            "prenom": prenom,
            "email": email,
            "telephone": telephone,
            "photoDeProfil": photoDeProfil,
            "vegetarien": vegetarien,
            "association": association,
            "choixHebergement": choixHebergement,
            "role": role,
            "tailleTShirt": tailleTShirt
            // Add other fields as needed.
        ]
    }
    
    // Fonction pour représenter l'instance de `BenevoleDTO` sous forme de String.
    func toString() -> String {
        return "\(nom) \(prenom) (\(email))"
    }
}

