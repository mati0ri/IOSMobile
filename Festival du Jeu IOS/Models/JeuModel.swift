//
//  JeuModel.swift
//  Festival du Jeu IOS
//
//  Created by Lénaïs Desbos on 16/03/2024.
//

import SwiftUI

class JeuModel: Decodable {
    
    public var nom: String
    public var editeur: String
    public var type: String
    public var notice: String
    public var zone: String?
    public var aAnimer: Bool
    public var recu: Bool
    public var video: String
    
    init(nom: String, editeur: String, type: String, notice: String, zone: String, aAnimer: Bool, recu: Bool, video: String){
        self.nom = nom
        self.editeur = editeur
        self.type = type
        self.notice = notice
        self.zone = zone
        self.aAnimer = aAnimer
        self.recu = recu
        self.video = video
    }
    
}
