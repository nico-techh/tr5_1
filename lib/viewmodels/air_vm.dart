import 'package:flutter/material.dart';

import '../data/air_repository.dart';

class AirVm extends ChangeNotifier {
  final AirRepository repository;

  AirVm({required this.repository});

  bool isLoading = false;
  String? errorMessage;
  List<CityAirData> citiesData = [];
  CityAirData? selectedCityData;
  String favoriteCityName = 'A Coruña';

  Future<void> loadData() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      citiesData = await repository.getGalicianCitiesAirData();
      selectedCityData = citiesData.firstWhere(
        (item) => item.city.name.toLowerCase() == favoriteCityName.toLowerCase(),
        orElse: () => citiesData.first,
      );
    } catch (e) {
      errorMessage = 'No se pudieron cargar los datos de calidad del aire.';
    }

    isLoading = false;
    notifyListeners();
  }

  void selectCity(CityAirData cityData) {
    selectedCityData = cityData;
    notifyListeners();
  }

  void setFavoriteCity(CityAirData cityData) {
    favoriteCityName = cityData.city.name;
    selectedCityData = cityData;
    notifyListeners();
  }

  String getSportVerdict(double europeanAqi) {
    if (europeanAqi <= 40) {
      return 'Sí, adelante';
    }

    if (europeanAqi <= 80) {
      return 'Con moderación';
    }

    return 'Mejor hoy no';
  }

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