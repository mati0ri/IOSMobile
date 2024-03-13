//
//  APIStates.swift
//  Festival du Jeu IOS
//
//  Created by Mateo iori on 13/03/2024.
//

import Foundation

enum APIStates<T> : CustomStringConvertible {
    var description: String {
        switch self {
        case .loading :
            return "loading"
        case .idle :
            return "idle"
        case .loadOne:
            return "loadOne"
        case .load:
            return "load"
        case .failed :
            return "failed"
        default:
            return "default"
        }
    }
    
    case idle
    case creating
    case loading
    case load([T])
    case loadOne(T)
    case deleting
    case updating
    case failed(APIErrors)
    case updateFestival(String)
}
