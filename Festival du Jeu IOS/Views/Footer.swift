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
                Button("Page 2") {
                    // Code pour gérer la navigation vers la page 2
                }.foregroundColor(Colors.BleuFonce)
                Spacer()
                
                    NavigationLink(destination: JeuxListeView()) {
                        Text("Jeux")
                    }.foregroundColor(Colors.BleuFonce)
                
                Spacer()
            }
            .padding()
            .background(Colors.VertFonce)
        }
    }
}
