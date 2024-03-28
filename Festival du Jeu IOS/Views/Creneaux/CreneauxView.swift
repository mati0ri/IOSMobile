//
//  CreneauxView.swift
//  Festival du Jeu IOS
//
//  Created by IG-MacMobile-01 on 21/03/2024.
//

import SwiftUI

struct CreneauxView: View {
    @StateObject var viewModel = CreneauxViewModel()

    var body: some View {
        NavigationView {
            VStack {
                VStack {
                    Picker("Jour", selection: $viewModel.selectedDay) {
                        ForEach(CreneauxViewModel.jours, id: \.self) { jour in
                            Text(jour)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .onChange(of: viewModel.selectedDay) { _ in
                        viewModel.checkUserRegistrationForSelectedSlot()
                        viewModel.selectedPostes.removeAll()
                    }
                    .onAppear {
                        viewModel.checkUserRegistrationForSelectedSlot() // Vérifier l'inscription lorsque la vue apparaît
                    }
                    
                    Picker("Horaire", selection: $viewModel.selectedTimeSlot) {
                        ForEach(CreneauxViewModel.creneaux, id: \.self) { creneau in
                            Text(creneau)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .onChange(of: viewModel.selectedTimeSlot) { _ in
                        viewModel.checkUserRegistrationForSelectedSlot()
                        viewModel.selectedPostes.removeAll()
                    }
                    .onAppear {
                        viewModel.checkUserRegistrationForSelectedSlot() // Vérifier l'inscription lorsque la vue apparaît
                    }
                }
                .padding(.horizontal)

                if viewModel.isValidSelection() {
                    if viewModel.isUserRegistered {
                        Text("Vous êtes déjà inscrit à ce créneau")
                            .padding()
                    } else {
                        List {
                            ForEach(viewModel.postes) { poste in
                                PosteRow(poste: poste, isSelected: viewModel.selectedPostes.contains(where: { $0.id == poste.id }), viewModel: viewModel, onTap: {
                                    viewModel.selectPoste(poste)
                                })
                                .onAppear {
                                    let affectationsCount = viewModel.getAffectationsCount(for: poste.id)
                                }
                            }


                        }
                        .navigationBarTitleDisplayMode(.inline)
                        
                        if !viewModel.isLoading && !viewModel.postes.isEmpty && !viewModel.isUserRegistered {
                            Button(action: {
                                viewModel.createAffectation()
                            }) {
                                Text("S'inscrire")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(Color.blue)
                                    .cornerRadius(10)
                            }
                            .padding()
                        }
                    }
                } else {
                    Text("Veuillez sélectionner un jour et un horaire")
                        .padding()
                }

                if viewModel.isLoading {
                    ProgressView()
                        .padding()
                } else if viewModel.errorMessage != "" {
                    Text(viewModel.errorMessage)
                        .padding()
                }
                
                Spacer()
            }
        }
        .navigationTitle(navigationTitle)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text(navigationTitle)
                    .font(.headline)
            }
        }
        .alert(isPresented: $viewModel.showSuccessAlert) {
            Alert(title: Text("Succès"), message: Text("L'affectation a été créée avec succès"), dismissButton: .default(Text("OK")) {
                viewModel.checkUserRegistrationForSelectedSlot()
            })
                }
    }

    var navigationTitle: String {
        if viewModel.isValidSelection() {
            return "Postes du \(viewModel.selectedDay) : \(viewModel.selectedTimeSlot)"
        } else {
            return "Postes : Choisis ton créneau"
        }
    }
}

struct PosteRow: View {
    let poste: PosteModel
    let isSelected: Bool
    let viewModel: CreneauxViewModel
    let onTap: () -> Void
    
    @State private var affectationsCount: Int = 0

    var body: some View {
        HStack {
            HStack {
                Text(poste.intitule)
                    .font(.headline)
                Spacer()
                Text("\(affectationsCount) / \(poste.nombrePlacesMax ?? 0)")
            }

            Spacer()
            if isSelected {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.green)
            }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            onTap()
        }
        .onAppear {
            affectationsCount = getAffectationsCountForPoste()
        }
    }
    
    private func getAffectationsCountForPoste() -> Int {
        return viewModel.getAffectationsCount(for: poste.id)
    }
}




struct CreneauxView_Previews: PreviewProvider {
    static var previews: some View {
        CreneauxView()
    }
}
