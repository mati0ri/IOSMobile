//
//  JeuView.swift
//  Festival du Jeu IOS
//
//  Created by Lénaïs Desbos on 15/03/2024.
//

import SwiftUI

struct JeuView: View {
    
    @ObservedObject public var jeu: JeuViewModel
    
    init(jeu: JeuViewModel){
        self.jeu = jeu
    }
    
    var body: some View{
        
        VStack(alignment: .leading) {
            Text("\(jeu.nom)").font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
            Text("Editeur : \(jeu.editeur)")
            Text("Type : \(jeu.type)")
            Text("Notice : \(jeu.notice)")
            Text("Lien vidéo : \(jeu.video)")
        }.padding()
        
    }
    
}
