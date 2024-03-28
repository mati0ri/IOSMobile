//
//  CreneauxViewModel.swift
//  Festival du Jeu IOS
//
//  Created by IG-MacMobile-01 on 21/03/2024.
//

import SwiftUI
import Combine

class CreneauxViewModel: ObservableObject {
    @Published var postes: [PosteModel] = []
    @Published var zones: [ZoneModel] = []
    @Published var selectedPostes: [PosteModel] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String = ""
    @Published var selectedDay: String = CreneauxViewModel.jours.first ?? ""
    @Published var selectedTimeSlot: String = CreneauxViewModel.creneaux.first ?? ""
    @Published var isUserRegistered: Bool = false
    @Published var showSuccessAlert: Bool = false
    private var affectationCounts: [String: Int] = [:]

    static let jours = ["Choisir jour", "Samedi", "Dimanche"]
    static let creneaux = ["Choisir horaire", "9h-11h", "11h-14h", "14h-17h", "17h-20h", "20h-22h"]
    
    private var cancellables = Set<AnyCancellable>()
    
    func isValidSelection() -> Bool {
        return selectedDay != "Choisir jour" && selectedTimeSlot != "Choisir horaire"
    }
    
    func fetchPostes() {
        DispatchQueue.main.async {
                self.isLoading = true
            }
        let baseURL = "https://backawi.onrender.com/api"
            
        fetchHoraireId { horaireId in
            guard let horaireId = horaireId else {
                print("Erreur lors de la récupération de l'horaire.")
                return
            }
            
            let url = URL(string: "\(baseURL)/poste")!
            
            URLSession.shared.dataTask(with: url) { data, response, error in
                DispatchQueue.main.async {
                    self.isLoading = false
                    
                    if let error = error {
                        self.errorMessage = error.localizedDescription
                        return
                    }
                    
                    guard let data = data else {
                        self.errorMessage = "Aucune donnée reçue du serveur."
                        return
                    }
                    
                    do {
                        let decodedPostes = try JSONDecoder().decode([PosteModel].self, from: data)
                        DispatchQueue.main.async {
                            self.postes = decodedPostes
                            self.fetchAffectationsCountForPostes()
                            self.fetchZones()
                        };
                    } catch {
                        self.errorMessage = "Erreur lors du décodage des données : \(error.localizedDescription)"
                    }
                }
            }.resume()
        }
    }

    func fetchAffectationsCountForPostes() {
        let baseURL = "https://backawi.onrender.com/api"

            fetchHoraireId { horaireId in
                guard let horaireId = horaireId else {
                    print("Erreur lors de la récupération de l'horaire.")
                    return
                }
                
                for poste in self.postes {
                    let countURL = "\(baseURL)/affectation/count/\(horaireId)/\(poste.id)"
                    
                    guard let countData = try? Data(contentsOf: URL(string: countURL)!) else {
                        print("Erreur lors de la récupération du nombre d'affectations pour le poste.")
                        return
                    }
                    
                    do {
                        let affectationCountResponse = try JSONDecoder().decode(AffectationCountResponse.self, from: countData)
                        self.affectationCounts[poste.id] = affectationCountResponse.count
                    } catch {
                        print("Erreur lors du décodage de la réponse du nombre d'affectations.")
                    }
                }
            }
        }
        
        func getAffectationsCount(for posteId: String) -> Int {
            return affectationCounts[posteId] ?? 0
        }

    struct AffectationCountResponse: Codable {
        let count: Int
    }

    func fetchZones() {
        let baseURL = "https://backawi.onrender.com/api"
        let url = URL(string: "\(baseURL)/zone")!
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    self.errorMessage = error.localizedDescription
                    return
                }
                
                guard let data = data else {
                    self.errorMessage = "Aucune donnée reçue du serveur."
                    return
                }
                
                do {
                    let decodedZones = try JSONDecoder().decode([ZoneModel].self, from: data)
                    self.zones = decodedZones
                } catch {
                    self.errorMessage = "Erreur lors de la décodage des données : \(error.localizedDescription)"
                }
            }
        }.resume()
    }
    
    func selectPoste(_ poste: PosteModel) {
        if let index = selectedPostes.firstIndex(where: { $0.id == poste.id }) {
            selectedPostes.remove(at: index)
        } else {
            selectedPostes.append(poste)
        }
    }
    
    func createAffectation() {
        guard let userId = extractUserIdFromToken() else {
            print("Vous devez être connecté pour créer une affectation.")
            return
        }
        
        fetchHoraireId { horaireId in
            guard let horaireId = horaireId else {
                print("Erreur lors de la récupération de l'horaire.")
                return
            }
            
            let affectationData = AffectationRequest(userId: userId,
                                                     listePostes: self.selectedPostes.map { $0.id },
                                                     horaireId: horaireId,
                                                     zoneIds: nil
            )
            
            print("Données de l'affectation :", affectationData)
            
            self.sendAffectationRequest(affectationData: affectationData)
            DispatchQueue.main.async {
                self.showSuccessAlert = true
            }
        }
    }
    
    func formatTimeSlot(selectedTimeSlot: String) -> String?{
        let timeSlotMapping: [String: String] = [
            "9h-11h": "plage_9_11",
            "11h-14h": "plage_11_14",
            "14h-17h": "plage_14_17",
            "17h-20h": "plage_17_20",
            "20h-22h": "plage_20_22"
        ]
        return timeSlotMapping[selectedTimeSlot]
    }
    
    func fetchHoraireId(completion: @escaping (String?) -> Void) {
        guard !selectedDay.isEmpty, let formattedTimeSlot = formatTimeSlot(selectedTimeSlot: selectedTimeSlot) else {
            print("Jour ou créneau non sélectionné.")
            completion(nil)
            return
        }
        
        let horaireURL = "https://backawi.onrender.com/api/horaire/find?jour=\(selectedDay)&horaire=\(formattedTimeSlot)"
        
        guard let url = URL(string: horaireURL) else {
            print("URL de l'horaire invalide.")
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Erreur lors de la récupération de l'horaire :",
                      error.localizedDescription)
                                      completion(nil)
                                      return
                                  }
                                  
                                  guard let data = data else {
                                      print("Aucune donnée reçue pour l'horaire.")
                                      completion(nil)
                                      return
                                  }
                                  
                                  do {
                                      let horaireResponse = try JSONDecoder().decode(HoraireResponse.self, from: data)
                                      completion(horaireResponse.id)
                                  } catch {
                                      print("Erreur lors du décodage de la réponse :", error.localizedDescription)
                                      completion(nil)
                                  }
                              }.resume()
                          }
                          
                          
                          func sendAffectationRequest(affectationData: AffectationRequest) {
                              guard let jsonData = try? JSONEncoder().encode(affectationData) else {
                                  print("Erreur lors de l'encodage des données de l'affectation.")
                                  return
                              }
                              
                              let baseURL = "https://backawi.onrender.com/api"
                              let url = URL(string: "\(baseURL)/affectation")!
                              var request = URLRequest(url: url)
                              request.httpMethod = "POST"
                              request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                              request.httpBody = jsonData
                              
                              URLSession.shared.dataTask(with: request) { data, response, error in
                                  DispatchQueue.main.async {
                                      if let error = error {
                                          print("Erreur lors de la création de l'affectation :", error)
                                          return
                                      }
                                      
                                      if let httpResponse = response as? HTTPURLResponse {
                                          print("Réponse de l'API : Status Code", httpResponse.statusCode)
                                          if let responseData = data {
                                              print("Réponse de l'API :", String(data: responseData, encoding: .utf8) ?? "")
                                          }
                                      }
                                  }
                              }.resume()
                          }
                          
                          private func extractUserIdFromToken() -> String? {
                              return TokenManager.getUserIdFromToken()
                          }
                          
                          func checkUserRegistrationForSelectedSlot() {
                              guard let userId = extractUserIdFromToken() else {
                                  self.isUserRegistered = false
                                  return
                              }

                              fetchHoraireId { horaireId in
                                  guard let horaireId = horaireId else {
                                      self.isUserRegistered = false
                                      return
                                  }
                                  
                                  let affectationCheckURL = "https://backawi.onrender.com/api/affectation/check/\(userId)/\(horaireId)"
                                  
                                  guard let url = URL(string: affectationCheckURL) else {
                                      print("URL de vérification de l'affectation invalide.")
                                      self.isUserRegistered = false
                                      return
                                  }

                                  URLSession.shared.dataTask(with: url) { data, response, error in
                                      guard let data = data, error == nil else {
                                          self.isUserRegistered = false
                                          return
                                      }
                                      
                                      do {
                                          let affectationResponse = try JSONDecoder().decode(AffectationCheckResponse.self, from: data)
                                          DispatchQueue.main.async {
                                                              self.isUserRegistered = affectationResponse.hasAffectation
                                                          }
                                          // Ne fetch les postes que si l'utilisateur n'est pas déjà inscrit à cet horaire
                                          if !affectationResponse.hasAffectation {
                                              self.fetchPostes()
                                          }
                                      } catch {
                                          self.isUserRegistered = false
                                          print("Erreur lors du décodage de la réponse : \(error)")
                                      }
                                  }.resume()
                              }
                          }

                      }

                      struct AffectationRequest: Codable {
                          let userId: String
                          let listePostes: [String]
                          let horaireId: String
                          let zoneIds: String?
                      }

                      struct AffectationCheckResponse: Codable {
                          let hasAffectation: Bool
                      }

                      struct HoraireResponse: Codable {
                          let id: String
                      }
