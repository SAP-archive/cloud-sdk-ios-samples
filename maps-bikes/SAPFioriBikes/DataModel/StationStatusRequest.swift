//
//  StationStatusRequest.swift
//  SAPFioriBikes
//
//  Created by Takahashi, Alex on 11/20/18.
//  Copyright © 2018 Takahashi, Alex. All rights reserved.
//

import UIKit
import MapKit

protocol StationIDProducing {
    var station_id: String? { get }
}

struct StationStatusRequest: Decodable {
    let last_updated: CGFloat?
    let ttl: Int?
    let data: StationStatusData?
    
    enum StationStatusRequestKeys: String, CodingKey {
        case last_updated = "last_updated"
        case ttl = "ttl"
        case data = "data"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StationStatusRequestKeys.self)
        self.last_updated = try container.decodeIfPresent(CGFloat.self, forKey: .last_updated)
        self.ttl = try container.decodeIfPresent(Int.self, forKey: .ttl)
        self.data = try container.decodeIfPresent(StationStatusData.self, forKey: .data)
    }
}

struct StationStatusData: Decodable {
    let stations: [StationStatus?]?
    
    enum StationStatusDataKeys: String, CodingKey {
        case stations = "stations"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StationStatusDataKeys.self)
        self.stations = try container.decodeIfPresent([StationStatus].self, forKey: .stations)
    }
}

struct StationStatus: Decodable, StationIDProducing {
    let station_id: String?
    let num_bikes_available: Int?
    let num_ebikes_available: Int?
    let num_bikes_disabled: Int?
    let num_docks_available: Int?
    let num_docks_disabled: Int?
    let is_installed: Int?
    let is_renting: Int?
    let is_returning: Int?
    let last_reported: CGFloat?
    let eightd_has_available_keys: Bool?
    let eightd_active_station_services: [StationStatusServices?]?
    
    enum StationStatusKeys: String, CodingKey {
        case station_id = "station_id"
        case num_bikes_available = "num_bikes_available"
        case num_ebikes_available = "num_ebikes_available"
        case num_bikes_disabled = "num_bikes_disabled"
        case num_docks_available = "num_docks_available"
        case num_docks_disabled = "num_docks_disabled"
        case is_installed = "is_installed"
        case is_renting = "is_renting"
        case is_returning = "is_returning"
        case last_reported = "last_reported"
        case eightd_has_available_keys = "eightd_has_available_keys"
        case eightd_active_station_services = "eightd_active_station_services"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StationStatusKeys.self)
        self.station_id = try container.decodeIfPresent(String.self, forKey: .station_id)
        self.num_bikes_available = try container.decodeIfPresent(Int.self, forKey: .num_bikes_available)
        self.num_ebikes_available = try container.decodeIfPresent(Int.self, forKey: .num_ebikes_available)
        self.num_bikes_disabled = try container.decodeIfPresent(Int.self, forKey: .num_bikes_disabled)
        self.num_docks_available = try container.decodeIfPresent(Int.self, forKey: .num_docks_available)
        self.num_docks_disabled = try container.decodeIfPresent(Int.self, forKey: .num_docks_disabled)
        self.is_installed = try container.decodeIfPresent(Int.self, forKey: .is_installed)
        self.is_renting = try container.decodeIfPresent(Int.self, forKey: .is_renting)
        self.is_returning = try container.decodeIfPresent(Int.self, forKey: .is_returning)
        self.last_reported = try container.decodeIfPresent(CGFloat.self, forKey: .last_reported)
        self.eightd_has_available_keys = try container.decodeIfPresent(Bool.self, forKey: .eightd_has_available_keys)
        self.eightd_active_station_services = try container.decodeIfPresent([StationStatusServices].self, forKey: .eightd_active_station_services)
    }
}

struct StationStatusServices: Decodable {
    let id: String?
    
    enum StationStatusServicesKeys: String, CodingKey {
        case id = "id"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StationStatusServicesKeys.self)
        self.id = try container.decodeIfPresent(String.self, forKey: .id)
    }
    
}
