//
//  Footer.swift
//  Festival du Jeu IOS
//
//  Created by Lénaïs Desbos on 16/03/2024.
//

import SwiftUI

struct Footer: View {
    
    var body: some View {
        VStack {
            Spacer()
            HStack {

                NavigationLink(destination: CreneauxView()) {
                                    VStack {
                                        Image(systemName: "calendar.badge.plus")
                                            .foregroundColor(Colors.BleuFonce)
                                        Text("Créneaux")
                                            .foregroundColor(Colors.BleuFonce)
                                    }
                                }
                
                Spacer()
                
                NavigationLink(destination: JeuxListeView()) {
                    VStack {
                        Image(systemName: "gamecontroller.fill")
                            .foregroundColor(Colors.BleuFonce)
                        Text("Jeux")
                            .foregroundColor(Colors.BleuFonce)

                    }
                }
                

                Spacer()

                
                NavigationLink(destination: PlanningView()) {
                    VStack {
                        Image(systemName: "calendar")
                            .foregroundColor(Colors.BleuFonce)
                        Text("Planning")
                            .foregroundColor(Colors.BleuFonce)

                    }
                }
                

                                Spacer()
                                
                                NavigationLink(destination: HebergementView()) {
                                    VStack {
                                        Image(systemName: "house.fill")
                                            .foregroundColor(Colors.BleuFonce)
                                        Text("Loger")
                                            .foregroundColor(Colors.BleuFonce)
                                    }
                                }
                
                Spacer()
                
                
                
                
                
                NavigationLink(destination: ProfileView()) {
                    VStack {
                        Image(systemName: "person.fill")
                            .foregroundColor(Colors.BleuFonce)
                        Text("Profil")
                            .foregroundColor(Colors.BleuFonce)

                    }
                }

            }
            .padding()
            .background(Colors.BleuGris.opacity(0.2))
        }
    }
}
