//
//  LocalMainViewRepository.swift
//  MobileChallengeUala
//
//  Created by Sergio Chocobar on 13/06/2025.
//

import Foundation
import Combine

class LocalMainViewRepository: MainViewRepository {
    func getData() -> AnyPublisher<[MainDTO]?, Error> {

        if let data = localData.json.data(using: .utf8) {
            return Just(data)
                .decode(type: [MainDTO].self, decoder: JSONDecoder())
                .map { (dto) in
                    return (dto)
                }
                .eraseToAnyPublisher()
        } else {
            return Fail(error: CustomError.unknownError)
                .eraseToAnyPublisher()
        }
    }
}

//MARK: Sergio - Moverlo a otro lado
enum CustomError: Error, Decodable {
    case unknownError
    case unauthorized
}

private struct localData {
    static var json = """
[{"country":"UA","name":"Hurzuf","_id":707860,"coord":{"lon":34.283333,"lat":44.549999}},
{"country":"RU","name":"Novinki","_id":519188,"coord":{"lon":37.666668,"lat":55.683334}},
{"country":"NP","name":"Gorkhā","_id":1283378,"coord":{"lon":84.633331,"lat":28}},
{"country":"IN","name":"State of Haryāna","_id":1270260,"coord":{"lon":76,"lat":29}},
{"country":"UA","name":"Holubynka","_id":708546,"coord":{"lon":33.900002,"lat":44.599998}},
{"country":"NP","name":"Bāgmatī Zone","_id":1283710,"coord":{"lon":85.416664,"lat":28}},
{"country":"RU","name":"Mar’ina Roshcha","_id":529334,"coord":{"lon":37.611111,"lat":55.796391}},
{"country":"IN","name":"Republic of India","_id":1269750,"coord":{"lon":77,"lat":20}},
{"country":"NP","name":"Kathmandu","_id":1283240,"coord":{"lon":85.316666,"lat":27.716667}},
{"country":"UA","name":"Laspi","_id":703363,"coord":{"lon":33.733334,"lat":44.416668}},
{"country":"VE","name":"Merida","_id":3632308,"coord":{"lon":-71.144997,"lat":8.598333}},
{"country":"RU","name":"Vinogradovo","_id":473537,"coord":{"lon":38.545555,"lat":55.423332}},
{"country":"IQ","name":"Qarah Gawl al ‘Ulyā","_id":384848,"coord":{"lon":45.6325,"lat":35.353889}}]
"""
}


