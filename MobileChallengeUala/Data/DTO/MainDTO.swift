//
//  MainDTO.swift
//  MobileChallengeUala
//
//  Created by Sergio Chocobar on 13/06/2025.
//

struct MainDTO: Decodable {
    let country: String
    let name: String
    let id: Int
    let coord: CoordinatesDTO

    enum CodingKeys: String, CodingKey {
        case country, name
        case id = "_id"
        case coord
    }
}


struct CoordinatesDTO: Decodable {
    let lon: Double
    let lat: Double
}

