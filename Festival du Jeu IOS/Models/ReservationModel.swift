//
//  ReservationModel.swift
//  Festival du Jeu IOS
//
//  Created by Lénaïs Desbos on 19/03/2024.
//

import SwiftUI

struct ReservationModel: Decodable, Hashable {
    
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
    
    // Implémentation de la propriété hashValue
    func hash(into hasher: inout Hasher) {
        hasher.combine(reservationId)
    }
    
    // Implémentation de la méthode isEqual
    static func == (lhs: ReservationModel, rhs: ReservationModel) -> Bool {
        return lhs.reservationId == rhs.reservationId
    }
    
}
