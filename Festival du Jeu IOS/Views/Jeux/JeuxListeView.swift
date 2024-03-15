//
//  JeuxListeView.swift
//  Festival du Jeu IOS
//
//  Created by Lénaïs Desbos on 15/03/2024.
//

import SwiftUI

struct JeuxListeView: View {
    
    //@State public var jeux = [ JeuViewModel(jeu: JeuModel(nom: "That's Life", editeur: "James Brown", type: "Gettin' Down to It", notice: "1969-05-01T12:00:00Z", zone:"null", aAnimer: true, recu: true, video: "hhtp://lien-video")), JeuViewModel(jeu: JeuModel(nom: "Shoot the Moon", editeur: "Norah Jones", type: "Come Away With Me (Deluxe Edition)", notice: "2002-02-26T08:00:00Z", zone:"null", aAnimer: true, recu: true, video: "http://lien-video2")) ]
    @StateObject var jeuxListeViewModel = JeuxListeViewModel()
    @State private var jeux: [JeuViewModel] = []
    
    
    var body: some View{
        
        VStack{
            //NavigationView{
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
           // }
            
        }.onAppear {
            // Charger les jeux depuis l'API lorsque la vue apparaît
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
