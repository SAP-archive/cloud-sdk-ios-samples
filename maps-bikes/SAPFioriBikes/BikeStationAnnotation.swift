//
//  BikeStationAnnotation.swift
//
//  Copyright © 2019 SAP SE or an SAP affiliate company. All rights reserved.
//

import MapKit
import UIKit
import SAPFiori

class BikeStationAnnotation: NSObject, FUIAnnotation {
    
    var state: FUIMapFloorplan.State  = .default
    
    var layer: FUIGeometryLayer = FUIGeometryLayer(displayName: "default")
    
    var indexPath: IndexPath = IndexPath()
    
    var information: StationInformation? = nil
    
    var status: StationStatus? = nil
    
    var coordinate: CLLocationCoordinate2D {
        get {
            guard let information = information, let lat = information.lat, let lon = information.lon else { return CLLocationCoordinate2D(latitude: 0, longitude: 0)}
            return CLLocationCoordinate2D(latitude: lat, longitude: lon)
        }
    }
    var title: String? {
        get {
            guard let information = information else { return nil }
            return information.name
        }
    }
    
    var numBikes: Int {
        get {
            return status?.num_bikes_available ?? 0
        }
    }
    
    var numEBikes: Int {
        get {
            return status?.num_ebikes_available ?? 0
        }
    }
    
    var numDocsAvailable: Int {
        get {
            return status?.num_docks_available ?? 0
        }
    }
}
