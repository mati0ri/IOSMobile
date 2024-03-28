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
                        if hebergement.hebergement.reservations != nil {
                            ForEach(hebergement.hebergement.reservations!, id: \.self) { resa in
                                HStack {
                                    Text("\(resa.user!.prenom) \(resa.user!.nom)")
                                    Text(resa.jour.rawValue).font(.headline)
                                }
                            }
                        } else {
                            Text("Personne n'a réservé pour ce logement pour l'instant.")
                        }
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
                                let joursArray = joursSelectionnes.map { $0.rawValue }
                                print("Tentative de modification avec nbPlaces: \(nbPlace), adresse: \(adresse), jours: \(joursArray)")
                                hebergement.updateHebergement(hebergementId: hebergement.hebergement.hebergementId, nbPlace: Int(nbPlace)!, adresse: adresse, jours: joursArray) { error in
                                    if let error = error {
                                        print("Error creating proposition: \(error.localizedDescription)")
                                    } else {
                                        print("Proposition modifiée avec succès")
                                        DispatchQueue.main.async {
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
    
    func validateForm() -> Bool {
        var isValid = true
        var errorMessage = "Veuillez corriger les éléments suivants :"
        
        if nbPlace.isEmpty {
            isValid = false
            errorMessage += "\n- Le nombre de places doit être au moins égal à 1."
        } else if let nbPlaces = Int(nbPlace), nbPlaces < 1 {
            isValid = false
            errorMessage += "\n- Le nombre de places doit être au moins égal à 1."
        }
        
        if adresse.isEmpty {
            isValid = false
            errorMessage += "\n- Veuillez entrer une adresse."
        }
        
        if joursSelectionnes.isEmpty {
            isValid = false
            errorMessage += "\n- Veuillez sélectionner au moins un jour."
        }
        
        alertMessage = errorMessage
        
        return isValid
    }
    
}
