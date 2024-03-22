//
//  ChoixHebergementView.swift
//  Festival du Jeu IOS
//
//  Created by Lénaïs Desbos on 22/03/2024.
//

import SwiftUI

struct ChoixHebergementView: View {
    
    @StateObject var chercherHebergementViewModel = ChercherHebergementViewModel()
    public let hebergement: HebergementModel
    public let jour: Jours
    @State private var reste: Int?

    var body: some View {
        
        VStack {
            NavigationLink(destination: ReservationView()) {
                VStack {
                    Text("Adresse: \(hebergement.adresse)")
                    if let reste = reste {
                        Text("Places restantes: \(reste)")
                    } else {
                        Text("Places: \(hebergement.nbPlace)")
                    }
                }
                .onAppear {
                    chercherHebergementViewModel.getNbReservationByHebergementId(id: hebergement.hebergementId, date: jour.rawValue) { nbReservations in
                        if let nbReservations = nbReservations {
                            reste = hebergement.nbPlace - nbReservations
                        } else {
                            // Gérer le cas où la récupération du nombre de réservations a échoué
                            self.reste = 0
                        }
                    }
                }
            }
        }
    }
}
