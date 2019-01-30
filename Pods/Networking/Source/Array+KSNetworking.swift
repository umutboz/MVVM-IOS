//
//  Array+KSNetworking.swift
//  Networking
//
//  Created by Halil İbrahim YILMAZ on 06/03/2018.
//  Copyright © 2018 KocSistem. All rights reserved.
//

import Foundation

extension Array where Element: Serializable {

   public func toJson() -> String {
        return JSONSerializer.toJson(self)
    }

}
