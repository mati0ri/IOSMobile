//
//  ChercherHebergementView.swift
//  Festival du Jeu IOS
//
//  Created by Lénaïs Desbos on 22/03/2024.
//

//
//  ChercherHebergementView.swift
//  Festival du Jeu IOS
//
//  Created by Lénaïs Desbos on 19/03/2024.
//

import SwiftUI

struct ChercherHebergementView: View {
    
    @StateObject var chercherHebergementViewModel = ChercherHebergementViewModel()
    @State private var choix: [ReservationViewModel] = []
    
    @State private var fridayHebergements: [ReservationViewModel] = []
    @State private var saturdayHebergements: [ReservationViewModel] = []
    @State private var sundayHebergements: [ReservationViewModel] = []
    
    @State public var aucunChoix = false
    @State public var vendrediSelected = false
    @State public var samediSelected = false
    @State public var dimancheSelected = false
    
    private func splitHebergementsByDay() {
        
        // Réinitialiser les tableaux de réservations pour chaque jour
        fridayHebergements.removeAll()
        saturdayHebergements.removeAll()
        sundayHebergements.removeAll()
        
        // Filtrer les choix et les affecter aux tableaux appropriés en fonction du jour
        for reservation in choix {
            if reservation.hebergement.jours.contains(.Vendredi) {
                fridayHebergements.append(reservation)
            }
            if reservation.hebergement.jours.contains(.Samedi) {
                saturdayHebergements.append(reservation)
            }
            if reservation.hebergement.jours.contains(.Dimanche) {
                sundayHebergements.append(reservation)
            }
        }
        
    }
    
    
    var body: some View {
        
        VStack {
            
            if !choix.isEmpty {
                
                Text("Pour quel(s) jour(s) cherchez-vous un hébergement ?")
                HStack {
                    Toggle(Jours.Vendredi.rawValue.capitalized, isOn: $vendrediSelected)
                    Toggle(Jours.Samedi.rawValue.capitalized, isOn: $samediSelected)
                    Toggle(Jours.Dimanche.rawValue.capitalized, isOn: $dimancheSelected)
                }
                
                if !vendrediSelected && !samediSelected && !dimancheSelected {
                    Spacer()
                }
                
                if !fridayHebergements.isEmpty && vendrediSelected {
                    VStack {
                        Text("Vendredi").font(.title.bold()).foregroundColor(Colors.BleuFonce)
                        List {
                            ForEach(fridayHebergements, id: \.id) { heb in
                                ChoixHebergementView(hebergement: heb.hebergement, jour: Jours.Vendredi)
                            }
                        }
                    }
                }
                
                
                if !saturdayHebergements.isEmpty && samediSelected {
                    VStack {
                        Text("Samedi").font(.title.bold()).foregroundColor(Colors.BleuFonce)
                        List {
                            ForEach(saturdayHebergements, id: \.id) { heb in
                                ChoixHebergementView(hebergement: heb.hebergement, jour: Jours.Samedi)
                            }
                        }
                    }
                }
                
                
                
                if !sundayHebergements.isEmpty && dimancheSelected {
                    VStack {
                        Text("Dimanche").font(.title.bold()).foregroundColor(Colors.BleuFonce)
                        List {
                            ForEach(sundayHebergements, id: \.id) { heb in
                                ChoixHebergementView(hebergement: heb.hebergement, jour: Jours.Dimanche)
                            }
                        }
                    }
                }
                
                
            } else if aucunChoix {
                Text("Aucun hébergement de disponible pour le moment.")
            } else {
                Text("Chargement en cours...")
            }
            
            
        }.navigationTitle("ChercherHebergement")
            .onAppear {
                chercherHebergementViewModel.getHebergements { fetchedHeb in
                    if let fetchedHeb = fetchedHeb {
                        self.choix = fetchedHeb
                        
                        if fetchedHeb.isEmpty {
                            self.aucunChoix = true
                            print("Aucun hébergement récupéré.")
                        } else {
                            self.splitHebergementsByDay()
                            print("Hébergements récupérés avec succès :")
                            for heb in fetchedHeb {
                                print(heb)
                            }
                        }
                    } else {
                        print("Erreur lors de la récupération des hébergements.")
                    }
                }
                
            }.padding()
    }
}
