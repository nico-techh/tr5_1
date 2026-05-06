import '../models/air_reading.dart';
import '../models/city.dart';
import 'air_api.dart';

class CityAirData {
  final City city;
  final AirReading reading;

  CityAirData({
    required this.city,
    required this.reading,
  });
}

class AirRepository {
  final AirApi api;

  AirRepository({required this.api});

  Future<CityAirData> getCityAirData(String cityName) async {
    final cityJson = await api.searchCity(cityName);
    final city = City.fromJson(cityJson);

    final airJson = await api.getAirQuality(
      latitude: city.latitude,
      longitude: city.longitude,
    );

    final reading = AirReading.fromJson(airJson);

    return CityAirData(
      city: city,
      reading: reading,
    );
  }

  Future<List<CityAirData>> getGalicianCitiesAirData() async {
    final cityNames = [
      'A Coruña',
      'Santiago de Compostela',
      'Vigo',
      'Ourense',
      'Lugo',
      'Ferrol',
      'Pontevedra',
    ];

    final List<CityAirData> result = [];

    for (final cityName in cityNames) {
      final cityData = await getCityAirData(cityName);
      result.add(cityData);
    }

    return result;
  }
}