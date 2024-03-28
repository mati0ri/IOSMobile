//
//  JeuxListeView.swift
//  Festival du Jeu IOS
//
//  Created by Lénaïs Desbos on 16/03/2024.
//

import SwiftUI

struct JeuxListeView: View {
    
    @StateObject var jeuxListeViewModel = JeuxListeViewModel()
    @State private var jeux: [JeuViewModel] = []
    
    
    var body: some View{
        
        VStack{
            
                VStack {
                    if !jeux.isEmpty {
                        List {
                            ForEach(jeux, id: \.id) { jeu in
                                NavigationLink(destination: JeuView(jeu: jeu)) {
                                    Text(jeu.jeu.nom)
                                }
                            }
                        }
                    } else {
                        Text("Chargement en cours...")
                    }
                    
                }.navigationTitle("Jeux")
            
        }.onAppear {
            jeuxListeViewModel.getJeux { fetchedJeux in
                if let fetchedJeux = fetchedJeux {
                    self.jeux = fetchedJeux
                    print("Jeux récupérés avec succès :")
                    for jeuViewModel in fetchedJeux {
                        print(jeuViewModel.jeu.nom)
                    }
                } else {
                    print("Erreur lors de la récupération des jeux.")
                }
            }
        }
        
    }
    
}
