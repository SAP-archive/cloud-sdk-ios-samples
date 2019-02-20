//
//  VenueOverlay.swift
//
//  Copyright © 2019 SAP SE or an SAP affiliate company. All rights reserved.
//

import Foundation
import MapKit
import SAPFiori

class VenueAnnotation: MKPointAnnotation, FUIAnnotation {
    
    var state: FUIMapFloorplan.State = .default
    
    var layer: FUIGeometryLayer = FUIGeometryLayer(displayName: Layer.custom)
    
    var indexPath: IndexPath = IndexPath(row: 0, section: 0)
    
}

class VenueLineOverlay: MKPolyline, FUIOverlay {
    
    var overlayRenderer: [FUIMapFloorplan.State : MKOverlayRenderer] = [:]
    
    var state: FUIMapFloorplan.State = .default
    
    var layer: FUIGeometryLayer = FUIGeometryLayer(displayName: Layer.bart)
    
    var indexPath: IndexPath = IndexPath(index: -1, routeIndex: -1)
}

class VenuePolygonOverlay: MKPolygon, FUIOverlay {
    
    var overlayRenderer: [FUIMapFloorplan.State : MKOverlayRenderer] = [:]
    
    var state: FUIMapFloorplan.State = .default
    
    var layer: FUIGeometryLayer = FUIGeometryLayer(displayName: Layer.bart)
    
    var indexPath: IndexPath = IndexPath(index: -1, routeIndex: -1)
    
}
