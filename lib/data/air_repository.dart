import '../models/air_reading.dart';
import '../models/city.dart';
import 'air_api.dart';
/// Agrupa una ciudad con su lectura actual de calidad del aire.
///
/// La interfaz trabaja con esta clase para tener juntos los datos estáticos
/// de la ciudad y los datos dinámicos devueltos por la API.
class CityAirData {
  /// Ciudad consultada.
  final City city;

  /// Lectura actual de calidad del aire de la ciudad.
  final AirReading reading;
/// Repositorio principal de datos de calidad del aire.
///
/// Combina la búsqueda de coordenadas mediante [AirApi] con la consulta
/// posterior de calidad del aire. Devuelve objetos tipados listos para
/// que los consuma el ViewModel.
  CityAirData({
    required this.city,
    required this.reading,
  });
}

class AirRepository {
    /// API remota usada para consultar Open-Meteo.
  final AirApi api;

  AirRepository({required this.api});

  /// Obtiene los datos completos de una ciudad.
  ///
  /// Primero busca la ciudad por nombre, después usa sus coordenadas para
  /// consultar la calidad del aire y finalmente devuelve un [CityAirData].

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
 /// Obtiene la calidad del aire de varias ciudades gallegas.
  ///
  /// Esta lista se usa para la pantalla principal y para la gráfica comparativa
  /// de AQI europeo.
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