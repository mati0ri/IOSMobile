//
//  ProfileView.swift
//  Festival du Jeu IOS
//
//  Created by Mateo iori on 19/03/2024.
//

import SwiftUI

struct ProfileView: View {
    @StateObject var viewModel = ProfileViewModel()
    @State private var isEditing = false
    
    var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView("Chargement du profil...")
            } else if let profileData = viewModel.profileData {
                ScrollView {
                    VStack(alignment: .center, spacing: 20) {
                        // Bloc pour l'image de profil
                        AsyncImage(url: URL(string: profileData.photoDeProfil)) { image in
                            image.resizable()
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: 140, height: 110)
                        .clipShape(Circle())
                        .shadow(radius: 6)
                        
                        // Premier bloc pour le prénom et le nom
                        VStack {
                            Text("\(profileData.prenom) \(profileData.nom)")
                                .font(.title)
                                .fontWeight(.medium)
                        }
                        
//                        Divider()
                        
                        VStack(alignment: .center, spacing: 20) {
                                            // Bloc pour l'image de profil
                                            // ... Votre code existant pour l'image ...
                            CardView(title: "Email", detail: profileData.email)
                            CardView(title: "Pseudo", detail: profileData.pseudo)
                            CardView(title: "Téléphone", detail: profileData.telephone)
                            CardView(title: "Taille T-Shirt", detail: profileData.tailleTShirt)
                            if let association = profileData.association {
                                if association != "AUCUNE" {
                                    CardView(title: "Association", detail: association)}
                                }
                            
                                
                                if let nombreEditionPrecedente = profileData.nombreEditionPrecedente {
                                    CardView(title: "Nombre d'éditions précédentes", detail: String(nombreEditionPrecedente))
                                }
                                
                            CardView(title: "Végétarien", detail: profileData.vegetarien ? "Oui" : "Non")

                                if let jeuPrefere = profileData.jeuPrefere {
                                    CardView(title: "Jeu préféré", detail:jeuPrefere)
                                }
                            }
                                        .padding()
                    }
                    .padding()
                }
            } else if let errorMessage = viewModel.errorMessage {
                Text("Erreur: \(errorMessage)")
            }
        }
        .navigationBarItems(trailing: Button("Modifier") {
            self.isEditing = true
        })
        .sheet(isPresented: $isEditing) {
            ProfileEditView(viewModel: viewModel)
        }
        .navigationTitle("Profil")
        .padding()
    }
}


struct ProfileEditView: View {
    @ObservedObject var viewModel: ProfileViewModel
    @Environment(\.presentationMode) var presentationMode // Ajout pour gérer la fermeture de la vue

    // Propriétés temporaires pour l'édition de chaque attribut
    @State private var tempNom: String = ""
    @State private var tempPrenom: String = ""
    @State private var tempEmail: String = ""
    @State private var tempPseudo: String = ""
    @State private var tempTelephone: String = ""
    @State private var tempTailleTShirt: String = ""
    @State private var tempPhotoDeProfil: String = ""
    @State private var tempAssociation: String = ""
    @State private var tempNombreEditionPrecedente: Int? = nil
    @State private var tempVegetarien: Bool = false
    @State private var tempJeuPrefere: String = ""


    let taillesTShirt = ["XXS", "XS", "S", "M", "L", "XL", "XXL"]

    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Informations Personnelles")) {
                    HStack {
                        Text("Nom")
                        Spacer()
                        TextField("Nom", text: $tempNom)
                    }
                    HStack {
                        Text("Prénom")
                        Spacer()
                        TextField("Prénom", text: $tempPrenom)
                    }
                    HStack {
                        Text("Email")
                        Spacer()
                        TextField("Email", text: $tempEmail)
                    }
                    HStack {
                        Text("Pseudo")
                        Spacer()
                        TextField("Pseudo", text: $tempPseudo)
                    }
                    HStack {
                        Text("Téléphone")
                        Spacer()
                        TextField("Téléphone", text: $tempTelephone)
                    }
                    Picker("Taille T-Shirt", selection: $tempTailleTShirt) {
                                            ForEach(taillesTShirt, id: \.self) { taille in
                                                Text(taille).tag(taille)
                                            }
                                        }
                                        .pickerStyle(MenuPickerStyle())
                    HStack {
                        Text("Photo")
                        Spacer()
                        TextField("Photo", text: $tempPhotoDeProfil)
                    }
                    HStack {
                        Text("Association")
                        Spacer()
                        TextField("Association", text: $tempAssociation)
                    }
                                        
                    HStack {
                        Text("Nombre d'éditions précédentes")
                        Spacer()
                                            TextField("Nombre", value: $tempNombreEditionPrecedente, formatter: NumberFormatter())
                                                .keyboardType(.numberPad)
                                        }
                                     
                    HStack {
                        Text("Jeu Préféré")
                        Spacer()
                        TextField("Jeu Préféré", text: $tempJeuPrefere)
                    }
                    
                    

                                    
                }
                                    Toggle("Végétarien", isOn: $tempVegetarien)

            }
            .onAppear {
                if let profileData = viewModel.profileData {
                    tempNom = profileData.nom
                    tempPrenom = profileData.prenom
                    tempEmail = profileData.email
                    tempPseudo = profileData.pseudo
                    tempTelephone = profileData.telephone
                    tempTailleTShirt = profileData.tailleTShirt
                    tempPhotoDeProfil = profileData.photoDeProfil
                    tempAssociation = profileData.association ?? ""
                    tempNombreEditionPrecedente = profileData.nombreEditionPrecedente
                    tempVegetarien = profileData.vegetarien
                    tempJeuPrefere = profileData.jeuPrefere ?? ""
                }
            }
            .navigationTitle("Modifier le Profil")
            .navigationBarItems(trailing: Button("Enregistrer") {
                if var updatedData = viewModel.profileData {
                    updatedData.nom = tempNom
                    updatedData.prenom = tempPrenom
                    updatedData.email = tempEmail
                    updatedData.pseudo = tempPseudo
                    updatedData.telephone = tempTelephone
                    updatedData.tailleTShirt = tempTailleTShirt
                    updatedData.photoDeProfil = tempPhotoDeProfil
                    updatedData.association = tempAssociation
                    updatedData.nombreEditionPrecedente = tempNombreEditionPrecedente
                    updatedData.vegetarien = tempVegetarien
                    updatedData.jeuPrefere = tempJeuPrefere
                    
                    viewModel.updateProfile(with: updatedData)
                    presentationMode.wrappedValue.dismiss() // Ferme la vue après enregistrement
                }
            })
        }
    }
}


// Composant de vue pour une carte d'information
struct CardView: View {
    var title: String
    var detail: String

    var body: some View {
        VStack(alignment: .leading) {
            Text(title).bold()
            Text(detail).foregroundColor(.gray)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 2)
        .padding(.horizontal)
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
