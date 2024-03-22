//
//  ReservationView.swift
//  Festival du Jeu IOS
//
//  Created by Lénaïs Desbos on 22/03/2024.
//

import SwiftUI

struct ReservationView: View {
    
    @ObservedObject var reservationViewModel: ReservationViewModel

    public let hebergement: HebergementModel
    public let jour: Jours
    public var reste: Int?
    
    @State public var isReserved = false
    
    init(hebergement: HebergementModel, jour: Jours, reste: Int? = nil) {
        self.hebergement = hebergement
        self.jour = jour
        self.reste = reste ?? hebergement.nbPlace
        self._reservationViewModel = ObservedObject(wrappedValue: ReservationViewModel(hebergement: hebergement))
    }
    
    var body: some View {
        
        VStack {
            
            Spacer()
            
            Text(hebergement.adresse)
                .font(.title)
                .foregroundColor(Colors.BleuFonce)
            
            Text("Nombre de places: \(hebergement.nbPlace)")
                .foregroundColor(.secondary)
            
            Divider()
            
            Text(jour.rawValue)
            
            HStack {
                Text("Nombres de places restantes:")
                    .font(.headline)
                Text("\(reste!.description)")
            }
            
            Spacer()
            
            if !isReserved {
                Button("Réserver") {
                    print("Réserver")
                    reservationViewModel.makeReservation(date: jour.rawValue) { result in
                        switch result {
                        case .success:
                            // Handle success
                            isReserved = true
                        case .failure(let error):
                            // Handle failure
                            print("Error making reservation: \(error.localizedDescription)")
                        }
                    }
                }
            } else {
                Button("Annuler la réservation") {
                    print("Annuler la réservation")
                    isReserved = false
                }
                .foregroundColor(Color.red)
            }
            
        }
        .navigationTitle("Reservation")
    }
}
