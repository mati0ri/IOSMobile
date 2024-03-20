//
//  Footer.swift
//  Festival du Jeu IOS
//
//  Created by Lénaïs Desbos on 16/03/2024.
//

import SwiftUI

struct Footer: View {
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Button("Page 1") {
                    // Code pour gérer la navigation vers la page 1
                }.foregroundColor(Colors.BleuFonce)
                Spacer()
                
                NavigationLink(destination: PlanningView()) {
                    Text("Planning")
                }.foregroundColor(Colors.BleuFonce)
                
                Spacer()
                
                NavigationLink(destination: JeuxListeView()) {
                    Text("Jeux")
                }.foregroundColor(Colors.BleuFonce)
                
                Spacer()
                
                NavigationLink(destination: ProfileView()) {
                    Text("Profil")
                }.foregroundColor(Colors.BleuFonce)
            }
            .padding()
            .background(Colors.VertFonce)
        }
    }
}
