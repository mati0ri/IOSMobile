//
//  JeuViewModel.swift
//  Festival du Jeu IOS
//
//  Created by Lénaïs Desbos on 15/03/2024.
//

import SwiftUI

class JeuViewModel: ObservableObject {
    private let loginURL = "https://backawi.onrender.com/api/user/login"
    
    let id = UUID();
    var jeu : JeuModel
    @Published var nom: String {
        didSet {
            if nom != jeu.nom {
                jeu.nom = nom
            }
        }
    }
    @Published public var editeur: String
    @Published public var type: String
    @Published public var notice: String
    @Published public var video: String
    
    static func == (lhs: JeuViewModel, rhs: JeuViewModel) -> Bool { return lhs.id == rhs.id }
    func hash(into hasher: inout Hasher){
        hasher.combine(self.id)
    }
    
    init(jeu: JeuModel){
        
        self.jeu = jeu
        self.nom = jeu.nom
        self.editeur = jeu.editeur
        self.type = jeu.type
        self.notice = jeu.notice
        self.video = jeu.video
    }
    
}
