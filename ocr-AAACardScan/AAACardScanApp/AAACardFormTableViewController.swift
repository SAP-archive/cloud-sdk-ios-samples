//
//  AAACardFormTableViewController.swift
//
//  Copyright © 2019 SAP SE or an SAP affiliate company. All rights reserved.
//

import UIKit
import SAPFiori

class AAACardFormTableViewController: UITableViewController {
    
    var validThru: String?
    var clubId: String?
    var membershipId: String?
    var memberSince: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        self.tableView.register(FUITextFieldFormCell.self, forCellReuseIdentifier: FUITextFieldFormCell.reuseIdentifier)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FUITextFieldFormCell.reuseIdentifier) as? FUITextFieldFormCell else { return UITableViewCell() }
        cell.isEditable = true
        switch indexPath.row {
        case 0:
            cell.keyName = "Valid Thru"
            cell.value = validThru ?? ""
        case 1:
            cell.keyName = "Club code"
            cell.value = clubId ?? ""
        case 2:
            cell.keyName = "Membership Number"
            cell.value = membershipId ?? ""
        case 3:
            cell.keyName = "Member Since"
            cell.value = memberSince ?? ""
        default:
            break
        }
        return cell
    }
}
