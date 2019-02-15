//
//  SearchResults.swift
//  SAPFioriBikes
//
//  Created by Takahashi, Alex on 12/27/18.
//  Copyright © 2018 Takahashi, Alex. All rights reserved.
//

import UIKit
import SAPFiori
import CoreLocation
import MapKit

protocol SearchResultsProducing: class {
    var isFiltered: Bool { get set }
    var stationModel: [BikeStationAnnotation] { get }
    var filteredResults: [BikeStationAnnotation] { get set }
    var searchResultsTableView: UITableView? { get }
    var didSelectBikeStationSearchResult: ((BikeStationAnnotation) -> Void)! { get }
}

class SearchResultsControllerObject: NSObject {
    
    weak var model: SearchResultsProducing!
    
    init(_ model: SearchResultsProducing) {
        self.model = model
    }
    
    internal var searchResults: [BikeStationAnnotation] {
        get {
            return model.isFiltered ? model.filteredResults : model.stationModel
        }
    }
    
}

extension SearchResultsControllerObject: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let defaultCell = UITableViewCell()
        defaultCell.backgroundColor = .clear
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FUIObjectTableViewCell.reuseIdentifier) as? FUIObjectTableViewCell else { return defaultCell }
        guard indexPath.row < searchResults.count else { return defaultCell }
        cell.backgroundColor = UIColor.clear
        let bikeStation = searchResults[indexPath.row]
        cell.headlineText = bikeStation.title
        cell.subheadlineText = bikeStation.distanceToUserString ?? "Calculating..."
        cell.statusImage = UIImage(named: "bicycle")
        cell.statusImageView.tintColor = bikeStation.numBikes > 0 ? UIColor.preferredFioriColor(forStyle: .positive) : UIColor.preferredFioriColor(forStyle: .negative)
        cell.substatusImage = FUIIconLibrary.system.flashOff.withRenderingMode(.alwaysTemplate)
        cell.substatusImageView.tintColor = bikeStation.numEBikes > 0 ? UIColor.preferredFioriColor(forStyle: .positive) : UIColor.preferredFioriColor(forStyle: .negative)
        return cell
    }
}

extension SearchResultsControllerObject: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let bikeStationAnnotation = searchResults[indexPath.row]
        model.didSelectBikeStationSearchResult(bikeStationAnnotation)
    }
    
}

extension SearchResultsControllerObject: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsBookmarkButton = false
        searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        DispatchQueue.main.async { [unowned self] in
            searchBar.showsCancelButton = false
            self.model.isFiltered = false
            searchBar.endEditing(true)
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let searchString = searchText
        self.model.isFiltered = !searchString.isEmpty
        self.model.filteredResults = self.model.stationModel.filter({
            guard let title = $0.title else { return false }
            return title.localizedCaseInsensitiveContains(searchString)
        })
        self.model.searchResultsTableView?.reloadData()
    }
    
}
