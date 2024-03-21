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
                    // Use the new NextAffectationCard view to show next assignment
                    NextAffectationCard(affectation: nextAffectationViewModel.nextAffectation)

                    // Display the list of "soirées découvertes"
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 15) {
                            ForEach(viewModel.soireesDecouvertes) { soiree in
                                SoireeDecouverteCard(soiree: soiree)
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
            Text("Lieu: \(soiree.lieu)")
            Text(soiree.estInscrit ? "Inscrit" : "Non inscrit") // Display registration status
                .foregroundColor(soiree.estInscrit ? .green : .red)
            // Add additional details and styling...
        }
        .frame(width: 200, height: 100)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(12)
        // Further customize your card view here...
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

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}
