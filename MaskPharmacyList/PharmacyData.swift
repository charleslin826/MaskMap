//
//  mask.swift
//  MaskMap
//
//  Created by CharlesLin on 2020/12/23.
//

import Foundation


struct Data: Codable {
    let type : String
    let features : [PharmacyData]
    
    enum CodingKeys: String, CodingKey {
        case type
        case features
    }
}

struct PharmacyData: Codable {
    let type : String
    let properties: Properties
    let geometry : Geometry
    
    enum CodingKeys: String, CodingKey {
        case type
        case properties
        case geometry
    }
}

struct Properties: Codable {
    let id: String
    let name: String
    let phone: String
    let address: String
    let mask_adult: Double
    let mask_child: Double
    let updated: String
    let available: String
    let note: String
    let custom_note : String
    let website : String
    let county : String
    let town : String
    let cunli : String
    let service_periods : String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case phone
        case address
        case mask_adult
        case mask_child
        case updated
        case available
        case note
        case custom_note
        case website
        case county
        case town
        case cunli
        case service_periods
    }
}

struct Geometry : Codable {
    let type: String
    let coordinates :[Double]
    
    enum CodingKeys: String, CodingKey {
        case type
        case coordinates
    }
}
