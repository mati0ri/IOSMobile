//
//  ZoneModel.swift
//  Festival du Jeu IOS
//
//  Created by Lénaïs Desbos on 18/03/2024.
//

import SwiftUI

struct ZoneModel: Decodable {
    
    let nom: String
    let jeux: [JeuModel]?
    
    init(nom: String, jeux: [JeuModel]) {
        self.nom = nom
        self.jeux = jeux
    }
    
}
