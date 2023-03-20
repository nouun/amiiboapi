//
//  Amiibo.swift
//  
//
//  Created by 오하온 on 19/03/23.
//

import Foundation

public struct Amiibo: Decodable {
    /// The 16 character hexadecimal identifier for the amiibo.
    public var id: String { self.head + self.tail }

    /// The first eight values of the hexadecimal to recognize the amiibo.
    public let head: String
    
    /// The last eight value of the hexadecimal to recognize the amiibo.
    public let tail: String
    
    /// The name of the amiibo.
    public let name: String
    
    /// The character of the amiibo, multiple character have different amiibo design.
    public let character: String
    
    /// The series the amiibo belongs to.
    public let amiiboSeries: String
    
    /// The game series of the amiibo.
    public let gameSeries: String
    
    /// The image link of the amiibo.
    public let image: URL?
    
    /// The type the amiibo belongs to.
    public let type: String
    
    /// The release date for North America, Japan, Europe and Australia.
    // TODO: Fix decoding
    public let release: AmiiboRelease
    
    /// List of 3DS games amiibo can be used in.
    public let games3DS: [AmiiboGame]?
    
    /// List of Wii U games the amiibo can be used in.
    public let gamesWiiU: [AmiiboGame]?
    
    /// List of Switch games amiibo can be used in.
    public let gamesSwitch: [AmiiboGame]?
}

public struct AmiiboRelease: Decodable {
    /// The release date in Australia.
    public let au: Date?
    
    /// The release date in Europe.
    public let eu: Date?
    
    /// The release date in Japan.
    public let jp: Date?
    
    /// The release date in North America.
    public let na: Date?
    
    enum CodingKeys: String, CodingKey {
        case au, eu, jp, na
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let formatter = DateFormatter.yyyyMMdd
        self.au = (try? container.decode(String.self, forKey: .au)).map(formatter.date) ?? nil
        self.eu = (try? container.decode(String.self, forKey: .eu)).map(formatter.date) ?? nil
        self.jp = (try? container.decode(String.self, forKey: .jp)).map(formatter.date) ?? nil
        self.na = (try? container.decode(String.self, forKey: .na)).map(formatter.date) ?? nil
    }
}

public struct AmiiboGame: Decodable {
    /// A list of game IDs.
    public let id: [String]
    
    /// The name of the game.
    public let name: String
    
    /// How the amiibo can be used within the game.
    public let usage: [AmiiboUsage]?
    
    enum CodingKeys: String, CodingKey {
        case id = "gameID"
        case name = "gameName"
        case usage = "amiiboUsage"
    }
}

public struct AmiiboUsage: Decodable {
    /// How the amiibo can be used.
    public let usage: String
    
    /// If the amiibo can be written to.
    public let writable: Bool
    
    enum CodingKeys: String, CodingKey {
        case usage = "Usage"
        case writable = "write"
    }
}
