//
//  PosteModel.swift
//  Festival du Jeu IOS
//
//  Created by Lénaïs Desbos on 18/03/2024.
//

import SwiftUI

struct PosteModel: Decodable {

    let intitule: String
    let details: String
    let referents: [ReferentModel]?
    let zones: [ZoneModel]?
    let nombrePlacesMin: Int
    let nombrePlacesMax: Int?
    
    init(intitule: String, details: String, referents: [ReferentModel], zones: [ZoneModel], nombrePlacesMin: Int, nombrePlacesMax: Int?) {
        self.intitule = intitule
        self.details = details
        self.referents = referents
        self.zones = zones
        self.nombrePlacesMin = nombrePlacesMin
        self.nombrePlacesMax = nombrePlacesMax
    }
    
}
