//
//  Data+KSNetworking.swift
//  Networking
//
//  Created by OSX on 6.03.2018.
//  Copyright © 2018 KocSistem. All rights reserved.
//

import Foundation

extension Data {
    func toJSON() -> [String: Any]? {
        do {
            let json: [String: Any] = try JSONSerialization.jsonObject(with: self, options: []) as! [String: Any]
            return json
        } catch {
            return nil
        }
    }
    
    func toString() -> String? { return String(data: self, encoding: .utf8) }
    
    func toArray<T: Serializable>(type: T.Type) {
        do {
            let jsonArray = try JSONSerialization.jsonObject(with: self, options: []) as? [Any]
            if let jsonArray = jsonArray as? [T] {
                print("json array \(jsonArray)")
            }
        } catch {
            print("error")
        }
    }
}
