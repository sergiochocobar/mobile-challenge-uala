//
//  MainViewModel.swift
//  MobileChallengeUala
//
//  Created by Sergio Chocobar on 13/06/2025.
//

import SwiftUI
import Combine

enum ViewState<T> {
    case loading
    case internetError
    case failure(primaryClosure: (() -> Void)?, secondaryClosure: (() -> Void)?)
    case success(model: T)
    
    func stringValue() -> String {
        switch self {
        case .loading:
            return "loading"
        case .internetError:
            return "internetError"
        case .failure:
            return "failure"
        case .success:
            return "success"
        }
    }
}

class MainViewModel: ObservableObject {
    @Published var state: ViewState<[MainModel]> = .loading
    private let getBFFUseCase: GetMainScreenUseCaseProtocol
    private var cancellables = Set<AnyCancellable>()
    @Published var searchText: String = ""
    
    
    var filteredModels: [MainModel] {
        guard case .success(let models) = state else {
            return []
        }
        
        let filtered: [MainModel]
        if searchText.isEmpty {
            filtered = models
        } else {
            filtered = models.filter { $0.name.lowercased().hasPrefix(searchText.lowercased()) }
        }
        
        return filtered.sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
    }
    
    
    init(useCase: GetMainScreenUseCaseProtocol) {
        self.getBFFUseCase = useCase
    }
    
    func loadData() {
        
        getBFFUseCase.execute()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("Error: \(error)")
                case .finished:
                    print("Terminado")
                }
            }, receiveValue: { models in
                if let models = models {
                    self.state = .success(model: models)
                    //                    print("Sergio: Success --> " + models[3].name)
                } else {
                    //                    self.handleLoadDataFailure()
                    print("Sergio: Failure")
                    
                }
            })
            .store(in: &cancellables)
        
    }
}
