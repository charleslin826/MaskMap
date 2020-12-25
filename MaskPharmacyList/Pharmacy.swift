//
//  Pharmacy.swift
//  MaskPharmacyList
//
//  Created by CharlesLin on 2020/12/25.
//

import CoreData

extension Pharmacy {
    var properties: Properties {
        get { properties_ ?? self.properties}
        set { properties_ = newValue}
    }
    
    static func fetchRequest(_ predicate: NSPredicate) -> NSFetchRequest<Pharmacy> {
        let request = NSFetchRequest<Pharmacy>(entityName: "Pharmacy")
//        request.sortDescriptors = [NSSortDescriptor(key: "properties_.town_", ascending: true)]
        request.predicate = predicate
        return request
    }
}

