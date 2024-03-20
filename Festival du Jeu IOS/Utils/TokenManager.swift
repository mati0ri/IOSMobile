//
//  TokenManager.swift
//  Festival du Jeu IOS
//
//  Created by Mateo iori on 19/03/2024.
//

import Foundation

struct TokenManager {
    static func getUserIdFromToken() -> String? {
        guard let token = UserDefaults.standard.string(forKey: "token") else {
            print("Token not found in UserDefaults")
            return nil
        }
        
        let tokenParts = token.components(separatedBy: ".")
        guard tokenParts.count >= 2,
              let payloadData = Data(base64Encoded: tokenParts[1] + paddingIfNeeded(tokenParts[1])),
              let payload = try? JSONSerialization.jsonObject(with: payloadData, options: []) as? [String: Any],
              let userId = payload["id"] as? String else {
            print("Invalid token format")
            return nil
        }
        
        return userId
    }
    
    private static func paddingIfNeeded(_ base64String: String) -> String {
        let paddingLength = base64String.count % 4
        if paddingLength == 0 { return "" }
        return String(repeating: "=", count: 4 - paddingLength)
    }
}
