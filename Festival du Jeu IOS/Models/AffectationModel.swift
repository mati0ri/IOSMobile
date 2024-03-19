//
//  AffectationModel.swift
//  Festival du Jeu IOS
//
//  Created by Lénaïs Desbos on 18/03/2024.
//

import SwiftUI

struct AffectationModel: Decodable {
    
    let id: String
    let listePostes: [PosteModel]
    let user: UserModel?
    let horaire: HoraireModel
    let zone: ZoneModel?
    var confirmation: Bool
    let posteEnAttenteValidation: PosteModel?
    var flexible: Bool
    var postesProposes: [PosteModel]?
    
    init(id: String, listePostes: [PosteModel], user: UserModel, horaire: HoraireModel, zone: ZoneModel?, confirmation: Bool, posteEnAttenteValidation: PosteModel?, flexible: Bool, postesProposes: [PosteModel]) {
        self.id = id
        self.listePostes = listePostes
        self.user = user
        self.horaire = horaire
        self.zone = zone
        self.confirmation = confirmation
        self.posteEnAttenteValidation = posteEnAttenteValidation
        self.flexible = flexible
        self.postesProposes = postesProposes
    }

}
