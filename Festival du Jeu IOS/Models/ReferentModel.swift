//
//  ReferentModel.swift
//  Festival du Jeu IOS
//
//  Created by Lénaïs Desbos on 18/03/2024.
//

import SwiftUI

struct ReferentModel: Decodable {
    
    let referent: UserModel
    let horaire: HoraireModel
    
    init(referent: UserModel, horaire: HoraireModel) {
        self.referent = referent
        self.horaire = horaire
    }
    
}
