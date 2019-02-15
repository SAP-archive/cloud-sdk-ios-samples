//
//  BartData_model.swift
//  SAPFioriBikes
//
//  Created by Takahashi, Alex on 1/15/19.
//  Copyright © 2019 Takahashi, Alex. All rights reserved.
//

import Foundation

public enum BartData {
    
    public struct Line: Decodable {
        
        private enum CodingKeys: String, CodingKey {
            case name = "name"
            case colorHexString = "color"
            case station = "station"
        }
        
        public init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            if let name = try values.decodeIfPresent(String.self, forKey: .name) {
                self.name = name
            } else {
                self.name = nil
            }
            if let hex = try values.decodeIfPresent(String.self, forKey: .colorHexString) {
                self.colorHexString = hex
            } else {
                self.colorHexString = nil
            }
            if let station = try values.decodeIfPresent(String.self, forKey: .station) {
                self.station = station
            } else {
                self.station = nil
            }
        }
        
        public let name: String?
        public let colorHexString: String?
        public let station: String?
    }
    
}
