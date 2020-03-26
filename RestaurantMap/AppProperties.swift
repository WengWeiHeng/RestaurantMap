//
//  AppProperties.swift
//  RestaurantMap
//
//  Created by Heng on 2020/3/26.
//  Copyright © 2020 Heng. All rights reserved.
//

import Foundation

final class AppProperties {
    static let shared = AppProperties()
    
    let gnaviDictionary: [String: Any]
    
    private init() {
        if let gnaviPath = Bundle.main.path(forResource: "gnavi", ofType: "plist") {
            gnaviDictionary =  (NSDictionary(contentsOfFile: gnaviPath) as! Dictionary<String, Any>)
        } else {
            gnaviDictionary = [:]
        }
    }
}
