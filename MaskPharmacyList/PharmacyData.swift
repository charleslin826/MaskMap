//
//  mask.swift
//  MaskMap
//
//  Created by CharlesLin on 2020/12/23.
//

import Foundation

public class Data: NSObject, Codable, NSCoding {
//    let type : String
    public var features : [PharmacyData] = []
    
    enum CodingKeys: String, CodingKey {
//        case type
        case features
    }
    
    enum Key:String {
        case features = "features"
    }
    
    init(features: [PharmacyData]) {
        self.features = features
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(features, forKey: Key.features.rawValue)
    }
    
    public required convenience init?(coder aDecoder: NSCoder) {
        let mFeatures = aDecoder.decodeObject(forKey: Key.features.rawValue) as! [PharmacyData]
        
        self.init(features: mFeatures)
    }
}

public class PharmacyData: NSObject, Codable, NSCoding {
//    let type : String
    public var properties: Properties
//    let geometry : Geometry
    
    enum CodingKeys: String, CodingKey {
//        case type
        case properties
//        case geometry
    }
    
    enum Key:String {
        case properties = "properties"
    }
    
    init(properties: Properties) {
        self.properties = properties
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(properties, forKey: Key.properties.rawValue)
    }
    
    public required convenience init?(coder aDecoder: NSCoder) {
        let mProperties = aDecoder.decodeObject(forKey: Key.properties.rawValue) as! Properties
        
        self.init(properties: mProperties)
    }
}

public class Properties: NSObject, Codable, NSCoding {
//    let id: String
    public var name: String
//    let phone: String
//    let address: String
//    let mask_adult: Double
//    let mask_child: Double
//    let updated: String
//    let available: String
//    let note: String
//    let custom_note : String
//    let website : String
    let county : String
    public var town : String
//    let cunli : String
//    let service_periods : String
    
    enum CodingKeys: String, CodingKey {
//        case id
        case name
//        case phone
//        case address
//        case mask_adult
//        case mask_child
//        case updated
//        case available
//        case note
//        case custom_note
//        case website
        case county
        case town
//        case cunli
//        case service_periods
    }
    
    
    enum Key:String {
        case name = "name"
        case town = "town"
        case county = "county"
    }
    
    init(name: String, town: String, county:String) {
        self.name = name
        self.town = town
        self.county = county
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: Key.name.rawValue)
        aCoder.encode(town, forKey: Key.town.rawValue)
        aCoder.encode(county, forKey: Key.county.rawValue)
    }
    
    public required convenience init?(coder aDecoder: NSCoder) {
        let mName = aDecoder.decodeObject(forKey: Key.name.rawValue) as! String
        let mTown = aDecoder.decodeObject(forKey: Key.town.rawValue) as! String
        let mCounty = aDecoder.decodeObject(forKey: Key.county.rawValue) as! String
        
        self.init(name: mName, town: mTown, county: mCounty)
    }
}

//struct Geometry : Codable {
//    let type: String
//    let coordinates :[Double]
//
//    enum CodingKeys: String, CodingKey {
//        case type
//        case coordinates
//    }
//}
