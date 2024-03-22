//
//  ReservationViewModel.swift
//  Festival du Jeu IOS
//
//  Created by Lénaïs Desbos on 22/03/2024.
//

import SwiftUI

class ReservationViewModel: ObservableObject {
    
    let id = UUID()
    var hebergement: HebergementModel
    
    init(hebergement: HebergementModel) {
        self.hebergement = hebergement
    }
    
}
