//
//  ViewController.swift
//
//  Copyright © 2019 SAP SE or an SAP affiliate company. All rights reserved.
//

import UIKit
import MapKit
import SAPFiori

class ViewController: FUIMKMapFloorplanViewController, MKMapViewDelegate, SearchResultsProducing, CLLocationManagerDelegate {

    var mapModel = FioriBikeMapModel()
    let isClusteringStations = true
    
    // MARK: SearchResultsControllerObject and ContentControllerObject
    var searchResultsObject: SearchResultsControllerObject!
    var isFiltered: Bool = false
    var stationModel: [BikeStationAnnotation] { return mapModel.stationModel }
    var filteredResults: [BikeStationAnnotation] = []
    var searchResultsTableView: UITableView? { return detailPanel.searchResults.tableView }
    var didSelectBikeStationSearchResult: ((BikeStationAnnotation) -> Void)!
    var contentObject: ContentControllerObject! {
        didSet {
            detailPanel.content.tableView.dataSource = contentObject
            detailPanel.content.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: Model Setup
        mapModel.delegate = self
        mapModel.loadData()
        
        // MARK: Standard Map Setup
        title = mapModel.title
        mapView.delegate = self
        mapView.setRegion(mapModel.region, animated: true)
        mapView.mapType = mapModel.mapType
        mapView.register(BikeStationAnnotationView.self, forAnnotationViewWithReuseIdentifier: "BikeStationAnnotationView")
        mapView.showsUserLocation = true
        locationManager = CLLocationManager() //¹
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }
        
        // MARK: FUIMKMapViewDataSource
        self.dataSource = self

        // MARK: FUIMapLegend
        legend.headerTextView.text = mapModel.legendTitle
        legend.items = mapModel.legendModel
        
        // MARK: Search Results
        searchResultsObject = SearchResultsControllerObject(self)
        didSelectBikeStationSearchResult = { [unowned self] station in
            if let app = UIApplication.shared.delegate as? AppDelegate, let window = app.window {
                window.endEditing(true)
            }
            self.pushContent(station)
        }
        detailPanel.searchResults.tableView.register(FUIObjectTableViewCell.self, forCellReuseIdentifier: FUIObjectTableViewCell.reuseIdentifier)
        detailPanel.searchResults.tableView.dataSource = searchResultsObject
        detailPanel.searchResults.tableView.delegate = searchResultsObject
        detailPanel.searchResults.searchBar.delegate = searchResultsObject
        detailPanel.content.tableView.register(FUIMapDetailTagObjectTableViewCell.self, forCellReuseIdentifier: FUIMapDetailTagObjectTableViewCell.reuseIdentifier)
        detailPanel.content.tableView.register(FUIMapDetailPanel.ButtonTableViewCell.self, forCellReuseIdentifier: FUIMapDetailPanel.ButtonTableViewCell.reuseIdentifier)
    }
    
    internal func pushContent(_ bikeStationAnnotation: BikeStationAnnotation) {
        let region = MKCoordinateRegion(center: bikeStationAnnotation.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.002, longitudeDelta: 0.002))
        mapView.setRegion(region, animated: true)
        contentObject = ContentControllerObject(bikeStationAnnotation)
        detailPanel.content.headlineText = contentObject.headlineText
        detailPanel.content.subheadlineText = contentObject.subheadlineText
        detailPanel.pushChildViewController()
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let bikeStationAnnotation = view.annotation as? BikeStationAnnotation else { return }
        pushContent(bikeStationAnnotation)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let _ = annotation as? MKUserLocation { return nil }
        guard !(annotation is MKClusterAnnotation) else {
            if isClusteringStations {
                let clusterAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: MKMapViewDefaultClusterAnnotationViewReuseIdentifier) as? MKMarkerAnnotationView
                clusterAnnotationView?.markerTintColor = Colors.lightBlue
                clusterAnnotationView?.titleVisibility = .hidden
                clusterAnnotationView?.subtitleVisibility = .hidden
                return clusterAnnotationView
            } else {
                let bikeStationAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "BikeStationAnnotationView") as? BikeStationAnnotationView
                bikeStationAnnotationView?.displayPriority = .required
                return bikeStationAnnotationView
            }
        }
        if let bikeStationAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "BikeStationAnnotationView", for: annotation) as? BikeStationAnnotationView {
            bikeStationAnnotationView.clusteringIdentifier = "bike"
            bikeStationAnnotationView.canShowCallout = true
            bikeStationAnnotationView.displayPriority = .defaultLow
            return bikeStationAnnotationView
        }
        return nil
    }
    
    var locationManager: CLLocationManager!
    var currentLocation: CLLocation? {
        didSet {
            mapModel.userLocation = currentLocation
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) { // ¹
        defer {
            currentLocation = locations.last
        }
        
        if currentLocation == nil {
            // Zoom to user location
            if let userLocation = locations.last {
                let viewRegion = MKCoordinateRegion(center: userLocation.coordinate, latitudinalMeters: 2000, longitudinalMeters: 2000)
                mapView.setRegion(viewRegion, animated: false)
            }
        }
    }
}

// MARK: FUIMKMapViewDataSource

extension ViewController: FUIMKMapViewDataSource {
    
    func mapView(_ mapView: MKMapView, geometriesForLayer layer: FUIGeometryLayer) -> [FUIAnnotation] {
        return mapModel.stationModel
    }
    
    func numberOfLayers(in mapView: MKMapView) -> Int {
        return mapModel.layerModel.count
    }
    
    func mapView(_ mapView: MKMapView, layerAtIndex index: Int) -> FUIGeometryLayer {
        return mapModel.layerModel[index]
    }
}

// ¹: https://stackoverflow.com/questions/25449469/show-current-location-and-update-location-in-mkmapview-in-swift
