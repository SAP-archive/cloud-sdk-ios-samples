//
//  TableViewController.swift
//  ObservationMemoryLeak
//
//  Created by Takahashi, Alex on 12/17/18.
//  Copyright © 2018 Takahashi, Alex. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "🚰 Observation Memory Leak"
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "reusableCell")
    }
    
    // MARK: UITableViewDataSource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "reusableCell") else{ return UITableViewCell() }
        cell.textLabel?.text = "Leaking Observation View Controller"
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    // MARK: UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = ViewController()
        vc.title = "Leaking Observation View Controller"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
