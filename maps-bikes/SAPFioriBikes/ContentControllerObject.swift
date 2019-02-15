//
//  ContentController.swift
//  SAPFioriBikes
//
//  Created by Takahashi, Alex on 12/27/18.
//  Copyright © 2018 Takahashi, Alex. All rights reserved.
//

import UIKit
import SAPFiori

class ContentControllerObject: NSObject {
    
    var station: BikeStationAnnotation!
    
    init(_ station: BikeStationAnnotation) {
        self.station = station
    }
    
    var headlineText: String? {
        return station.title
    }
    
    var subheadlineText: String {
        return station.distanceToUserString ?? "Distance Unavailable"
    }
    
    func getBikesTags(_ numBikes: Int, _ numEBikes: Int) -> [FUITag] {
        let styledTag: (String) -> FUITag = { title in
            let tag = FUITag(title: title)
            tag.textColor = UIColor.white
            tag.borderColor = UIColor.clear
            tag.font = UIFont.preferredFioriFont(forTextStyle: .footnote)
            return tag
        }
        let bikeTag = styledTag("Bikes \(numBikes)")
        bikeTag.fillColor = numBikes > 0 ? Colors.green : Colors.red
        let eBikeTag = styledTag("EBikes: \(numEBikes)")
        eBikeTag.fillColor = numEBikes > 0 ? Colors.darkBlue : Colors.red
        return [bikeTag, eBikeTag]
    }
    
    func getDocsTags(_ numDocs: Int) -> [FUITag] {
        let docTag = FUITag(title: "Docs: \(station.numDocsAvailable)")
        docTag.textColor = UIColor.white
        docTag.borderColor = UIColor.clear
        docTag.font = UIFont.preferredFioriFont(forTextStyle: .footnote)
        docTag.fillColor = numDocs > 0 ? Colors.lightBlue : Colors.red
        return [docTag]
    }
}

extension ContentControllerObject: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: FUIMapDetailTagObjectTableViewCell.reuseIdentifier) as? FUIMapDetailTagObjectTableViewCell else { return UITableViewCell() }
            cell.backgroundColor = .clear
            cell.tags = getBikesTags(station.numBikes, station.numEBikes)
            cell.footnoteText = "Bikes " + (station.numBikes > 0 ? "Available" : "Unavailable")
            cell.footnoteLabel.textColor = station.numBikes > 0 ? UIColor.preferredFioriColor(forStyle: .positive) : UIColor.preferredFioriColor(forStyle: .negative)
            cell.statusImage = UIImage(named: "bicycle")
            cell.statusImageView.tintColor = cell.footnoteLabel.textColor
            cell.substatusImage = FUIIconLibrary.system.flashOff.withRenderingMode(.alwaysTemplate)
            cell.substatusImageView.tintColor = station.numEBikes > 0 ? UIColor.preferredFioriColor(forStyle: .positive) : UIColor.preferredFioriColor(forStyle: .negative)
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: FUIMapDetailTagObjectTableViewCell.reuseIdentifier) as? FUIMapDetailTagObjectTableViewCell else { return UITableViewCell() }
            cell.backgroundColor = .clear
            cell.tags = getDocsTags(station.numDocsAvailable)
            cell.footnoteText = "Docs " + (station.numDocsAvailable > 0 ? "Available" : "Unavailable")
            cell.footnoteLabel.textColor = station.numDocsAvailable > 0 ? UIColor.preferredFioriColor(forStyle: .positive) : UIColor.preferredFioriColor(forStyle: .negative)
            cell.statusImage = FUIIconLibrary.map.panel.point.withRenderingMode(.alwaysTemplate)
            cell.statusImageView.tintColor = cell.footnoteLabel.textColor
            return cell
        case 2:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: FUIMapDetailPanel.ButtonTableViewCell.reuseIdentifier) as? FUIMapDetailPanel.ButtonTableViewCell else { return UITableViewCell() }
            cell.button.titleLabel?.numberOfLines = 0
            let isEnabled = station.numBikes > 0
            cell.button.isEnabled = isEnabled
            cell.buttonHeadlineText = isEnabled ? "Rent a Bike Here" : "No Bikes Available"
            cell.buttonSubheadlineText = isEnabled ? "Open the Ford GoBike App" : "Check a different Station"
            cell.button.backgroundColor = UIColor.preferredFioriColor(forStyle: .tintColor)
            cell.button.didSelectHandler = { [unowned self] button in
                guard let rentalURL = self.station.rentalUrl else { return }
                UIApplication.shared.open(rentalURL, options: [:], completionHandler: nil)
            }
            return cell
        default:
            return UITableViewCell()
        }
    }
    
}
