import 'package:flutter/material.dart';

import '../data/air_repository.dart';

/// ViewModel principal de la aplicación.
///
/// Gestiona el estado de carga, errores, ciudad seleccionada, ciudad favorita
/// y la lógica de recomendación deportiva. Las vistas observan esta clase
/// mediante `provider`.
///
/// Utiliza [AirRepository] para obtener los datos de calidad del aire.

class AirVm extends ChangeNotifier {
  /// Repositorio usado para consultar los datos de Open-Meteo.
  final AirRepository repository;

  AirVm({required this.repository});

  /// Indica si la aplicación está cargando datos.
  bool isLoading = false;

  /// Mensaje de error mostrado en la interfaz cuando falla la carga.
  String? errorMessage;

  /// Lista de ciudades con sus datos actuales de calidad del aire.
  List<CityAirData> citiesData = [];

  /// Ciudad seleccionada actualmente para mostrar su detalle.
  CityAirData? selectedCityData;

  /// Nombre de la ciudad marcada como favorita.
  String favoriteCityName = 'A Coruña';

  /// Carga los datos de las ciudades gallegas desde el repositorio.
  ///
  /// Actualiza los estados de carga, error y datos. Al finalizar, selecciona
  /// la ciudad favorita o la primera ciudad disponible.
  Future<void> loadData() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      citiesData = await repository.getGalicianCitiesAirData();
      selectedCityData = citiesData.firstWhere(
        (item) =>
            item.city.name.toLowerCase() == favoriteCityName.toLowerCase(),
        orElse: () => citiesData.first,
      );
    } catch (e) {
      errorMessage = 'No se pudieron cargar los datos de calidad del aire.';
    }

    isLoading = false;
    notifyListeners();
  }

  /// Selecciona una ciudad para mostrarla en la pantalla de detalle.
  void selectCity(CityAirData cityData) {
    selectedCityData = cityData;
    notifyListeners();
  }

  /// Cambia la ciudad favorita y la selecciona como ciudad actual.
  void setFavoriteCity(CityAirData cityData) {
    favoriteCityName = cityData.city.name;
    selectedCityData = cityData;
    notifyListeners();
  }

  /// Devuelve el veredicto deportivo en función del AQI europeo.
  ///
  /// La lógica se basa en tres tramos: bueno, moderado y desfavorable.
  String getSportVerdict(double europeanAqi) {
    if (europeanAqi <= 40) {
      return 'Sí, adelante';
    }

    if (europeanAqi <= 80) {
      return 'Con moderación';
    }

    return 'Mejor hoy no';
  }

  /// Devuelve una explicación textual del veredicto deportivo.
  String getSportExplanation(double europeanAqi) {
    if (europeanAqi <= 40) {
      return 'El índice europeo de calidad del aire es bajo, por lo que las condiciones son buenas para hacer deporte al aire libre.';
    }

    if (europeanAqi <= 80) {
      return 'El aire es aceptable, pero conviene moderar la intensidad del entrenamiento.';
    }

    return 'El índice de calidad del aire es alto. Es mejor evitar esfuerzos intensos al aire libre.';
  }
}
