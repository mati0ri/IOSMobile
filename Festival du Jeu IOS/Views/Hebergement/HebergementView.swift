//
//  HebergementView.swift
//  Festival du Jeu IOS
//
//  Created by Lénaïs Desbos on 22/03/2024.
//

//
//  HebergementView.swift
//  Festival du Jeu IOS
//
//  Created by Lénaïs Desbos on 19/03/2024.
//

import SwiftUI

struct HebergementView: View {
    
    var body: some View {
        
        VStack {
            
            NavigationLink(destination: ProposerHebergementView()) {
                Text("Proposer un hébergement")
            }.buttonStyle(.borderedProminent).tint(Colors.VertFonce)
            
            Text("ou")
            
            NavigationLink(destination: ChercherHebergementView()) {
                Text("Chercher un hébergement")
            }.buttonStyle(.borderedProminent).tint(Colors.BleuFonce)
            
        }.navigationTitle("Hebergement")
        
    }
    
}
