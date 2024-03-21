//
//  NextAffectationModel.swift
//  Festival du Jeu IOS
//
//  Created by Mateo iori on 21/03/2024.
//

import Foundation

struct NextAffectationModel: Codable {
    var affectation: AffectationDetails
    var poste: PosteDetails

    struct AffectationDetails: Codable {
        var id: String
        var confirmation: Bool
        var flexible: Bool
        var userId: String
        var referent: Bool
        var horaireId: String
        var zoneId: String?
        var horaire: Horaire
        var listePostes: [PosteDetails]
    }

    struct Horaire: Codable {
        var id: String
        var jour: String
        var horaire: String
    }

    struct PosteDetails: Codable, Identifiable {
        var id: String
        var intitule: String
    }
}
