//
//  ReservationModel.swift
//  Festival du Jeu IOS
//
//  Created by Lénaïs Desbos on 22/03/2024.
//

//
//  ReservationModel.swift
//  Festival du Jeu IOS
//
//  Created by Lénaïs Desbos on 19/03/2024.
//

import SwiftUI

struct ReservationModel: Decodable {
    
    public var reservationId: String
    public var hebergementId: String
    public var jour: Jours
    public var hebergement: HebergementModel
    public var user: UserModel?
    public var userId: String
    
    init(reservationId: String, hebergementId: String, jour: Jours, hebergement: HebergementModel, user: UserModel?, userId: String) {
        self.reservationId = reservationId
        self.hebergementId = hebergementId
        self.jour = jour
        self.hebergement = hebergement
        self.user = user
        self.userId = userId
    }
}
