//
//  SettingsViewController.swift
//  SAPFioriBikes
//
//  Created by Takahashi, Alex on 1/16/19.
//  Copyright © 2019 Takahashi, Alex. All rights reserved.
//

import Foundation
import UIKit
import SAPFiori

class SettingsViewController: UITableViewController {
    
    weak var model: FioriBikeMapModel!
    
    var values: [Bool?] = []
    
    convenience init(_ model: FioriBikeMapModel) {
        self.init(style: .plain)
        self.model = model
        values = [Bool?](repeating: nil, count: self.model.layerModel.count)
        self.tableView.register(FUISwitchFormCell.self, forCellReuseIdentifier: FUISwitchFormCell.reuseIdentifier)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.layerModel.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FUISwitchFormCell.reuseIdentifier) as? FUISwitchFormCell else { return UITableViewCell() }
        let displayName = model.layerModel[indexPath.row].displayName
        cell.keyLabel.text = displayName
        cell.value = model.layerIsEnabled[indexPath.row]
        cell.onChangeHandler = { [weak model] changeBool in
            model?.layerIsEnabled[indexPath.row] = changeBool
        }
        return cell
    }
    
}
