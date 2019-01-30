//
//  JSONSerializerError.swift
//  Networking
//
//  Created by OSX on 6.03.2018.
//  Copyright © 2018 KocSistem. All rights reserved.
//

import Foundation

public enum JSONSerializerError: Error {
    case jsonIsNotDictionary
    case jsonIsNotArray
    case jsonIsNotValid
}
