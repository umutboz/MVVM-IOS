//
//  ProjectListViewController.swift
//  MVVM Poc
//
//  Created by umut on 30.01.2019.
//  Copyright © 2019 Koçsistem. All rights reserved.
//

import Foundation

import UIKit
import RxSwift
import RxCocoa

class ProjectListViewController: UIViewController {
    @IBOutlet weak var refreshButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var requestCountBarLabel: UIBarButtonItem!
    var refreshControl = UIRefreshControl()
    
    
    let viewModel = ProjectListViewModel()
    var repos: [ProjectModel] = []
    var disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDataBinding()
        refreshControl.attributedTitle = NSAttributedString(string: "Loading new data...")
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        self.tableView.refreshControl = refreshControl
        let nib = UINib.init(nibName: "GithubRepoTableViewCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: "githubCell")
        
    }
    @objc func refresh(_ sender: Any) {
        // Call webservice here after reload tableview.
        print("burda")
        refreshControl.endRefreshing()
    }
    
    private func bindCountLabel() {
        viewModel.requestCount.asObservable().map{"Data load time : \($0)"}.bind(to: requestCountBarLabel.rx.title).disposed(by: disposeBag)
    }
    
    // Setups data binding
    private func setupDataBinding() {
        // Bind request count label
        bindCountLabel()
        // Handle refresh button's click
        bindRefreshButton()
        // Bind data to table view
        bindTableView()
        // Handle search bar
        bindSearchBar()
        // Handle refresh indicator
        bindRefreshControl()
        
    }
    
    func tableViewRefresh() {
        // Clear data
        self.repos.removeAll()
        self.tableView.reloadData()
        // Load data from remote source
        self.viewModel.loadTrendingRepos(online: true)
    }
    
    func bindRefreshControl() {
        refreshControl.rx.controlEvent(.valueChanged)
            .subscribe(onNext: {
                self.tableViewRefresh()
            }).disposed(by: disposeBag)
    }
    private func bindRefreshButton() {
        refreshButton.rx.tap.asObservable()
            .subscribe(onNext: {
                self.tableViewRefresh()
            })
            .disposed(by: disposeBag)
    }
    private func bindTableView() {
        viewModel.repos.asObservable()
            .bind(to: tableView.rx.items(cellIdentifier: "githubCell"))(setupCell)
            .disposed(by: disposeBag)
    }
    private func bindSearchBar() {
        searchBar.rx.text.asObservable()
            .filter{$0 != nil}
            .subscribe(onNext: {
                text in
                self.viewModel.filter(text: text!)
            }).disposed(by: disposeBag)
    }
    
    private func setupCell(row: Int, element: ProjectModel, cell: GithubRepoTableViewCell){
        cell.projectNameLabel.text = element.name
        cell.descriptionLabel.text = element.teams_url
        cell._logoImage.downloadFromUrl(link: element.owner?.avatar_url)
    }
}
