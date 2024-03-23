//
//  WelcomeView.swift
//  Festival du Jeu IOS
//
//  Created by Mateo iori on 15/03/2024.
//

import SwiftUI

struct WelcomeView: View {
    @StateObject private var viewModel = WelcomeViewModel()
    @StateObject private var nextAffectationViewModel = NextAffectationViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Accueil")
                    .font(.largeTitle)
                    .fontWeight(.semibold)

//                Text("Bienvenue")


                if viewModel.isLoading || nextAffectationViewModel.isLoading {
                    ProgressView()
                } else {
                    NextAffectationCard(affectation: nextAffectationViewModel.nextAffectation)

                    Text("Cette année, le festival du jeu c'est")
                    HStack {
                        StatisticCard(label: "33 bénévoles")
                        StatisticCard(label: "96 éditeurs")
                        StatisticCard(label: "262 jeux")
                    }.padding()

                    Text("Les prochaines soirées découvertes")

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 15) {
                            ForEach(viewModel.soireesDecouvertes) { soiree in
                                NavigationLink(destination: SoireeDetailView(soiree: soiree, viewModel: viewModel)) {
                                    SoireeDecouverteCard(soiree: soiree)
                                }
                            }
                        }
                        .padding()
                    }
                    .frame(height: 120)
                }

                Footer()
            }
            .onAppear {
                viewModel.fetchSoireesDecouvertes()
                nextAffectationViewModel.fetchNextAffectation()
            }
        }
    }
}

struct StatisticCard: View {
    let label: String

    var body: some View {
        Text(label)
            .fontWeight(.bold)
            .foregroundColor(.blue)
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(12)
    }
}




struct SoireeDecouverteCard: View {
    let soiree: SoireeDecouverteModel

    var body: some View {
        VStack {
            Text(soiree.nom)
                .fontWeight(.bold)
                .foregroundColor(Color.black)
            Text("\(soiree.lieu)")
                .foregroundColor(Colors.GrisFonce)
            
            Text(soiree.estInscrit ? "Inscrit" : "Non inscrit")
                .foregroundColor(soiree.estInscrit ? .green : .red)
        }
        .frame(width: 200, height: 100)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(12)
    }
}

struct NextAffectationCard: View {
    let affectation: NextAffectationModel?

    var body: some View {
        NavigationLink(destination: PlanningView()) {
            VStack {
                if let affectation = affectation {
                    Text("Ta prochaine affectation")
                        .foregroundColor(.secondary)

                    Text("\(affectation.poste.intitule)")
                    Text("\(affectation.affectation.horaire.jour)")
                    Text("Horaire: \(affectation.affectation.horaire.horaire.convertirPlageHoraire())")
                } else {
                    Text("Pas de prochaine affectation")
                        .foregroundColor(.secondary)
                }
            }
            .frame(width: 340, height: 170)
            .background(Color.blue.opacity(0.1))
            .cornerRadius(12)
            .padding()
        }
    }
}


struct SoireeDetailView: View {
    let soiree: SoireeDecouverteModel
    @ObservedObject var viewModel: WelcomeViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text(soiree.nom)
                .font(.title)
                .fontWeight(.bold)
            Text("Date: \(soiree.date)")
            Text("Lieu: \(soiree.lieu)")
            
            Text("Jeux:")
            ForEach(soiree.jeux) { jeu in
                Text(jeu.nom)
            }

            Spacer()
            
            if soiree.isUserRegistered(userId: TokenManager.getUserIdFromToken() ?? "pas de token") {
                            Button("Se désister") {
                                viewModel.deregisterFromSoiree(userId: TokenManager.getUserIdFromToken() ?? "pas de token", soireeId: soiree.id)
                            }
                            .foregroundColor(.red)
                        } else {
                            Button("S'inscrire") {
                                viewModel.registerForSoiree(userId: TokenManager.getUserIdFromToken() ?? "pas de token", soireeId: soiree.id)
                            }
                            .foregroundColor(.green)
                        }
        }
        .padding()
        // Removed the .navigationBarItems modifier with the "Fermer" button
    }
}

extension String {
    func convertirPlageHoraire() -> String {
        let composants = self.split(separator: "_")
        if composants.count == 3 {
            let debut = String(composants[1])
            let fin = String(composants[2])
            return "\(debut)h - \(fin)h"
        } else {
            return self // Retourne la chaîne originale si le format n'est pas respecté
        }
    }
}




struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}
