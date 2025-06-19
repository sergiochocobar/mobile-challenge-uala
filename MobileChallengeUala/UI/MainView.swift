//
//  MainView.swift
//  MobileChallengeUala
//
//  Created by Sergio Chocobar on 12/06/2025.
//

import SwiftUI
import MapKit

public struct MainView: View {
    @ObservedObject var viewModel: MainViewModel
    
    @Environment(\.verticalSizeClass) var verticalSizeClass
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    @State var mostrarFavoritos = false
    
    public var body: some View {
        ZStack {
            Map(coordinateRegion: $viewModel.region, interactionModes: .all, showsUserLocation: true, annotationItems: annotationItems) { item in
                MapMarker(coordinate: CLLocationCoordinate2D(latitude: item.coord.lat, longitude: item.coord.lon), tint: .red)
            }
            .edgesIgnoringSafeArea(.all)
            
            
            Group {
                if horizontalSizeClass == .regular && verticalSizeClass == .compact {
                    landscapeLayout
                } else if horizontalSizeClass == .compact && verticalSizeClass == .regular {
                    portraitLayout
                } else {
                    landscapeLayout
                }
            }
        }
        .onAppear() {
            viewModel.loadData()
        }
    }
    
    // MARK: Layout para Portrait (Arriba del mapa)
    private var portraitLayout: some View {
        VStack {
            searchBar
            if viewModel.selectedCity == nil {
                contentListView
            }
            Spacer()
        }
    }
    
    
    // MARK: Landscape
    private var landscapeLayout: some View {
        HStack {
            VStack {
                searchBar
                if viewModel.selectedCity == nil {
                    contentListView
                }
                Spacer()
            }
            .frame(width: 350)
            .padding(.vertical)
            
            Spacer()
        }
    }
    
    // MARK: Textfield busqueda
    private var searchBar: some View {
        HStack {
            if viewModel.selectedCity == nil {
                TextField("Buscar Ciudad", text: $viewModel.searchText)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .background(Color.white)
                    .cornerRadius(8)
                    .transition(.move(edge: .leading).combined(with: .opacity))
            }
       
            Button(action: {
                if viewModel.selectedCity == nil {
                    mostrarFavoritos.toggle()
                } else {
                    viewModel.selectedCity = nil
                }
            }) {
                Image(systemName: viewModel.selectedCity == nil ? mostrarFavoritos ? "star.fill" : "star" : "arrow.backward")
                    .font(.title2)
                    .foregroundColor(.yellow)
                    .frame(width: 65, height: 65)
                    .background(Color.white)
                    .cornerRadius(8)
            }
            .buttonStyle(PlainButtonStyle())
            
            if viewModel.selectedCity != nil {
               Spacer()
            }
        }
        .padding(.horizontal)
        .animation(.easeInOut(duration: 0.3), value: viewModel.selectedCity != nil)
    }
    
    // MARK: Listado de ciudades
    private var contentListView: some View {
        Group {
            switch viewModel.state {
            case .loading:
                VStack {
                    ProgressView("Cargando...")
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.white.opacity(0.8))
                .cornerRadius(8)
                .padding(.horizontal)
                
            case .success:
                List(mostrarFavoritos ? viewModel.favoriteCities : viewModel.filteredModels, id: \.id) { item in
                    HStack { 
                        VStack(alignment: .leading) {
                            Text("\(item.name), \(item.country)")
                                .font(.headline)
                            Text("Lat: \(item.coord.lat), Lon: \(item.coord.lon)")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            viewModel.selectedCity = item
                            viewModel.updateMapRegion(for: item)
                        }
                        Spacer()
                        
                    
                        Button(action: {
                            print("Tocado el boton favorito")
                            viewModel.toggleFavorite(for: item)
                        }) {
                            Image(systemName: item.isFavorite ? "star.fill" : "star")
                                .foregroundColor(.yellow)
                                .font(.title2)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    
                }
                .background(Color.white)
                .listStyle(.plain)
                .cornerRadius(8)
                .padding(.horizontal)

                
            case .internetError:
                VStack {
                    Image(systemName: "network.slash")
                        .font(.largeTitle)
                    Text("Error de conexión. Revisa tu internet.")
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.white.opacity(0.8))
                .cornerRadius(8)
                .padding(.horizontal)
                
            case .failure(primaryClosure: let primaryClosure, secondaryClosure: let secondaryClosure):
                VStack {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .font(.largeTitle)
                    Text("Ocurrió un error inesperado.")
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.white.opacity(0.8))
                .cornerRadius(8)
                .padding(.horizontal)
            }
        }
    }
    
    
    private var annotationItems: [MainModel] {
        if let city = viewModel.selectedCity {
            return [city]
        }
        return []
    }
}

struct MyView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(viewModel: MainViewModel(useCase: GetMainScreenUseCase(repository: RemoteMainViewRepository())))
    }
}


// MARK: Sergio - Mover esto a otro lado
extension MainView {
    public static func build() -> Self {
        let getUseCase = GetMainScreenUseCase(repository: RemoteMainViewRepository())
        let viewmodel = MainViewModel(useCase: getUseCase)
        let view = MainView(viewModel: viewmodel)
        return view
    }
}
