//
//  MapModel.swift
//  SAPFioriBikes
//
//  Created by Takahashi, Alex on 11/20/18.
//  Copyright © 2018 Takahashi, Alex. All rights reserved.
//

import MapKit
import SAPFiori
import StellarJay

class FioriBikeMapModel {
    
    // MARK: Standard Map Buisiness Objects
    
    let title: String = "Ford GoBike Map"
    
    let region: MKCoordinateRegion = {
        let center = CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194)
        let span = MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
        return MKCoordinateRegion(center: center, span: span)
    }()
    
    let mapType: MKMapType = .mutedStandard
    
    // MARK: FUIMKMapViewDataSource Buisiness Objects
    
    weak var delegate: ViewController? = nil
    
    var layerModel: [FUIGeometryLayer] = [
        FUIGeometryLayer(displayName: Layer.bikes),
        FUIGeometryLayer(displayName: Layer.bart),
        FUIGeometryLayer(displayName: Layer.custom)
    ]
    
    var layerIsEnabled: [Bool] {
        get {
            return [stationIsEnabled, bartLineIsEnabled, editingLayerIsEnabled]
        }
        set {
            guard newValue.count == layerModel.count else { preconditionFailure() }
            stationIsEnabled = newValue[0]
            bartLineIsEnabled = newValue[1]
            editingLayerIsEnabled = newValue[2]
            self.delegate?.reloadData()
        }
    }
    
    private var _stationModel: [BikeStationAnnotation] = []
    
    public var stationIsEnabled: Bool = true
    
    public var stationModel: [BikeStationAnnotation] {
        get {
            guard stationIsEnabled else { return [] }
            return _stationModel
        }
    }
    
    public var bartLineIsEnabled: Bool = true
    
    private var _bartLineMode: [FUIOverlay] = []
    
    public var bartLineModel: [FUIOverlay] {
        get {
            guard bartLineIsEnabled else { return [] }
            return _bartLineMode
        }
    }
    
    public var editingLayerIsEnabled: Bool = true
    
    public var _editingModel: [FUIAnnotation] = []
    
    public var editingModel: [FUIAnnotation] {
        get {
            guard editingLayerIsEnabled else { return [] }
            return _editingModel
        }
    }
    
    
    func loadData(isLiveData: Bool = false) {
        isLiveData ? loadLiveData() : loadLocalData()
        loadBartData()
    }
    
    var userLocation: CLLocation? {
        didSet {
            guard let userLocation = userLocation else { return }
            for station in stationModel {
                station.distanceToUser = userLocation.distance(from: station.coordinate)
            }
            _stationModel.sort(by: { return Double($0.distanceToUser!) < Double($1.distanceToUser!) })
        }
    }
    
    // MARK: FUIMapLegend Buisiness Objects
    
    var legendTitle: String {
        return title + " Legend"
    }
    
    let legendModel: [FUIMapLegendItem] = {
        let bikeLegendItem: FUIMapLegendItem = {
            var bikeItem = FUIMapLegendItem(title: "Bike")
            bikeItem.backgroundColor = Colors.green
            bikeItem.icon = FUIMapLegendIcon(glyphImage: "")
            return bikeItem
        }()
        
        let eBikeLegendItem: FUIMapLegendItem = {
            var eBikeItem = FUIMapLegendItem(title: "EBike")
            eBikeItem.backgroundColor = Colors.darkBlue
            eBikeItem.icon = FUIMapLegendIcon(glyphImage: "")
            return eBikeItem
        }()
        
        let stationItem: FUIMapLegendItem = {
            var stationItem = FUIMapLegendItem(title: "Station")
            stationItem.backgroundColor = Colors.lightBlue
            stationItem.icon = FUIMapLegendIcon(glyphImage: "")
            return stationItem
        }()
        
        let emptyStationItem: FUIMapLegendItem = {
            var emptyStation = FUIMapLegendItem(title: "Empty Station")
            emptyStation.backgroundColor = Colors.red
            emptyStation.icon = FUIMapLegendIcon(glyphImage: "")
            return emptyStation
        }()
        return [bikeLegendItem, eBikeLegendItem, stationItem, emptyStationItem]
    }()
    
    // MARK: Editing Buisiness Objects
    
    let editingItemsModel: [FUIMapLegendItem] = {
        let walkZoneItem: FUIMapLegendItem = {
            var item = FUIMapLegendItem(title: Layer.Editing.walkZone)
            let image = FUIAttributedImage(image: FUIIconLibrary.map.marker.walk.withRenderingMode(.alwaysTemplate))
            image.tintColor = .white
            item.icon = FUIMapLegendIcon(glyphImage: image)
            item.backgroundColor = Colors.red
            return item
        }()
        
        let bikePathItem: FUIMapLegendItem = {
            var item = FUIMapLegendItem(title: Layer.Editing.bikePath)
            guard let bicycleImage = UIImage(named: "bicycle") else { return item }
            let image = FUIAttributedImage(image: bicycleImage.withRenderingMode(.alwaysTemplate))
            image.tintColor = .white
            item.icon = FUIMapLegendIcon(glyphImage: image)
            item.backgroundColor = Colors.red
            return item
        }()
        
        let breweryItem: FUIMapLegendItem = {
            var item = FUIMapLegendItem(title: Layer.Editing.brewery)
            item.icon = FUIMapLegendIcon(glyphImage: "🍻")
            return item
        }()
        
        let venueItem: FUIMapLegendItem = {
            var item = FUIMapLegendItem(title: Layer.Editing.venue)
            let image = FUIAttributedImage(image: FUIIconLibrary.map.marker.venue.withRenderingMode(.alwaysTemplate))
            image.tintColor = .white
            item.icon = FUIMapLegendIcon(glyphImage: image)
            return item
        }()
        return [walkZoneItem, bikePathItem, breweryItem, venueItem]
    }()
    
    // MARK: Private Functions
    
    private var stationInformationModel: [StationInformation] = []
    private var stationStatusModel: [StationStatus] = []
    private var stationDictionary: [String: BikeStationAnnotation] = [:]
    
    private func loadLocalData() {
        if let path = Bundle.main.path(forResource: "station_information", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                loadStationInformationData(data)
            } catch let jsonError {
                print("❌ \(jsonError)")
            }
        }
        if let path = Bundle.main.path(forResource: "station_status", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                loadStationStatusData(data)
            } catch let jsonError {
                print("❌ \(jsonError)")
            }
        }
    }
    
    private func loadLiveData() {
        guard let stationInformationURL: URL = URL(string: "https://gbfs.fordgobike.com/gbfs/en/station_information.json")else { return }
        URLSession.shared.dataTask(with: stationInformationURL) { [weak self] (data, response, err) in
            guard err == nil else { print("Error fetching data: \(String(describing: err))"); return }
            guard let data = data else { return }
            self?.loadStationInformationData(data)
        }.resume()
        
        guard let stationStatusURL: URL = URL(string: "https://gbfs.fordgobike.com/gbfs/en/station_status.json") else { return }
        URLSession.shared.dataTask(with: stationStatusURL) { [weak self] (data, response, err) in
            guard err == nil else { print("Error fetching data: \(String(describing: err))"); return }
            guard let data = data else { return }
            self?.loadStationStatusData(data)
        }.resume()
    }
    
    private func loadStationStatusData(_ data: Data) {
        do {
            let request = try JSONDecoder().decode(StationStatusRequest.self, from: data)
            guard let stations = request.data?.stations else { return }
            self.stationStatusModel = stations.compactMap({return $0})
            for station in self.stationStatusModel {
                self.merge(station)
            }
            self._stationModel = self.stationDictionary.map({ return $0.value })
            self.delegate?.reloadData()
        }   catch let jsonError {
            print("❌ \(jsonError)")
        }
    }
    
    private func loadStationInformationData(_ data: Data) {
        do {
            let request = try JSONDecoder().decode(StationInformationRequest.self, from: data)
            guard let stations = request.data?.stations else { return }
            self.stationInformationModel = stations.compactMap({return $0})
            for station in self.stationInformationModel {
                self.merge(station)
            }
            self._stationModel = self.stationDictionary.map({ return $0.value })
            self.delegate?.reloadData()
        }   catch let jsonError {
            print("❌ \(jsonError)")
        }
    }
    
    private func merge<T: StationIDProducing>(_ stationDataObject: T) {
        guard let stationID = stationDataObject.station_id else { return }
        guard stationDictionary.contains(where: { return $0.key == stationID }) else {
            let newFioriStation = BikeStationAnnotation()
            stationIDDataBind(newFioriStation, stationDataObject)
            stationDictionary[stationID] = newFioriStation
            return
        }
        guard let cachedFioriStation = stationDictionary[stationID] else { return }
        stationIDDataBind(cachedFioriStation, stationDataObject)
    }
    
    private func stationIDDataBind<T: StationIDProducing>(_ stationObject: BikeStationAnnotation, _ stationDataObject: T) {
        if let status = stationDataObject as? StationStatus {
            stationObject.status = status
        } else if let information = stationDataObject as? StationInformation {
            stationObject.information = information
        }
    }
    
    private func loadBartData() {
        let url: URL = Bundle.main.url(forResource: "bart", withExtension: "geojson")!
        
        var featureCollection: FeatureCollection<Feature<BartData.Line>>!
        
        do {
            let data = try Data(contentsOf: url)
            featureCollection = try JSONDecoder().decode(FeatureCollection<Feature<BartData.Line>>.self, from: data)
        }
        catch {
            print(error)
        }
        
        let polygons: [MKPolygon] = featureCollection.features.reduce(into: Array<MKPolygon>()) { prev, next in
            guard let polygon = next.geometry as? Polygon else { return }
            prev += polygon.coordinates.map {
                return MKPolygon(coordinates: $0, count: $0.count)
            }
        }
        let polygonOverlays: [FUIOverlay] = polygons.map({ return BartStationOverlay(points: $0.points(), count: $0.pointCount)})
        self._bartLineMode.append(contentsOf: polygonOverlays)
        
        let polylines: [MKPolyline] = featureCollection.features.reduce(into: Array<MKPolyline>()) { prev, next in
            guard let multiLineString = next.geometry as? MultiLineString else { return }
            prev += multiLineString.toMKPolylines()
        }
        let polylineOverlays: [FUIOverlay] = polylines.map({ return BartLineOverlay(points: $0.points(), count: $0.pointCount) })
        self._bartLineMode.append(contentsOf: polylineOverlays)
        self.delegate?.reloadData()
    }
}

fileprivate extension CLLocation {

    func distance(from location: CLLocationCoordinate2D) -> CLLocationDistance {
        return self.distance(from: CLLocation(latitude: location.latitude, longitude: location.longitude))
    }
    
}
