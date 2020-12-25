//
//  JsonData.swift
//  MaskPharmacyList
//
//  Created by CharlesLin on 2020/12/24.
//

import Foundation

extension JsonData {
    
    var pharmacies: Set<Pharmacy> {
        get { (pharmacies_ as? Set<Pharmacy>) ?? [] }
        set { pharmacies_ = newValue as NSSet }
    }

}
