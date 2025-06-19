# Mobile Challenge Ualá

Este proyecto es una aplicación móvil desarrollada en Swift usando SwiftUI, diseñada para mostrar una lista de ciudades, permitir la búsqueda, marcar favoritos y visualizarlos en un mapa.

## Estructura del Proyecto

El proyecto sigue un enfoque de clean arquitecture, separando las responsabilidades en capas distintas:

* **UI (Interfaz de Usuario)**: Contiene las vistas y los view models responsables de presentar los datos y manejar las interacciones del usuario.
* **Domain**: Define la lógica de negocio principal, incluyendo modelos, casos de uso y protocolos de repositorio.
* **Data**: Maneja la obtención y persistencia de datos, incluyendo DTOs (Objetos de Transferencia de Datos) e implementaciones de repositorio.

### Archivos Clave:

* `MobileChallengeUalaApp.swift`: El punto de entrada de la aplicación.
* `MobileChallengeUala/UI/MainView.swift`: La vista principal de la aplicación, responsable de renderizar la interfaz de usuario e interactuar con el `MainViewModel`.
* `MobileChallengeUala/UI/MainViewModel.swift`: El view model para `MainView`, que maneja la lógica de negocio, la obtención de datos y la gestión del estado.
* `MobileChallengeUala/Data/DTO/MainDTO.swift`: Objetos de Transferencia de Datos para mapear la respuesta de la API a structs Swift Decodable.
* `MobileChallengeUala/Data/Repositories/RemoteMainViewRepository.swift`: Implementa el protocolo `MainViewRepository` para obtener datos de una API remota.
* `MobileChallengeUala/Data/Repositories/LocalMainViewRepository.swift`: Implementa el protocolo `MainViewRepository` para proporcionar datos locales para pruebas o escenarios sin conexión.
* `MobileChallengeUala/Domain/Repositories/MainBFFRepository.swift`: Define el protocolo `MainViewRepository`, abstrayendo las fuentes de datos.
* `MobileChallengeUala/Domain/Models/MainModel.swift`: Define los modelos de dominio utilizados en toda la aplicación.
* `MobileChallengeUala/Domain/UseCases/GetMainScreenBFFUseCase.swift`: Define e implementa el `GetMainScreenUseCaseProtocol` para obtener datos de la pantalla principal, actuando como intermediario entre el ViewModel y el Repositorio.

## Enfoque de Búsqueda y Filtrado

La funcionalidad de búsqueda se implementa dentro del `MainViewModel` utilizando la propiedad `@Published` `searchText`.

* **`searchText`**: Una propiedad `@Published` que contiene el texto actual ingresado por el usuario en la barra de búsqueda.
* **`filteredModels`**: Una propiedad computada que filtra el array `models` basándose en el `searchText`. Si `searchText` está vacío, devuelve todos los modelos; de lo contrario, filtra los modelos cuyo `name` comienza con el `searchText` (sin distinción entre mayúsculas y minúsculas).
* **`loadData()`**: Este método es responsable de obtener los datos iniciales utilizando `GetMainScreenUseCase`. Una vez que los datos se cargan correctamente, actualiza el `state` a `.success` yLleva a cabo las siguientes operaciones en `filteredModels`.
* **Integración de la UI**: La `MainView` observa los cambios en `viewModel.searchText` y `viewModel.filteredModels` para actualizar dinámicamente la lista de ciudades mostrada. El `TextField` en la sección `searchBar` está enlazado a `viewModel.searchText`.

### Mejoras de Búsqueda:

* **Coincidencia de Prefijos**: La implementación actual utiliza `hasPrefix` para filtrar, lo que significa que los resultados solo mostrarán ciudades que *comiencen* con el término de búsqueda. Esto proporciona una experiencia de búsqueda enfocada.
* **Sin Distinción entre Mayúsculas y Minúsculas**: La búsqueda no distingue entre mayúsculas y minúsculas, lo que proporciona una mejor experiencia de usuario.
* **Integración de Favoritos**: Los `filteredModels` también incorporan el estado `isFavorite` de cada ciudad, asegurando que incluso al buscar, el estado de favorito se refleje correctamente.

### Lógica de Favoritos:

* **`UserDefaults`**: Las ciudades favoritas se guardan utilizando `UserDefaults` para asegurar que se conserven entre los lanzamientos de la aplicación.
* **Método `toggleFavorite`**: Este método en `MainViewModel` se encarga de añadir o eliminar ciudades del array `favoriteCities` y luego persiste los cambios.

