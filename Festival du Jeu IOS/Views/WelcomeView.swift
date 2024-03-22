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

                if viewModel.isLoading || nextAffectationViewModel.isLoading {
                    ProgressView()
                } else {
                    NextAffectationCard(affectation: nextAffectationViewModel.nextAffectation)

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
                                    .frame(height: 200)
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
                    Text("Prochaine affectation: \(affectation.poste.intitule)")
                    Text("Jour: \(affectation.affectation.horaire.jour)")
                    Text("Horaire: \(affectation.affectation.horaire.horaire)")

                        .padding()
                } else {
                    Text("Pas de prochaine affectation")
                        .foregroundColor(.secondary)
                }
            }
            .frame(width: 300, height: 150)
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




struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}
