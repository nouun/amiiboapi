//
//  GenericModel.swift
//  
//
//  Created by 오하온 on 19/03/23.
//

import Foundation

public typealias AmiiboType = GenericModel
public typealias AmiiboGameSeries = GenericModel
public typealias AmiiboSeries = GenericModel
public typealias AmiiboCharacter = GenericModel

public struct GenericModel: Decodable {
    /// The key.
    public let key: String
    
    /// The name.
    public let name: String
}
