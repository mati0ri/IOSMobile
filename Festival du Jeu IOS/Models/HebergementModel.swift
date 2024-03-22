//
//  HebergementModel.swift
//  Festival du Jeu IOS
//
//  Created by Lénaïs Desbos on 22/03/2024.
//

//
//  HebergementModel.swift
//  Festival du Jeu IOS
//
//  Created by Lénaïs Desbos on 19/03/2024.
//

import SwiftUI

struct HebergementModel: Decodable {
    
    public var hebergementId: String
    public var nbPlace: Int
    public var adresse: String
    public var jours: [Jours]
    public var hebergeurId: String
    public var hebergeur: UserModel?
    public var reservations: [ReservationModel]?
    
    init(hebergementId: String, nbPlace: Int, adresse: String, jours: [Jours], hebergeurId: String, hebergeur: UserModel?, reservations: [ReservationModel]) {
        self.hebergementId = hebergementId
        self.nbPlace = nbPlace
        self.adresse = adresse
        self.jours = jours
        self.hebergeurId = hebergeurId
        self.hebergeur = hebergeur
        self.reservations = reservations
    }
    
}
