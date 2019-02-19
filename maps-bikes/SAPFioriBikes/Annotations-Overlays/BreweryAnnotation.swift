//
//  BreweryAnnotation.swift
//
//  Copyright © 2019 SAP SE or an SAP affiliate company. All rights reserved.
//

import Foundation
import MapKit
import SAPFiori

class BreweryAnnotation: MKPointAnnotation, FUIAnnotation {

    var state: FUIMapFloorplan.State = .default
    
    var layer: FUIGeometryLayer = FUIGeometryLayer(displayName: Layer.custom)
    
    var indexPath: IndexPath = IndexPath(row: 0, section: 0)
    
}
