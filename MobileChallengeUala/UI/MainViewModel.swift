//
//  MainViewModel.swift
//  MobileChallengeUala
//
//  Created by Sergio Chocobar on 13/06/2025.
//

import SwiftUI
import Combine
import MapKit

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
    @Published var selectedCity: MainModel? 
    @Published var region: MKCoordinateRegion
    @Published var favoriteCities: [MainModel] = []
    
    
    var filteredModels: [MainModel] {
        guard case .success(let models) = state else {
            return []
        }

        let base: [MainModel]
        if searchText.isEmpty {
            base = models
        } else {
            base = models.filter { $0.name.lowercased().hasPrefix(searchText.lowercased()) }
        }

        return base.map { model in
            var copy = model
            copy.isFavorite = favoriteCities.contains(where: { $0.id == model.id })
            return copy
        }.sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
    }
    
    
    init(useCase: GetMainScreenUseCaseProtocol) {
        self.getBFFUseCase = useCase
        
        _region = Published(initialValue: MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: -34.6037, longitude: -58.3816), // coordenadas por deecto
            span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
        ))
        print(favoriteCities)
    }
    
    func loadData() {
        
        getBFFUseCase.execute()
            .receive(on: DispatchQueue.main)
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
    
    
    //metodo para seleccion de ciudad al tocar
    func updateMapRegion(for city: MainModel) {
        region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: city.coord.lat, longitude: city.coord.lon),
            span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
        )
    }
    
    
    // MARK: - Lógica de Favoritos
      
      func toggleFavorite(for city: MainModel) {
          if let index = favoriteCities.firstIndex(where: { $0.id == city.id }) {
              favoriteCities.remove(at: index)
          } else {
              var cityToAdd = city
              cityToAdd.isFavorite = true
              favoriteCities.append(cityToAdd)
          }

          saveFavorites()
          print(favoriteCities)
      }
      
      private func saveFavorites() {
          if let encoded = try? JSONEncoder().encode(favoriteCities) {
              UserDefaults.standard.set(encoded, forKey: "favoriteCities")
          }
      }
      
      private func loadFavorites() {
          if let savedFavoritesData = UserDefaults.standard.data(forKey: "favoriteCities"),
             let decodedFavorites = try? JSONDecoder().decode([MainModel].self, from: savedFavoritesData) {
              self.favoriteCities = decodedFavorites
          }
      }
}
