//
//  MainView.swift
//  MobileChallengeUala
//
//  Created by Sergio Chocobar on 12/06/2025.
//

import SwiftUI

public struct MainView: View {
    @ObservedObject var viewModel: MainViewModel
    
    public var body: some View {
        ZStack {
            VStack {
                TextField("Buscar Ciudad",  text: $viewModel.searchText)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                
                switch viewModel.state {
                case .loading:
                    VStack {
                        Text("error al cargar 0")
                    }
                case .success:
                    List(viewModel.filteredModels, id: \.id) { item in
                        VStack(alignment: .leading) {
                            Text(item.name)
                                .font(.headline)
                            Text(item.country)
                                .font(.subheadline)
                            Text("Lat: \(item.coord.lat), Lon: \(item.coord.lon)")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                case .internetError:
                    VStack {
                        Text("error al cargar 1")
                    }
                case .failure(primaryClosure: let primaryClosure, secondaryClosure: let secondaryClosure):
                    VStack {
                        Text("error al cargar 2")
                    }
                }
                Spacer()
            }
        }
        .onAppear() {
            viewModel.loadData()
        }
    }
}

//#Preview {
//    MainView()
//}


// MARK: Sergio - Mover esto a otro lado    
extension MainView {
    public static func build() -> Self {
        let getUseCase = GetMainScreenUseCase(repository: RemoteMainViewRepository())
        let viewmodel = MainViewModel(useCase: getUseCase)
        let view = MainView(viewModel: viewmodel)
        return view
    }
}
