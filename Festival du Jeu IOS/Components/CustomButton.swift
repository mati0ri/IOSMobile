//
//  CustomButton.swift
//  Festival du Jeu IOS
//
//  Created by Mateo iori on 12/03/2024.
//

import SwiftUI

struct CustomButton: View {
    var text : String
    var action :() -> Void
    
    var body: some View {
        Button (action: {
            action()
        }, label: {
            Text(text).font(.title3).bold().padding().overlay(RoundedRectangle(cornerRadius: 10).stroke())
        }).buttonStyle(PlainButtonStyle())
    }
}
