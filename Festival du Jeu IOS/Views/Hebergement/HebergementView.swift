//
//  HebergementView.swift
//  Festival du Jeu IOS
//
//  Created by Lénaïs Desbos on 19/03/2024.
//

import SwiftUI

struct HebergementView: View {
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 10) {
            
            Spacer()
            Text("Vous avez des places chez vous pour accueillir des bénévoles ? ").font(.title2)
            HStack {
                Spacer()
                NavigationLink(destination: ProposerHebergementView()) {
                    Text("Proposez un hébergement.")
                }
            }
            Spacer()

            Divider()
            
            Spacer()
            Text("Vous recherchez un logement pour pouvoir participer au festival ? ").font(.title2)
            HStack {
                Spacer()
                NavigationLink(destination: ChercherHebergementView()) {
                    Text("Cherchez un hébergement.")
                }
            }
            Spacer()
            
        }.navigationTitle("Hebergement")
            .padding()
        
    }
    
}
