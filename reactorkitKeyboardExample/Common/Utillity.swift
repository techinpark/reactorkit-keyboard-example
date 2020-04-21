//
//  Utillity.swift
//  reactorkitKeyboardExample
//
//  Created by Fernando on 2020/04/21.
//  Copyright © 2020 tmsae. All rights reserved.
//

import Foundation
import UIKit

class Utility {
    
    static let shared = Utility()
    private let userDefaults = UserDefaults.standard
    
    func getWords() -> [String] {
        guard let userDefault = UserDefaults(suiteName: Constants.AppConfig.groupID) else { return [] }
        if let data = userDefault.array(forKey: Constants.AppConfig.oldUserDefaultKey) as? [String] {
            return data
        }
        
        return []
    }
    
    func getIndex(text: String) -> Int {
        guard let userDefault = UserDefaults(suiteName: Constants.AppConfig.groupID) else { return -1 }
        if let data = userDefault.array(forKey: Constants.AppConfig.oldUserDefaultKey) as? [String] {
            if let index = data.firstIndex(of: text) {
                return index
            }
        }
        
        return -1
    }
    
    func updateWord(index: Int, text:String) -> Bool {
        guard let userDefault = UserDefaults(suiteName: Constants.AppConfig.groupID) else { return false }
        if var data = userDefault.array(forKey: Constants.AppConfig.oldUserDefaultKey) as? [String] {
            data.remove(at: index)
            data.insert(text, at: index)
            userDefault.set(data, forKey: Constants.AppConfig.oldUserDefaultKey)
            userDefault.synchronize()
            return true
        }
        
        return false
    }
    
    func moveWords(source: Int, destination: Int) -> Bool {
        
        guard let userDefault = UserDefaults(suiteName: Constants.AppConfig.groupID) else { return false }
        if let original = userDefault.array(forKey: Constants.AppConfig.oldUserDefaultKey) as? [String] {
            var copy = original
            copy.remove(at: source)
            copy.insert(original[source], at: destination)
            userDefault.set(copy, forKey: Constants.AppConfig.oldUserDefaultKey)
            userDefault.synchronize()
            
            return true
        }
        
        return false
    }
    
    func deleteWord(index: Int) -> Bool {
        guard let userDefault = UserDefaults(suiteName: Constants.AppConfig.groupID) else { return false }
        if var data = userDefault.array(forKey: Constants.AppConfig.oldUserDefaultKey) as? [String] {
            data.remove(at: index)
            userDefault.set(data, forKey: Constants.AppConfig.oldUserDefaultKey)
            userDefault.synchronize()
            return true
        }
        
        return false
    }
    
    func saveWord(text: String) -> Bool {
        guard let userDefault = UserDefaults(suiteName: Constants.AppConfig.groupID) else { return false }
        if var data = userDefault.array(forKey: Constants.AppConfig.oldUserDefaultKey) as? [String] {
            data.append(text)
            userDefault.set(data, forKey: Constants.AppConfig.oldUserDefaultKey)
            userDefault.synchronize()
            return true
        } else {
            let array:[String] = [text]
            userDefault.set(array, forKey: Constants.AppConfig.oldUserDefaultKey)
            userDefault.synchronize()
            return true
        }
    }
    
    class func sharedInstance() -> Utility {
        return shared
    }
    
    func setBool(value: Bool, key: String) {
        userDefaults.set(value, forKey: key)
        userDefaults.synchronize()
    }
    
    func getBool(key: String) -> Bool {
        return userDefaults.bool(forKey: key)
    }
    
    func setInt(value:Int, key: String) {
        userDefaults.set(value, forKey: key)
        userDefaults.synchronize()
    }
    
    func getInt(key: String) -> Int {
        return userDefaults.integer(forKey: key)
    }
    
    func removeObject(key: String) {
        userDefaults.removeObject(forKey: key)
        userDefaults.synchronize()
    }
}
