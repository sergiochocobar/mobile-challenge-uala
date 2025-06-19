//
//  GetMainScreenBFFUseCase.swift
//  MobileChallengeUala
//
//  Created by Sergio Chocobar on 13/06/2025.
//

import Foundation
import Combine

protocol GetMainScreenUseCaseProtocol {
    func execute() -> AnyPublisher<[MainModel]?, Error>
}

class GetMainScreenUseCase: GetMainScreenUseCaseProtocol {
    let repository: MainViewRepository
    
    init(repository: MainViewRepository) {
        self.repository = repository
    }
    
    func execute() -> AnyPublisher<[MainModel]?, Error> {
        return repository.getData()
            .map { (dtos) in
                if let dtos = dtos {
                    let models = dtos.map { MainModel(dto: $0) }
                    return (models)
                } else {
                    return (nil)
                }
            }
            .eraseToAnyPublisher()
    }
}
