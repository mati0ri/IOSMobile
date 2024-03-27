//
//  JeuView.swift
//  Festival du Jeu IOS
//
//  Created by Lénaïs Desbos on 16/03/2024.
//

import SwiftUI

struct JeuView: View {
    
    @ObservedObject public var jeu: JeuViewModel
    
    @State public var zone: String = "Pas de zone attribuée"
    
    init(jeu: JeuViewModel){
        self.jeu = jeu
    }
    
    var body: some View{
        
        VStack {
            
            VStack(alignment: .leading, spacing: 10) {
                Text("\(jeu.nom)")
                    .font(.title)
                    .multilineTextAlignment(.center)
            }
            
            VStack(alignment: .leading, spacing: 10) {

                Text("Editeur: \(jeu.editeur)")
                    .foregroundColor(.secondary)

                Text("Type: \(jeu.type)")
                    .foregroundColor(.secondary)
                
                Text("Zone: \(zone)")
                    .foregroundColor(.secondary)

                Divider()
                    .padding(.vertical)

                Text("Description:")
                    .font(.headline)

                Text("La description du jeu est manquante.")
                    .padding(.top, 5)

                Divider()
                    .padding(.vertical)

                if let noticeURL = URL(string: jeu.notice) {
                    HStack {
                        Image(systemName: "link")
                            .foregroundColor(.blue)

                        Link("Lien Notice", destination: noticeURL)
                            .foregroundColor(.blue)
                    }
                } else {
                    Text("Notice: N/A")
                        .foregroundColor(.secondary)
                }

                if let videoURL = URL(string: jeu.video) {
                    HStack {
                        Image(systemName: "play.rectangle")
                            .foregroundColor(.blue)

                        Link("Lien vidéo", destination: videoURL)
                            .foregroundColor(.blue)
                    }
                } else {
                    Text("Lien vidéo: N/A")
                        .foregroundColor(.secondary)
                }
            }.padding()

        }.onAppear() {
            jeu.getZoneJeu(zoneId: jeu.zoneId) { zoneResult in
                if let zoneResult = zoneResult {
                    self.zone = zoneResult
                } else {
                    self.zone = "Erreur lors de la récupération de la zone"
                }
            }
        }
    }
}
