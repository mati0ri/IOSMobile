//
//  PlanningView.swift
//  Festival du Jeu IOS
//
//  Created by Lénaïs Desbos on 18/03/2024.
//

import SwiftUI

struct PlanningView: View {
    
    @StateObject var planningViewModel = PlanningViewModel()
    @State private var affectations: [AffectationViewModel] = []
    
    @State private var saturdayAffectations: [AffectationViewModel] = []
    @State private var sundayAffectations: [AffectationViewModel] = []
    
    @State private var aucuneAffectation = false
    
    private func extractHour(from plageHoraire: String) -> Int? {
        let components = plageHoraire.components(separatedBy: "_")
        if components.count == 3, let debut = Int(components[1]) {
            return debut
        }
        return nil
    }
    
    private func splitAffectationsByDay() {
        
        affectations.sort { (affectation1, affectation2) -> Bool in
            if let debut1 = extractHour(from: affectation1.affectation.horaire.horaire),
               let debut2 = extractHour(from: affectation2.affectation.horaire.horaire) {
                return debut1 < debut2
            }
            return false
        }
        
        saturdayAffectations = affectations.filter { $0.affectation.horaire.jour == "Samedi" }
        sundayAffectations = affectations.filter { $0.affectation.horaire.jour == "Dimanche" }
    }
    
    private func formatPlageHoraire(_ plageHoraire: String) -> String {
        let components = plageHoraire.components(separatedBy: "_")
        if components.count == 3, let debut = Int(components[1]), let fin = Int(components[2]) {
            return "\(debut)h - \(fin)h"
        } else {
            return "Format de plage horaire invalide"
        }
    }
    
    var body: some View{
  
        VStack {
        
            if !affectations.isEmpty {
                
                if !saturdayAffectations.isEmpty {
                    VStack {
                        Text("Samedi").font(.title.bold())
                        List {
                            ForEach(saturdayAffectations, id: \.id) { affectation in
                                NavigationLink(destination: AffectationView(affectation: affectation)) {
                                    if affectation.affectation.horaire.jour == "Samedi" {
                                        if affectation.affectation.listePostes.count > 1 {
                                            HStack {
                                                Spacer()
                                                VStack {
                                                    Text(formatPlageHoraire(affectation.affectation.horaire.horaire))
                                                    Text("Poste à définir").bold()
                                                }
                                                Spacer()
                                            }
                                        } else {
                                            HStack {
                                                Spacer()
                                                VStack {
                                                    Text(formatPlageHoraire(affectation.affectation.horaire.horaire))
                                                    Text(affectation.affectation.listePostes.first?.intitule ?? "Pas d'intitulé de poste").bold()
                                                    if affectation.affectation.zone != nil {
                                                        Text(affectation.affectation.zone?.nom ?? "Pas encore de zone définie")
                                                    }
                                                }
                                                Spacer()
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                    
                
                if !sundayAffectations.isEmpty {
                    VStack {
                        Text("Dimanche").font(.title.bold()).foregroundColor(Colors.BleuFonce)
                        List {
                            ForEach(sundayAffectations, id: \.id) { affectation in
                                NavigationLink(destination: AffectationView(affectation: affectation)) {
                                    if affectation.affectation.horaire.jour == "Dimanche" {
                                        if affectation.affectation.listePostes.count > 1 {
                                            HStack {
                                                Spacer()
                                                VStack {
                                                    Text(formatPlageHoraire(affectation.affectation.horaire.horaire))
                                                    Text("Poste à définir").bold()
                                                }
                                                Spacer()
                                            }
                                        } else {
                                            HStack {
                                                Spacer()
                                                VStack {
                                                    Text(formatPlageHoraire(affectation.affectation.horaire.horaire))
                                                    Text(affectation.affectation.listePostes.first?.intitule ?? "Pas d'intitulé de poste").bold()
                                                    if affectation.affectation.zone != nil {
                                                        Text(affectation.affectation.zone?.nom ?? "Pas encore de zone définie")
                                                    }
                                                }
                                                Spacer()
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                
            } else if aucuneAffectation {
                Text("Vous n'êtes affecté à aucun poste pour le moment.")
                Button("S'inscrire à un poste") {
                    print("Lien vers inscription à ajouter")
                }
            } else {
                Text("Chargement en cours...")
            }
            
        }.navigationTitle("Planning")
            .onAppear {
            planningViewModel.getAffectationsByUserId { fetchedAffectations in
                if let fetchedAffectations = fetchedAffectations {
                    self.affectations = fetchedAffectations
                    
                    if fetchedAffectations.isEmpty {
                        self.aucuneAffectation = true
                        print("Aucune affectation récupérée.")
                    } else {
                        self.splitAffectationsByDay()
                        print("Affectations récupérés avec succès :")
                        for affectation in fetchedAffectations {
                            print(affectation)
                        }
                    }
                } else {
                    print("Erreur lors de la récupération des affectations.")
                }
            }
        }
        
    }
    
}

struct PlanningView_Previews: PreviewProvider {
    static var previews: some View {
        PlanningView()
    }
}
