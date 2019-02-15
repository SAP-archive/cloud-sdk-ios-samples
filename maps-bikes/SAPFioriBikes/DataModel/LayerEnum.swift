//
//  LayerEnum.swift
//  SAPFioriBikes
//
//  Created by Takahashi, Alex on 1/16/19.
//  Copyright © 2019 Takahashi, Alex. All rights reserved.
//

import Foundation

enum Layer {
    static var bikes = "Bikes Layer"
    static var bart = "Bart Layer"
    static var custom = "Custom Layer"
    
    enum Editing {
        static var walkZone = "Walk Zone"
        static var bikePath = "Bike Path"
        static var brewery = "Brewery"
        static var venue = "Venue"
    }
}
