//
//  UserModel.swift
//  MVVM Poc
//
//  Created by umut on 29/01/2019.
//  Copyright © 2019 Koçsistem. All rights reserved.
//

import Foundation
import Networking

class UserModel : Serializable {
    
    let name : String?
    let surname : String?
    let userName : String?
    let emailAddress : String?
    
    init(name : String, surname : String, userName : String, emailAddress : String) {
        self.name = name
        self.surname = surname
        self.userName = userName
        self.emailAddress = emailAddress
    }
}
