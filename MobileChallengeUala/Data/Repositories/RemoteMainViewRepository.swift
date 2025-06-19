//
//  RemoteMainViewRepository.swift
//  MobileChallengeUala
//
//  Created by Sergio Chocobar on 16/06/2025.
//

import Foundation
import Combine

class RemoteMainViewRepository: MainViewRepository {
    
    func getData() -> AnyPublisher<[MainDTO]?, Error> {
        guard let url = URL(string: Endpoint.data) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { (data, response) in
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                return data
            }
            .decode(type: [MainDTO]?.self, decoder: JSONDecoder())
            .mapError { error in
                print("Error al obtener o decodificar datos: \(error)")
                return error
            }
            .eraseToAnyPublisher()
    }
}

private struct Endpoint {
    static var data = "https://gist.githubusercontent.com/hernan-uala/dce8843a8edbe0b0018b32e137bc2b3a/raw/0996accf70cb0ca0e16f9a99e0ee185fafca7af1/cities.json"
}


