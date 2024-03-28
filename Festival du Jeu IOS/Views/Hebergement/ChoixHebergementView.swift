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
            NavigationLink(destination: ReservationView(hebergement: hebergement, jour: jour, reserved: false)) {
                HStack {
                    Spacer()
                    VStack {
                        Text("Adresse: \(hebergement.adresse)")
                        if let reste = reste {
                            Text("Places restantes: \(reste)")
                        } else {
                            Text("Places: \(hebergement.nbPlace)")
                        }
                    }
                    Spacer()
                }
                .onAppear {
                    chercherHebergementViewModel.getNbReservationByHebergementId(id: hebergement.hebergementId, date: jour.rawValue) { nbReservations in
                        if let nbReservations = nbReservations {
                            reste = hebergement.nbPlace - nbReservations
                        } else {
                            self.reste = 0
                        }
                    }
                }
            }
        }
    }
}
