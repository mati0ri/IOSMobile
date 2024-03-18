//
//  EquipeViewModel.swift
//  Festival du Jeu IOS
//
//  Created by Lénaïs Desbos on 18/03/2024.
//

import SwiftUI

class EquipeViewModel: ObservableObject {
    
    let id = UUID()
    var membre: UserModel
    
    init(membre: UserModel) {
        self.membre = membre
    }
    
}
