//
//  BikeStationAnnotation.swift
//  SAPFioriBikes
//
//  Created by Takahashi, Alex on 11/14/18.
//  Copyright © 2018 Takahashi, Alex. All rights reserved.
//

import MapKit
import UIKit
import SAPFiori

class BikeStationAnnotation: NSObject, FUIAnnotation {
    
    static var displayName = Layer.bikes
    
    var state: FUIMapFloorplan.State  = .default
    
    var layer: FUIGeometryLayer = FUIGeometryLayer(displayName: BikeStationAnnotation.displayName)
    
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
    
    var distanceToUser: CLLocationDistance? = nil
    
    var distanceToUserString: String? {
        get {
            guard let distanceToUser = distanceToUser else { return nil }
            let distanceFormatter = MKDistanceFormatter()
            distanceFormatter.units = .imperial
            distanceFormatter.distance
            return distanceFormatter.string(fromDistance: distanceToUser)
        }
    }
    
    var rentalUrl: URL? {
        guard let rental_url = information?.rental_url else { return nil }
        return URL(string: rental_url)
    }
}
