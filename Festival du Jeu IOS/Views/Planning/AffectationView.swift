//
//  AffectationView.swift
//  Festival du Jeu IOS
//
//  Created by Lénaïs Desbos on 18/03/2024.
//

import SwiftUI

struct AffectationView: View {
    
    @ObservedObject public var affectation: AffectationViewModel

    init(affectation: AffectationViewModel){
        self.affectation = affectation
    }
    
    var body: some View{
        
        VStack {
            Text("Affectation")
        }
        
    }
    
}
