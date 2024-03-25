//
//  HorairesManager.swift
//  Festival du Jeu IOS
//
//  Created by Lénaïs Desbos on 22/03/2024.
//

import Foundation

struct HorairesManager {
    
    private func extractHour(from plageHoraire: String) -> Int? {
        let components = plageHoraire.components(separatedBy: "_")
        if components.count == 3, let debut = Int(components[1]) {
            return debut
        }
        return nil
    }
    
    // Fonction pour convertir le format "plage_X_Y" en "Xh - Yh"
    private func formatPlageHoraire(_ plageHoraire: String) -> String {
        let components = plageHoraire.components(separatedBy: "_")
        if components.count == 3, let debut = Int(components[1]), let fin = Int(components[2]) {
            return "\(debut)h - \(fin)h"
        } else {
            return "Format de plage horaire invalide"
        }
    }
    
}
