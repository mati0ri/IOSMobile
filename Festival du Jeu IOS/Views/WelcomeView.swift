//
//  WelcomeView.swift
//  Festival du Jeu IOS
//
//  Created by Mateo iori on 15/03/2024.
//

import SwiftUI

struct WelcomeView: View {
    // Si vous avez besoin de données pour cette vue, vous les passeriez ici.
    var body: some View {
        VStack {
            Text("Bienvenue")
                .font(.largeTitle)
                .fontWeight(.semibold)
            Footer()
        }
        
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}
