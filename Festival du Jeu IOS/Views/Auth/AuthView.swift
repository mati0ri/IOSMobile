//
//  AuthView.swift
//  Festival du Jeu IOS
//
//  Created by Mateo iori on 12/03/2024.
//

import SwiftUI

struct AuthView: View {
    
    @State private var isConnected = false
    
    var body: some View {
        VStack {
                    if isConnected {
                        Text("Connecté")
                    }
                    CustomButton(text: "Se connecter", action: loginWithEmail)
                }
    }
    
    func loginWithEmail() -> Void {
        isConnected = !isConnected
    }
    
}

struct AuthView_Previews: PreviewProvider {
    static var previews: some View {
        AuthView()
    }
}
