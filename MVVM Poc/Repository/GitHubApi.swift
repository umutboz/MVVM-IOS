//
//  GitHubApi.swift
//  MVVM
//
//  Created by Umut BOZ on 29/01/2019.
//  Copyright © 2018 Umut BOZ. All rights reserved.
//

import Foundation
import Networking

class GitHubApi
{
    
    init() {
        
    }
    
    public func getProjectList(success: @escaping (ResultModel<ProjectModel>) -> Void,
                               fail: @escaping (ErrorModel) -> Void)
    {
        
        let url = "https://api.github.com/users/google/repos"
        let v = NetworkManager().get(url, success: success, fail: fail).fetch()
        
    }
    
    public func logon(username: String, password : String) -> UserModel
    {
        var userModel : UserModel?
        userModel = UserModel(name: "Framework", surname: "Development", userName: "Developer", emailAddress: "developer@kocsistem.com.tr")
        
        return userModel!
    }
}
