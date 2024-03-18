//
//  HoraireModel.swift
//  Festival du Jeu IOS
//
//  Created by Lénaïs Desbos on 18/03/2024.
//

import SwiftUI

struct HoraireModel: Decodable {
    
    let id: String
    let jour: String
    let horaire: String
    
    init(id: String, jour: String, horaire: String) {
        self.id = id
        self.jour = jour
        self.horaire = horaire
    }
    
}
