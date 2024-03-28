//
//  ProposerHebergementView.swift
//  Festival du Jeu IOS
//
//  Created by Lénaïs Desbos on 19/03/2024.
//

import SwiftUI

struct ProposerHebergementView: View {
    
    @StateObject var proposerHebergementViewModel = ProposerHebergementViewModel()
    @State private var propositions: [HebergeurViewModel] = []
    
    @State private var isPropositionsShown = true
    @State private var aucuneProposition = false
    @State private var isFormShown = false
    @State private var nbPlace: String = ""
    @State private var adresse: String = ""
    @State private var joursSelectionnes: [Jours] = []
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    let joursFiltered = [Jours.Vendredi, Jours.Samedi, Jours.Dimanche]
    
    var body: some View {
        
        VStack {
            
            if isPropositionsShown {
                Text("Mes hébergements").font(.title)
                if !propositions.isEmpty {
                    List {
                        ForEach(propositions, id: \.id) { hebergement in
                            NavigationLink(destination: HebergeurView(hebergement: hebergement)) {
                                HStack {
                                    Spacer()
                                    VStack {
                                        HStack {
                                            Text("Adresse : ").font(.headline)
                                            Text(hebergement.hebergement.adresse)
                                        }
                                        HStack {
                                            Text("Nombre de places : ").font(.headline)
                                            Text(hebergement.hebergement.nbPlace.description)
                                        }
                                    }
                                    Spacer()
                                }
                                Spacer()
                            }
                        }
                    }
                } else if aucuneProposition {
                    Text("Vous n'avez proposé aucun hébergement pour le moment.").padding()
                } else {
                    Text("Chargement de vos propositions en cours...")
                }
            }
            
            Spacer()
            
            if !isFormShown {
                Button("Faire une proposition") {
                    isFormShown = true
                    isPropositionsShown = false
                }
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
                    }
                    Section {
                        Button("Proposer") {
                            if !validateForm() {
                                showAlert = true
                            } else {
                                let joursArray = joursSelectionnes.map { $0.rawValue }
                                print("nbPlaces: \(nbPlace), adresse: \(adresse), jours: \(joursArray)")
                                proposerHebergementViewModel.createProposition(nbPlace: Int(nbPlace)!, adresse: adresse, jours: joursArray) { error in
                                    if let error = error {
                                        print("Error creating proposition: \(error.localizedDescription)")
                                    } else {
                                        print("Proposition ajoutée")
                                        proposerHebergementViewModel.getHebergementByHebergeur { fetchedProps in
                                            if let fetchedProps = fetchedProps {
                                                self.propositions = fetchedProps
                                            } else {
                                                print("Error fetching propositions")
                                            }
                                        }
                                        nbPlace = ""
                                        adresse = ""
                                        joursSelectionnes = []
                                        isPropositionsShown = true
                                        isFormShown = false
                                    }
                                }
                            }
                        }
                        Button("Retour") {
                            isPropositionsShown = true
                            isFormShown = false
                            showAlert = false
                        }
                    }
                    
                }.alert(isPresented: $showAlert) {
                    Alert(title: Text("Erreur"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                }
                    
            }
            
        }.navigationTitle("Proposer un Hebergement")
            .onAppear {
                // Charger les jeux depuis l'API lorsque la vue apparaît
                proposerHebergementViewModel.getHebergementByHebergeur { fetchedProps in
                    if let fetchedProps = fetchedProps {
                        self.propositions = fetchedProps
                        
                        if fetchedProps.isEmpty {
                            self.aucuneProposition = true
                            print("Aucune affectation récupérée.")
                        } else {
                            print("Propositions récupérées avec succès :")
                            for hebergement in fetchedProps {
                                print(hebergement.hebergement.adresse)
                            }
                        }
                    } else {
                        print("Erreur lors de la récupération des propositions.")
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
