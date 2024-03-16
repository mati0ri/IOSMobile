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
                Button(action: {
                    // Code pour gérer la navigation vers la page 1
                }) {
                    Text("Page 1").foregroundColor(Colors.BleuFonce)
                }
                Spacer()
                Button(action: {
                    // Code pour gérer la navigation vers la page 2
                }) {
                    Text("Page 2").foregroundColor(Colors.BleuFonce)
                }
                Spacer()
                Button(action: {
                    // Code pour gérer la navigation vers la page 3
                }) {
                    Text("Page 3").foregroundColor(Colors.BleuFonce)
                }
                Spacer()
            }
            .padding()
            .background(Colors.VertFonce)
        }
    }
}
