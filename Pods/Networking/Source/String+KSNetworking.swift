//
//  String+KSNetworking.swift
//  Networking
//
//  Created by OSX on 6.03.2018.
//  Copyright © 2018 KocSistem. All rights reserved.
//

import Foundation

extension String {
    
    public func toArray<T: Serializable>(type: [T].Type) -> [T]? {
        do {
            return try JSONSerializer.jsonToGenericObject(self, type: type)
        } catch let error {
            return nil
        }
    }
    
    public func toObject<T: Serializable>(type: T.Type) -> T? {
        do {
            return try JSONSerializer.jsonToGenericObject(self, type: type)
        } catch {
            return nil
        }
    }
    
    public func toData() -> Any? {
        guard let data = self.data(using: .utf8) else { return nil }
        return try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments)
    }
}

extension String: Serializable {
    
}
