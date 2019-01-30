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
    @IBOutlet weak var requestCountLabel: UILabel!
    @IBOutlet weak var refreshButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!

    let viewModel = ProjectListViewModel()
    var repos: [ProjectModel] = []
    var disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDataBinding()
    }
    
    
    private func bindCountLabel() {
        viewModel.requestCount
            .asObservable()
            .map{"Data load time: \($0)"}
            .bind(to: requestCountLabel.rx.text)
            .addDisposableTo(disposeBag)
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
    }
    private func bindRefreshButton() {
        refreshButton.rx.tap.asObservable()
            .subscribe(onNext: {
                // Clear data
                self.repos.removeAll()
                self.tableView.reloadData()
                
                // Load data from remote source
                self.viewModel.loadTrendingRepos(online: true)
            })
            .disposed(by: disposeBag)
    }
    private func bindTableView() {
        viewModel.repos.asObservable()
            .bind(to: tableView.rx.items(cellIdentifier: "projectListViewCell"))(setupCell)
            .addDisposableTo(disposeBag)
    }
    private func bindSearchBar() {
        searchBar.rx.text.asObservable()
            .filter{$0 != nil}
            .subscribe(onNext: {
                text in
                self.viewModel.filter(text: text!)
            }).disposed(by: disposeBag)
    }
    
    private func setupCell(row: Int, element: ProjectModel, cell: UITableViewCell){
        cell.textLabel?.text = element.name
    }
}
