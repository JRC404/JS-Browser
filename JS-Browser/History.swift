//
//  History.swift
//  JS-Browser
//
//  Created by Jacob Reilly-Cooper on 04/05/2020.
//  Copyright © 2020 Janapexo Studios. All rights reserved.
//

import UIKit

class History: UIViewController {
    let tableView = UITableView()
    var safeArea: UILayoutGuide!
    
    var mainBrowser = ViewController()
    
    
    
    override func loadView() {
        super.loadView()
        view.backgroundColor = .white
        safeArea = view.layoutMarginsGuide
        setupTableView()
    }
    
    func setupTableView() {
      view.addSubview(tableView)
    tableView.translatesAutoresizingMaskIntoConstraints = false
    tableView.topAnchor.constraint(equalTo: safeArea.topAnchor).isActive = true
    tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
    tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }
}
