//
//  Serializable+KSNetworking.swift
//  Networking
//
//  Created by OSX on 6.03.2018.
//  Copyright © 2018 KocSistem. All rights reserved.
//

import Foundation


extension Serializable {
    
    public func toJson() -> String {
        return JSONSerializer.toJson(self)
    }
    
    public func toJSON() -> [String: Any]? {
        var json: [String: Any]?
        do {
            let data = try JSONEncoder().encode(self)
            let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any]
            return json
        } catch let error {
            print(error.localizedDescription)
        }
        return json
    }
    
    public func isArray() -> Bool {
        if ((self is Array<Any>)) {
            return true
        } else {
            return false
        }
    }
}
