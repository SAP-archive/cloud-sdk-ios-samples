//
//  BreweryAnnotation.swift
//  SAPFioriBikes
//
//  Created by Takahashi, Alex on 1/22/19.
//  Copyright © 2019 Takahashi, Alex. All rights reserved.
//

import Foundation
import MapKit
import SAPFiori

class BreweryAnnotation: MKPointAnnotation, FUIAnnotation {

    var state: FUIMapFloorplan.State = .default
    
    var layer: FUIGeometryLayer = FUIGeometryLayer(displayName: Layer.custom)
    
    var indexPath: IndexPath = IndexPath(row: 0, section: 0)
    
}
