//
//  MainModel.swift
//  MobileChallengeUala
//
//  Created by NaranjaX on 13/06/2025.
//

struct MainModel {
    let country: String
    let name: String
    let id: Int
    let coord: CoordinatesModel
    
    init(dto: MainDTO) {
        self.country = dto.country
        self.name = dto.name
        self.id = dto.id
        self.coord = CoordinatesModel(dto: dto.coord)
    }
}


struct CoordinatesModel {
    let lon: Double
    let lat: Double

    init(dto: CoordinatesDTO) {
        self.lon = dto.lon
        self.lat = dto.lat
    }
}
