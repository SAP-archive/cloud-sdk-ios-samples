//
//  BartStationOverlay.swift
//  SAPFioriBikes
//
//  Created by Takahashi, Alex on 12/29/18.
//  Copyright © 2018 Takahashi, Alex. All rights reserved.
//

import Foundation
import MapKit
import SAPFiori

class BartLineOverlay: MKPolyline, FUIOverlay {
    
    var overlayRenderer: [FUIMapFloorplan.State : MKOverlayRenderer] = [:]
    
    var state: FUIMapFloorplan.State = .default
    
    var layer: FUIGeometryLayer = FUIGeometryLayer(displayName: Layer.bart)
    
    var indexPath: IndexPath = IndexPath(index: -1, routeIndex: -1)
}

class BartStationOverlay: MKPolygon, FUIOverlay {
    
    var overlayRenderer: [FUIMapFloorplan.State : MKOverlayRenderer] = [:]
    
    var state: FUIMapFloorplan.State = .default
    
    var layer: FUIGeometryLayer = FUIGeometryLayer(displayName: Layer.bart)
    
    var indexPath: IndexPath = IndexPath(index: -1, routeIndex: -1)
    
}
