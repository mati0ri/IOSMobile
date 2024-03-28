//
//  HebergeurView.swift
//  Festival du Jeu IOS
//
//  Created by Lénaïs Desbos on 22/03/2024.
//

//
//  ChoixHebergementView.swift
//  Festival du Jeu IOS
//
//  Created by Lénaïs Desbos on 20/03/2024.
//

import SwiftUI

struct HebergeurView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject public var hebergement: HebergeurViewModel
    
    @State private var isFormShown = false
    @State private var nbPlace: String = ""
    @State private var adresse: String = ""
    @State private var joursSelectionnes: [Jours] = []
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    let joursFiltered = [Jours.Vendredi, Jours.Samedi, Jours.Dimanche]
    
    var body: some View {
        
        VStack {
            
            if !isFormShown {
                
                VStack() {
                    
                    HStack {
                        ForEach(hebergement.hebergement.jours.indices, id: \.self) { index in
                            Text("\(hebergement.hebergement.jours[index].rawValue) ").font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                        }
                    }
                    Spacer()
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Text("Adresse : ").font(.headline)
                            Text(hebergement.hebergement.adresse)
                        }
                        HStack {
                            Text("Nombre de places : ").font(.headline)
                            Text(hebergement.hebergement.nbPlace.description)
                        }
                    }
                    Divider()
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Les bénévoles que vous allez héberger :").font(.headline)
                        if !hebergement.users.isEmpty {
                            ForEach(hebergement.users.indices, id: \.self) { index in
                                let user = hebergement.users[index]
                                HStack {
                                    Text("\(user.prenom) \(user.nom)")
                                }
                            }
                        } else {
                            Text("Personne n'a réservé pour ce logement pour l'instant.")
                        }
                    }.onAppear {
                        // Charger les données lors de l'apparition de la vue
                        loadReservationsAndUsers()
                    }
                    Spacer()
                    
                }.padding()
                
                HStack {
                    Spacer()
                    Button("Modifier") {
                        print("Modifier la props")
                        isFormShown = true
                        nbPlace = hebergement.hebergement.nbPlace.description
                        adresse = hebergement.hebergement.adresse
                        joursSelectionnes = hebergement.hebergement.jours
                    }
                    Spacer()
                    Button("Supprimer") {
                        hebergement.deleteHebergement(hebergementId: hebergement.hebergement.hebergementId) { error in
                            DispatchQueue.main.async {
                                if let error = error {
                                    print("Erreur lors de la suppression : \(error)")
                                } else {
                                    print("Suppression réussie")
                                    // Simuler le retour en arrière
                                    presentationMode.wrappedValue.dismiss()
                                }
                            }
                        }
                    }.foregroundColor(Color.red)
                    Spacer()
                }.padding()
                
            } else {
                Form {
                    Section(header: Text("Proposition d'hébergement")) {
                        TextField("Nombre de places", text: $nbPlace)
                            .keyboardType(.numberPad)
                        TextField("Adresse", text: $adresse)
                        //Section(header: Text("Jours")) {
                        ForEach(joursFiltered, id: \.self) { jour in
                            Toggle(jour.rawValue.capitalized, isOn: Binding(
                                get: { joursSelectionnes.contains(jour) },
                                set: { isSelected in
                                    if isSelected {
                                        joursSelectionnes.append(jour)
                                    } else if let index = joursSelectionnes.firstIndex(of: jour) {
                                        joursSelectionnes.remove(at: index)
                                    }
                                }
                            ))
                        }
                        //}
                    }
                    Section {
                        Button("Valider") {
                            if !validateForm() {
                                showAlert = true
                            } else {
                                // Proceed with creating the proposition
                                let joursArray = joursSelectionnes.map { $0.rawValue }
                                print("Tentative de modification avec nbPlaces: \(nbPlace), adresse: \(adresse), jours: \(joursArray)")
                                hebergement.updateHebergement(hebergementId: hebergement.hebergement.hebergementId, nbPlace: Int(nbPlace)!, adresse: adresse, jours: joursArray) { error in
                                    if let error = error {
                                        print("Error creating proposition: \(error.localizedDescription)")
                                        // Handle error if needed
                                    } else {
                                        // Proposition created successfully
                                        // Handle success if needed
                                        print("Proposition modifiée avec succès")
                                        DispatchQueue.main.async {
                                            // Mettre à jour les valeurs de l'écran avec les nouvelles données
                                            hebergement.hebergement.nbPlace = Int(nbPlace)!
                                            hebergement.hebergement.adresse = adresse
                                            hebergement.hebergement.jours = joursSelectionnes
                                            isFormShown = false // Fermer le formulaire après la modification réussie
                                        }
                                    }
                                }
                                print("Fin tentative de modification")
                            }
                        }
                        Button("Annuler") {
                            isFormShown = false
                            showAlert = false
                        }
                    }
                    
                }.alert(isPresented: $showAlert) {
                    Alert(title: Text("Erreur"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                }
            }
        }
        
    }
    
    func loadReservationsAndUsers() {
        // Charger les réservations et les utilisateurs à partir du viewModel
        // Appelez les méthodes nécessaires de votre HebergeurViewModel pour charger les données
        // Par exemple :
        hebergement.getReservationsHeb()
        hebergement.fetchUsers()
    }
    
    func validateForm() -> Bool {
        var isValid = true
        var errorMessage = "Veuillez corriger les éléments suivants :"
        
        // Validate number of places
        if nbPlace.isEmpty {
            isValid = false
            errorMessage += "\n- Le nombre de places doit être au moins égal à 1."
        } else if let nbPlaces = Int(nbPlace), nbPlaces < 1 {
            isValid = false
            errorMessage += "\n- Le nombre de places doit être au moins égal à 1."
        }
        
        // Validate address
        if adresse.isEmpty {
            isValid = false
            errorMessage += "\n- Veuillez entrer une adresse."
        }
        
        // Validate selected days
        if joursSelectionnes.isEmpty {
            isValid = false
            errorMessage += "\n- Veuillez sélectionner au moins un jour."
        }
        
        alertMessage = errorMessage
        
        return isValid
    }
    
}
