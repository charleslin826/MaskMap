//
//  UserDefaultsModel.swift
//  MaskPharmacyList
//
//  Created by CharlesLin on 2020/12/25.
//

import Foundation

let UserDefaultsSingleton = UserDefaultsModel.shared

/** WonderCore Fit 使用者預設資訊的存取類 */
class UserDefaultsModel {
    static let shared = UserDefaultsModel()
    private var myUserDefaults: UserDefaults
    
    init() {
        myUserDefaults = UserDefaults.standard
    }
    
    func setUserDefaults(_ value: Any?, forKey key: String) {
        myUserDefaults.set(value, forKey: key)
        myUserDefaults.synchronize()
    }
    
    func getUserDefaults(forKey key: String) -> Any? {
        myUserDefaults.object(forKey: key)
    }
    
    var firstWriteJson: Bool {
        set {
            setUserDefaults(newValue, forKey: "firstWriteJson")
        }
        get {
            getUserDefaults(forKey: "firstWriteJson") as? Bool ?? false
        }
    }
    
}
