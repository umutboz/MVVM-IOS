//
//  NetworkCachingObject.swift
//  Networking
//
//  Created by Umut BOZ on 22/05/2018.
//  Copyright © 2018 KocSistem. All rights reserved.
//

import Foundation
import Alamofire
open class NetworkCancelObject{
    internal var tag: String?
    internal var request: DataRequest?
    public init() { }
}

/*
extension NetworkCancelObject: Equatable {
    static func == (lhs: NetworkCancelObject, rhs: NetworkCancelObject) -> Bool {
        return lhs.tag == rhs.tag 
    }
}
*/
