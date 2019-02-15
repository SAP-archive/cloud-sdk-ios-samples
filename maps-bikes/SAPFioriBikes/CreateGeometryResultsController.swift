//
//  CreateGeometryResultsController.swift
//  SAPFioriBikes
//
//  Created by Takahashi, Alex on 1/20/19.
//  Copyright © 2019 Takahashi, Alex. All rights reserved.
//

import Foundation
import UIKit
import SAPFiori
import MapKit

class CreateGeometryResultsController: UITableViewController {
    
    var editingGeometry: MKShape? = nil {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(FUIObjectTableViewCell.self, forCellReuseIdentifier: FUIObjectTableViewCell.reuseIdentifier)
        self.tableView.register(FUIMapSnapshotFormCell.self, forCellReuseIdentifier: FUIMapSnapshotFormCell.reuseIdentifier)
        self.tableView.cellLayoutMarginsFollowReadableWidth = true
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let defaultCell = UITableViewCell()
        switch indexPath.row {
        case 0:
            guard let snapshotFormCell = tableView.dequeueReusableCell(withIdentifier: FUIMapSnapshotFormCell.reuseIdentifier) as? FUIMapSnapshotFormCell else { return defaultCell }
            snapshotFormCell.title.text = "Geospatial Item"
            snapshotFormCell.geometry = self.editingGeometry
            if let coordinates = snapshotFormCell.coordinates {
                let numOfPoints = coordinates.count
                snapshotFormCell.status.text = numOfPoints > 1 ? "\(numOfPoints) Points Added" : "\(numOfPoints) Point Added"
            }
            return snapshotFormCell
        default:
            break
        }
        return defaultCell
    }
    
}
