//
//  Dictionary+Networking.swift
//  Networking
//
//  Created by Halil İbrahim YILMAZ on 8.08.2018.
//  Copyright © 2018 KocSistem. All rights reserved.
//

import Foundation

extension Dictionary: Serializable where Key: Serializable, Value: Serializable { }
