//
//  AffectationView.swift
//  Festival du Jeu IOS
//
//  Created by Lénaïs Desbos on 18/03/2024.
//

import SwiftUI

struct AffectationView: View {
    
    @ObservedObject public var affectation: AffectationViewModel
    
    // Fonction pour convertir le format "plage_X_Y" en "Xh - Yh"
    private func formatPlageHoraire(_ plageHoraire: String) -> String {
        let components = plageHoraire.components(separatedBy: "_")
        if components.count == 3, let debut = Int(components[1]), let fin = Int(components[2]) {
            return "\(debut)h - \(fin)h"
        } else {
            return "Format de plage horaire invalide"
        }
    }

    init(affectation: AffectationViewModel){
        self.affectation = affectation
    }
    
    var body: some View{
        
        VStack {
            
            Text("\(affectation.affectation.horaire.jour)   \(formatPlageHoraire(affectation.affectation.horaire.horaire))")
                .font(.title).foregroundColor(Colors.BleuFonce)
            
            if affectation.affectation.listePostes.count > 1 {
                Text("Liste des postes où vous avez postulé :")
                ForEach(affectation.affectation.listePostes, id: \.id) { poste in
                    VStack(alignment: .leading, spacing: 10) {
                        Text(poste.intitule)
                            .font(.title)
                            .multilineTextAlignment(.center)
                    }
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Equipe :").font(.headline)
                        Divider()
                            .padding(.vertical)
                        Text("Détails du poste :").font(.headline)
                        Text(poste.details)
                    }
                }
            } else {
                let poste = affectation.affectation.listePostes.first
                VStack(alignment: .leading, spacing: 10) {
                    Text(poste!.intitule)
                        .font(.title)
                        .multilineTextAlignment(.center)
                }
                VStack(alignment: .leading, spacing: 10) {
                    Text("Equipe :").font(.headline)
                    Divider()
                        .padding(.vertical)
                    Text("Détails du poste :").font(.headline)
                    Text(poste!.details)
                        .lineLimit(nil)
                }
            }
            
            Spacer()
            
            Button("Se désister") {
                print("Se désister")
            }.foregroundColor(Color.red)
            
        }.padding()
        
    }
    
}
