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
    @State private var reservations: [ReservationViewModel] = []
    
    // Ajouter une propriété pour stocker les identifiants des hébergements déjà réservés
    @State private var hebergementsReserves: Set<String> = []
    
    @State private var fridayHebergements: [ReservationViewModel] = []
    @State private var saturdayHebergements: [ReservationViewModel] = []
    @State private var sundayHebergements: [ReservationViewModel] = []
    
    @State public var aucuneReservation = false
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
            
            if !hebergementsReserves.contains(reservation.hebergement.hebergementId) {
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
        
    }
    
    
    var body: some View {
        
        VStack {
            
            Text("Mes réservations").font(.title).foregroundColor(Colors.BleuFonce)
            if !reservations.isEmpty {
                List {
                    ForEach(reservations, id: \.id) { resa in
                        NavigationLink(destination: ReservationView(hebergement: resa.hebergement, jour: resa.reservation!.jour, reserved: true, resa: resa.reservation)) {
                            VStack {
                                Text(resa.reservation!.jour.rawValue).font(.headline)
                                HStack {
                                    Text("Adresse : ")
                                    Text(resa.hebergement.adresse)
                                }
                                HStack {
                                    Text("Nombre de places : ")
                                    Text(resa.hebergement.nbPlace.description)
                                }
                            }
                        }
                    }
                }
            } else if aucuneReservation {
                Text("Vous n'avez réservé aucun hébergement pour le moment.")
            } else {
                Text("Chargement des réservations en cours...")
            }
            
            Divider()
            
            if !choix.isEmpty {
                
                Text("Pour quel(s) jour(s) cherchez-vous un hébergement ?")
                HStack {
                    Toggle(Jours.Vendredi.rawValue.capitalized, isOn: $vendrediSelected)
                    Toggle(Jours.Samedi.rawValue.capitalized, isOn: $samediSelected)
                    Toggle(Jours.Dimanche.rawValue.capitalized, isOn: $dimancheSelected)
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
                Text("Aucun hébergement disponible pour le moment.")
            } else {
                Text("Chargement des hébergements en cours...")
            }
            
            Spacer()
            
        }.navigationTitle("Chercher un Hebergement")
            .onAppear {
                chercherHebergementViewModel.getReservationsByUserId {
                    fetchedRes in
                        if let fetchedRes = fetchedRes {
                            self.reservations = fetchedRes
                            
                            if fetchedRes.isEmpty {
                                self.aucuneReservation = true
                                print("Aucune réservation récupérée.")
                            } else {
                                print("Réservations récupérées avec succès :")
                                for res in fetchedRes {
                                    self.hebergementsReserves.insert(res.hebergement.hebergementId)
                                    print(res)
                                }
                            }
                        } else {
                            print("Erreur lors de la récupération des réservations.")
                        }
                }
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
            }
        
    }
}
