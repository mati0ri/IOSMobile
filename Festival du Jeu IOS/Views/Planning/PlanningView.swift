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
    
    //@State public var test = [ AffectationViewModel(), AffectationViewModel(jeu: JeuModel(nom: "Shoot the Moon", editeur: "Norah Jones", type: "Come Away With Me (Deluxe Edition)", notice: "2002-02-26T08:00:00Z", zone:"null", aAnimer: true, recu: true")) ]
//let affectation: [AffectationModel] = [AffectationModel(listePostes: <#T##[PosteModel]#>, user: <#T##UserModel#>, horaire: <#T##HoraireModel#>, zone: <#T##ZoneModel?#>, confirmation: <#T##Bool#>, posteEnAttenteValidation: <#T##PosteModel?#>, flexible: <#T##Bool#>, postesProposes: <#T##[PosteModel]#>)]
    
    
    var body: some View{
        
        VStack{
            
                VStack {
                    if !affectations.isEmpty {
                        List {
                            ForEach(affectations, id: \.id) { affectation in
                                NavigationLink(destination: AffectationView(affectation: affectation)) {
                                    Text("Affectation")
                                }
                            }
                        }
                    } else {
                        Text("Chargement en cours...")
                    }
                    
                }.navigationTitle("Planning")
            
        }.onAppear {
            planningViewModel.getAffectationsByUserId { fetchedAffectations in
                if let fetchedAffectations = fetchedAffectations {
                    self.affectations = fetchedAffectations
                    print("Affectations récupérés avec succès :")
                    for affectation in fetchedAffectations {
                        print(affectation)
                    }
                } else {
                    print("Erreur lors de la récupération des affectations.")
                }
            }
        }
        
    }
    
}
