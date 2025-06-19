//
//  MainBFFRepository.swift
//  MobileChallengeUala
//
//  Created by Sergio Chocobar on 13/06/2025.
//

import Foundation
import Combine

protocol MainViewRepository {
    func getData() -> AnyPublisher <[MainDTO]?, Error>
}
