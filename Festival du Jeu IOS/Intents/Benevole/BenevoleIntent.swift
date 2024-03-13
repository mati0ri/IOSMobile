////
////  BenevoleIntent.swift
////  Festival du Jeu IOS
////
////  Created by Mateo iori on 13/03/2024.
////
//
//import Foundation
//import SwiftUI
//
//struct BenevoleIntent {
//    
//    @ObservedObject private var benevoleVM : BenevoleVM
//    
//    init(benevoleVM : BenevoleVM) {
//        self.benevoleVM = benevoleVM
//    }
//    
//    func load(id: String) {
//        benevoleVM.state = .loading
//        Task {
//            await self.loadOneAuxByID(id: id)
//        }
//    }
//
//    func create(firebaseId : String, firstName : String, lastName : String, email : String){
//        benevoleVM.state = .creating
//        Task {
//            await self.createAux(id : id, prenom : prenom, nom : nom, email : email);
//        }
//    }
//    
//    func loadOne(id: String) {
//        benevoleVM.state = .loading
//        Task {
//            await self.loadOneAux(id: id)
//        }
//    }
//
//    func update(id: String, firstName: String, lastName: String) {
//        benevoleVM.state = .updating
//        Task {
//            await self.updateAux(id: id, firstName: firstName, lastName: lastName)
//        }
//    }
//
//}
