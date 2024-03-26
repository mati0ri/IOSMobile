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
                Image("logo-FDJ") // Utilisation de l'image à la place du texte
                                    .resizable() // Rend l'image redimensionnable
                                    .scaledToFit() // Assure que le logo s'adapte à l'espace disponible tout en conservant ses proportions
                                    .frame(height: 160)


                if viewModel.isLoading || nextAffectationViewModel.isLoading {
                    ProgressView()
                } else {
                    NextAffectationCard(affectation: nextAffectationViewModel.nextAffectation)

                    Text("Cette année, le festival du jeu c'est")
                    HStack {
                        StatisticCard(label: "bénévoles", number: "33")
                        StatisticCard(label: "éditeurs", number: "96")
                        StatisticCard(label: "jeux", number: "262")
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
    let number: String

    var body: some View {
        VStack(spacing: 4) { // Ajoutez un petit espace entre le nombre et le label si nécessaire
            Text(number)
                .font(.system(size: 22)) // Ajustez la taille de la police comme vous le souhaitez
                .fontWeight(.bold)
            Text(label)
        }
        .foregroundColor(.white)
        .padding(.vertical, 8) // Ajustez le padding vertical pour permettre à l'ensemble du contenu de rentrer
        .frame(minWidth: 0, maxWidth: .infinity) // Permet à la carte de s'étendre horizontalement
        .background(Colors.BleuGris.opacity(0.9))
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
                .foregroundColor(soiree.estInscrit ? .green : .gray)
        }
        .frame(width: 200, height: 110)
        .background(soiree.estInscrit ? Colors.VertClair.opacity(0.2) : Colors.BleuGris.opacity(0.2))
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
                        .fontWeight(.bold)
                        .foregroundColor(Colors.BleuFonce.opacity(1))

                    Text("\(affectation.affectation.horaire.jour) \(affectation.affectation.horaire.horaire.convertirPlageHoraire())")
                        .foregroundColor(Colors.BleuFonce.opacity(1))
                } else {
                    Text("Pas de prochaine affectation")
                        .foregroundColor(.secondary)
                }
            }
            .frame(width: 340, height: 160)
            .background(Colors.VertClair.opacity(0.2))
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
