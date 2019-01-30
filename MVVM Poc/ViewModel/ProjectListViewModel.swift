//
//  ProjectListViewModel.swift
//  MVVM Poc
//
//  Created by umut on 30.01.2019.
//  Copyright © 2019 Koçsistem. All rights reserved.
//


import Foundation
import RxSwift

class ProjectListViewModel {
  let dataManager = GitHubRepository()
  var requestCount = Variable<Int>(0)
  var repos = Variable<[ProjectModel]>([])
  var cachedRepos: [ProjectModel] = []
  init() {
    // Load local data
    loadTrendingRepos(online: false)
  }
  
  func loadTrendingRepos(online: Bool) {
    requestCount.value += 1
    
    self.dataManager.getProjectList(success: { (response) in
        self.cachedRepos = try! response.getModel(type:[ProjectModel].self) as! [ProjectModel]
        self.repos.value = self.cachedRepos
    }) { (error) in
        print(error.getDescription())
    }
  }
  
  func filter(text: String) {
    if (text.count == 0) {
      repos.value = cachedRepos
    } else {
        repos.value = cachedRepos.filter{$0.name!.lowercased().contains(text.lowercased())}
    }
  }
}
