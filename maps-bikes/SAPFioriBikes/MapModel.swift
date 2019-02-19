//
//  MapModel.swift
//
//  Copyright © 2019 SAP SE or an SAP affiliate company. All rights reserved.
//

import MapKit
import SAPFiori

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
    
    let layerModel: [FUIGeometryLayer] = [FUIGeometryLayer(displayName: "Bikes")]
    
    var stationModel: [BikeStationAnnotation] = []
    
    func loadData(isLiveData: Bool = false) {
        isLiveData ? loadLiveData() : loadLocalData()
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
            self.stationModel = self.stationDictionary.map({ return $0.value })
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
            self.stationModel = self.stationDictionary.map({ return $0.value })
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
}
