//
//  StationInformationRequest.swift
//  SAPFioriBikes
//
//  Created by Takahashi, Alex on 11/20/18.
//  Copyright © 2018 Takahashi, Alex. All rights reserved.
//

import UIKit
import MapKit

struct StationInformationRequest: Decodable {
    let last_updated: CGFloat?
    let ttl: Int?
    let data: StationInformationData?
    
    enum StationInformationRequestKeys: String, CodingKey {
        case last_updated = "last_updated"
        case ttl = "ttl"
        case data = "data"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StationInformationRequestKeys.self)
        self.last_updated = try container.decodeIfPresent(CGFloat.self, forKey: .last_updated)
        self.ttl = try container.decodeIfPresent(Int.self, forKey: .ttl)
        self.data = try container.decodeIfPresent(StationInformationData.self, forKey: .data)
    }
}

struct StationInformationData: Decodable {
    let stations: [StationInformation?]?
    
    enum StationInformationDataKeys: String, CodingKey {
        case stations = "stations"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StationInformationDataKeys.self)
        self.stations = try container.decodeIfPresent([StationInformation].self, forKey: .stations)
    }
}

struct StationInformation: Decodable, StationIDProducing {
    let station_id: String?
    let external_id: String?
    let name: String?
    let short_name: String?
    let lat: CLLocationDegrees?
    let lon: CLLocationDegrees?
    let region_id: Int?
    let rental_methods: [String?]?
    let capacity: Int?
    let rental_url: String?
    let eightd_has_key_dispenser: Bool?
    let eightd_station_services: [StationInformationServices?]?
    let has_kiosk: Bool?
    
    enum StationInformationKeys: String, CodingKey {
        case station_id = "station_id"
        case external_id = "external_id"
        case name = "name"
        case short_name = "short_name"
        case lat = "lat"
        case lon = "lon"
        case region_id = "region_id"
        case rental_methods = "rental_methods"
        case capacity = "capacity"
        case rental_url = "rental_url"
        case eightd_has_key_dispenser = "eightd_has_key_dispenser"
        case eightd_station_services = "eightd_station_services"
        case has_kiosk = "has_kiosk"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StationInformationKeys.self)
        self.station_id = try container.decodeIfPresent(String.self, forKey: .station_id)
        self.external_id = try container.decodeIfPresent(String.self, forKey: .external_id)
        self.name = try container.decodeIfPresent(String.self, forKey: .name)
        self.short_name = try container.decodeIfPresent(String.self, forKey: .short_name)
        self.lat = try container.decodeIfPresent(CLLocationDegrees.self, forKey: .lat)
        self.lon = try container.decodeIfPresent(CLLocationDegrees.self, forKey: .lon)
        self.region_id = try container.decodeIfPresent(Int.self, forKey: .region_id)
        self.rental_methods = try container.decodeIfPresent([String].self, forKey: .rental_methods)
        self.capacity = try container.decodeIfPresent(Int.self, forKey: .capacity)
        self.rental_url = try container.decodeIfPresent(String.self, forKey: .rental_url)
        self.eightd_has_key_dispenser = try container.decodeIfPresent(Bool.self, forKey: .eightd_has_key_dispenser)
        self.eightd_station_services = try container.decodeIfPresent([StationInformationServices].self, forKey: .eightd_station_services)
        self.has_kiosk = try container.decodeIfPresent(Bool.self, forKey: .has_kiosk)
    }
}

struct StationInformationServices: Decodable {
    let id: String?
    let service_type: String?
    let bikes_availability: String?
    let docks_availability: String?
    let name: String?
    let description: String?
    let schedule_description: String?
    let link_for_more_info: String?
    
    enum StationInformationServicesKeys: String, CodingKey {
        case id = "id"
        case service_type = "service_type"
        case bikes_availability = "bikes_availability"
        case docks_availability = "docks_availability"
        case name = "name"
        case description = "description"
        case schedule_description = "schedule_description"
        case link_for_more_info = "link_for_more_info"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StationInformationServicesKeys.self)
        self.id = try container.decodeIfPresent(String.self, forKey: .id)
        self.service_type = try container.decodeIfPresent(String.self, forKey: .service_type)
        self.bikes_availability = try container.decodeIfPresent(String.self, forKey: .bikes_availability)
        self.docks_availability = try container.decodeIfPresent(String.self, forKey: .docks_availability)
        self.name = try container.decodeIfPresent(String.self, forKey: .name)
        self.description = try container.decodeIfPresent(String.self, forKey: .description)
        self.schedule_description = try container.decodeIfPresent(String.self, forKey: .schedule_description)
        self.link_for_more_info = try container.decodeIfPresent(String.self, forKey: .link_for_more_info)
    }
}
