//
//  HoraireModel.swift
//  Festival du Jeu IOS
//
//  Created by Lénaïs Desbos on 18/03/2024.
//

import SwiftUI

struct HoraireModel: Decodable {
    
    let jour: String
    let horaire: String
    
    init(jour: String, horaire: String) {
        self.jour = jour
        self.horaire = horaire
    }
    
}
