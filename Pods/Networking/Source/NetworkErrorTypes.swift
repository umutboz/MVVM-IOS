//
//  NetworkErrorTypes.swift
//  Networking
//
//  Created by OSX on 2.03.2018.
//  Copyright © 2018 KocSistem. All rights reserved.
//

import Foundation

public enum NetworkErrorTypes: Error {
    case noConnectionError
    case timeoutError
    case authFailureError
    case serverError
    case networkError
    case parseError
    case invalidJSON
}
