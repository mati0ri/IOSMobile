//
//  AffectationView.swift
//  Festival du Jeu IOS
//
//  Created by Lénaïs Desbos on 18/03/2024.
//

import SwiftUI

struct AffectationView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject public var affectation: AffectationViewModel
    
    //@StateObject var affectationViewModel = AffectationViewModel(affectation: affectation)
    @State private var equipe: [EquipeViewModel] = []

    
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
    
    var body: some View {
        
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
                    ForEach(equipe, id: \.id) { membre in
                        Text("\(membre.membre.prenom) \(membre.membre.nom)")
                    }
                    Divider()
                        .padding(.vertical)
                    Text("Détails du poste :").font(.headline)
                    Text(poste!.details)
                        .lineLimit(nil)
                }
            }
            
            Spacer()
            
            Button("Se désister") {
                affectation.deleteAffectation(affectationId: affectation.affectation.id) { error in
                    DispatchQueue.main.async {
                        if let error = error {
                            print("Erreur lors de la suppression : \(error)")
                        } else {
                            print("Suppression réussie")
                            // Simuler le retour en arrière
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                    }
            }.foregroundColor(Color.red)
            
        }.padding()
            .onAppear {
                affectation.getUsersWithConfirmedAffectation(horaireId: affectation.affectation.horaire.id, posteId: affectation.affectation.listePostes.first!.id) { fetchedUsers in
                    if let fetchedUsers = fetchedUsers {
                        self.equipe = fetchedUsers
                        print("Equipe récupérés avec succès :")
                        for membre in fetchedUsers {
                            print(membre)
                        }
                    } else {
                        print("Erreur lors de la récupération des membres de l'équipe.")
                    }
                }
            }
        
    }
    
}
