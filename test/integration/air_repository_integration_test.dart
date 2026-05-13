import 'package:flutter_test/flutter_test.dart';
import 'package:tr5_1/data/air_api.dart';
import 'package:tr5_1/data/air_repository.dart';

class FakeAirApi extends AirApi {
  @override
  Future<Map<String, dynamic>> searchCity(String cityName) async {
    return {
      'name': cityName,
      'country': 'España',
      'latitude': 43.3713,
      'longitude': -8.396,
    };
  }

  @override
  Future<Map<String, dynamic>> getAirQuality({
    required double latitude,
    required double longitude,
  }) async {
    return {
      'current': {
        'time': '2026-05-12T10:00',
        'european_aqi': 35,
        'pm10': 12.5,
        'pm2_5': 7.3,
        'nitrogen_dioxide': 18.2,
        'ozone': 64.1,
        'sulphur_dioxide': 2.4,
        'carbon_monoxide': 156.0,
      },
    };
  }
}

void main() {
  group('Integración bottom-up AirApi + AirRepository', () {
    test('getCityAirData integra búsqueda de ciudad y calidad del aire', () async {
      final repository = AirRepository(api: FakeAirApi());

      final result = await repository.getCityAirData('A Coruña');

      expect(result.city.name, 'A Coruña');
      expect(result.city.country, 'España');
      expect(result.city.latitude, 43.3713);
      expect(result.city.longitude, -8.396);

      expect(result.reading.time, '2026-05-12T10:00');
      expect(result.reading.europeanAqi, 35);
      expect(result.reading.pm10, 12.5);
      expect(result.reading.pm25, 7.3);
    });

    test('getGalicianCitiesAirData devuelve la lista de ciudades gallegas', () async {
      final repository = AirRepository(api: FakeAirApi());

      final result = await repository.getGalicianCitiesAirData();

      expect(result.length, 7);
      expect(result.first.city.name, 'A Coruña');
      expect(result.any((item) => item.city.name == 'Vigo'), true);
      expect(result.every((item) => item.reading.europeanAqi == 35), true);
    });
  });
}