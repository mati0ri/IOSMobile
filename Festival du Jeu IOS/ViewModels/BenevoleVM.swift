////
////  BenevoleVM.swift
////  Festival du Jeu IOS
////
////  Created by Mateo iori on 13/03/2024.
////
//
//import Foundation
//
//class BenevoleVM: ObservableObject, Decodable, Hashable, Equatable {
//    
//    // pour etre conforme a equatable -> verifier si 2 instances de benevoleVm sont égales
//    static func == (lhs: BenevoleVM, rhs: BenevoleVM) -> Bool {
//        return lhs.id == rhs.id
//    }
//    
//    // pour etre conforme a hashable
//    func hash(into hasher: inout Hasher){
//      hasher.combine(self.id)
//    }
//    
//    // Stocker l'état courant du ViewModel.
//    // Le type `APIStates<VolunteerDTO>` est une énumération qui représente différents états de chargement ou d'erreur de l'API.
//    @Published var state: APIStates<BenevoleDTO> = .idle {
//        didSet{
//            // À chaque fois que `state` change, ce bloc de code sera exécuté.
//            switch state {
//            case.loadOne(let benevole):
//                // Si l'état est `loadOne` avec un volontaire chargé, mettre à jour la propriété `benevole` et réinitialiser l'état à `idle`.
//                self.benevole = benevole
//                self.state = .idle
//            case .failed(let error):
//                // Si l'état est `failed` avec une erreur, imprimer cette erreur.
//                print("failed: \(error)")
//            case .updateFestival(let festival):
//                // Si l'état est `updateFestival` avec un ID de festival, mettre à jour l'ID de festival du volontaire et réinitialiser l'état à `idle`.
//                self.benevole.festivalId = festival
//                self.state = .idle
//            default:
//                // Pour tous les autres cas, imprimer l'état pour le débogage.
//                print("BenevoleVM state : \(self.state)")
//                break
//            }
//        }
//    }
//    
//    // Identifiant unique pour le modèle de vue. Utilisé pour la comparaison et la fonction de hashage.
//    var id: String
//    
//    // Une propriété publiée qui contient les données du volontaire. Cela va déclencher une mise à jour de l'interface utilisateur quand il change.
//    @Published var benevole: BenevoleDTO
//    
//    // Initialisateur par défaut, fixant des valeurs initiales.
//    init() {
//        self.id = ""
//        self.benevole = BenevoleDTO()
//    }
//    
//    // Initialisateur qui copie les données d'un autre VolunteerViewModel. /!!!\ Il faudra changer en fonction
//    init(benevoleVM: BenevoleVM){
//        self.benevole = BenevoleDTO(id: benevoleVM.benevole.id, firstName: benevoleVM.benevole.firstName, lastName: benevoleVM.benevole.lastName, emailAddress: benevoleVM.benevole.emailAddress, firebaseId: benevoleVM.benevole.firebaseId, festivalId: benevoleVM.benevole.festivalId, isAdmin: benevoleVM.benevole.isAdmin, availableSlots: benevoleVM.benevole.availableSlots)
//        self.id = benevoleVM.benevole.id
//    }
//    
//    // Initialisateur avec des paramètres spécifiques pour chaque propriété du DTO. /!!!\ Il faudra changer en fonction
//    init(id: String, firstName: String, lastName: String, emailAddress: String, firebaseId: String, festivalId: String?, isAdmin: Bool, availableSlots: Array<AvailableSlotsDTO>) {
//        self.id = id
//        self.benevole = BenevoleDTO(id: id, firstName: firstName, lastName: lastName, emailAddress: emailAddress, firebaseId: firebaseId, festivalId: festivalId, isAdmin: isAdmin, availableSlots: availableSlots)
//    }
//    
//    // Initialisateur requis pour la conformité à Decodable, pour créer une instance de VolunteerViewModel à partir de données décodées. /!!!\ Il faudra changer en fonction
//    required init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: BenevoleDTO.CodingKeys.self)
//        id = try values.decode(String.self, forKey: .id)
//        let firstname = try values.decode(String.self, forKey: .firstName)
//        let lastname = try values.decode(String.self, forKey: .lastName)
//        let email = try values.decode(String.self, forKey: .emailAddress)
//        let firebaseId = try values.decode(String.self, forKey: .firebaseId)
//        let festivalId = try values.decode(String?.self, forKey: .festivalId)
//        let isAdmin = try values.decode(Bool.self, forKey: .isAdmin)
//        let availableSlots = try values.decode(Array<AvailableSlotsDTO>.self, forKey: .availableSlots)
//        self.benevole = BenevoleDTO(id: id, firstName: firstname, lastName: lastname, emailAddress: email, firebaseId: firebaseId, festivalId: festivalId, isAdmin: isAdmin, availableSlots: availableSlots)
//    }
//    
//    // Méthode pour mettre à jour les créneaux disponibles du volontaire.
//    func updateSlots(slots: [AvailableSlotsDTO]){
//        self.benevole.availableSlots = slots
//    }
//    
//    // Méthode pour mettre à jour l'ID du festival associé au volontaire.
//    func updtateFestival(festivalID: String){
//        self.benevole.festivalId = festivalID
//    }
//    
//    
//    
//}
