//
//  AffectationViewModel.swift
//  Festival du Jeu IOS
//
//  Created by Lénaïs Desbos on 18/03/2024.
//

import SwiftUI

class AffectationViewModel: ObservableObject {
    
    //private let loginURL = "https://backawi.onrender.com/api/user/login"
    
    let id = UUID();
    var affectation : AffectationModel
    
    init(affectation: AffectationModel) {
        self.affectation = affectation
    }
    
    
}
