//
//  ReservationView.swift
//  Festival du Jeu IOS
//
//  Created by Lénaïs Desbos on 22/03/2024.
//

import SwiftUI

struct ReservationView: View {
    
    @ObservedObject var reservationViewModel: ReservationViewModel
    
    @StateObject var chercherHebergementViewModel = ChercherHebergementViewModel()
    @State private var reste: Int?

    public let hebergement: HebergementModel
    public let jour: Jours
    public var resa: ReservationModel?
    
    @State public var isReserved: Bool
    @State private var showAlert: Bool = false // Contrôle la visibilité de l'alerte
    @State private var alertMessage: String? // Message à afficher dans l'alerte
    
    init(hebergement: HebergementModel, jour: Jours, reserved: Bool?, resa: ReservationModel? = nil) {
        self.hebergement = hebergement
        self.jour = jour
        self.isReserved = reserved ?? false
        self.resa = resa
        self.reste = hebergement.nbPlace
        self._reservationViewModel = ObservedObject(wrappedValue: ReservationViewModel(hebergement: hebergement, reservation: resa))
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
                            showAlert = true
                            alertMessage = "La réservation a été effectuée avec succès."
                            reste! -= 1
                        case .failure(let error):
                            // Handle failure
                            print("Error making reservation: \(error.localizedDescription)")
                            showAlert = true
                            alertMessage = "Échec de la réservation : \(error.localizedDescription)"
                        }
                    }
                }
            } else {
                Button("Annuler la réservation") {
                    print("Annuler la réservation")
                    reservationViewModel.deleteReservation { result in
                        switch result {
                        case .success:
                            // Handle success
                            isReserved = false
                            showAlert = true
                            alertMessage = "La réservation a été annulée avec succès."
                            reste! += 1
                        case .failure(let error):
                            // Handle failure
                            print("Error deleting reservation: \(error.localizedDescription)")
                            showAlert = true
                            alertMessage = "Échec de l'annulation de la réservation : \(error.localizedDescription)"
                        }
                    }
                }
                .foregroundColor(Color.red)
            }
            
        }
        .navigationTitle("Reservation")
        .padding()
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Message"), message: Text(alertMessage ?? ""), dismissButton: .default(Text("OK")))
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
