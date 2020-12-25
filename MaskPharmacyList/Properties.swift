//
//  Properties.swift
//  MaskPharmacyList
//
//  Created by CharlesLin on 2020/12/25.
//

import Foundation

extension Properties {
    var name: String {
        get { name_ ?? self.name }
        set { name_ = newValue }
    }
    var town: String {
        get { town_ ?? self.town }
        set { town_ = newValue }
    }
    var county: String {
        get { county_ ?? self.county }
        set { county_ = newValue }
    }
}
