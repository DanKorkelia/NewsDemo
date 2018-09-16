//
//  UserDefaults.swift
//  NewsDemo
//
//  Created by Dan Korkelia on 15/09/2018.
//  Copyright © 2018 Dan Korkelia. All rights reserved.
//

import Foundation

extension UserDefaults {
    enum savedValue: String {
        case currentSource
    }
    
    func getSource() -> String {
        return string(forKey: savedValue.currentSource.rawValue) ?? "bbc-news"
    }
    
    func setSource(value: String) {
        set(value, forKey: savedValue.currentSource.rawValue)
    }
}



