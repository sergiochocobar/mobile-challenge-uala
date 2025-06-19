//
//  MainModel.swift
//  MobileChallengeUala
//
//  Created by NaranjaX on 13/06/2025.
//

import MapKit

struct MainModel: Identifiable, Codable {
    let country: String
    let name: String
    let id: Int
    let coord: CoordinatesModel
    var isFavorite: Bool

    init(dto: MainDTO) {
        self.country = dto.country
        self.name = dto.name
        self.id = dto.id
        self.coord = CoordinatesModel(dto: dto.coord)
        self.isFavorite = false
    }
}


struct CoordinatesModel: Codable {
    let lon: Double
    let lat: Double

    init(dto: CoordinatesDTO) {
        self.lon = dto.lon
        self.lat = dto.lat
    }
}


extension CoordinatesModel {
    var clLocationCoordinate2D: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: lat, longitude: lon)
    }
}
