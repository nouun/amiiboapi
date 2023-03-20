//
//  ResponseAmiibo.swift
//  
//
//  Created by 오하온 on 20/03/23.
//

import Foundation

struct ResponseAmiibo<T: Decodable>: Decodable {
    let code: Int?
    let error: String?
    
    let amiibo: T?
}

struct ResponseUpdated: Decodable {
    let lastUpdated: Date
    
    enum CodingKeys: String, CodingKey {
        case lastUpdated
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let dateString = try container.decode(String.self, forKey: .lastUpdated)
        guard let lastUpdated = DateFormatter.iso8601Full.date(from: dateString) else {
            throw NSError(domain: "AmiiboAPI", code: 7, userInfo: [NSLocalizedDescriptionKey: "Unable to parse lastUpdated to Date"])
        }
        
        self.lastUpdated = lastUpdated
    }
}
