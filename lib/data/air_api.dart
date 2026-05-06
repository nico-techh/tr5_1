import 'dart:convert';

import 'package:http/http.dart' as http;

class AirApi {
  static const String _geocodingBaseUrl =
      'https://geocoding-api.open-meteo.com/v1/search';

  static const String _airQualityBaseUrl =
      'https://air-quality-api.open-meteo.com/v1/air-quality';

  Future<Map<String, dynamic>> searchCity(String cityName) async {
    final uri = Uri.parse(_geocodingBaseUrl).replace(
      queryParameters: {
        'name': cityName,
        'count': '1',
        'language': 'es',
        'format': 'json',
      },
    );

    final response = await http.get(uri).timeout(
      const Duration(seconds: 10),
    );

    if (response.statusCode != 200) {
      throw Exception('Error al buscar la ciudad');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final results = data['results'] as List<dynamic>?;

    if (results == null || results.isEmpty) {
      throw Exception('No se encontró la ciudad $cityName');
    }

    return results.first as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getAirQuality({
    required double latitude,
    required double longitude,
  }) async {
    final uri = Uri.parse(_airQualityBaseUrl).replace(
      queryParameters: {
        'latitude': latitude.toString(),
        'longitude': longitude.toString(),
        'current':
            'european_aqi,pm10,pm2_5,nitrogen_dioxide,ozone,sulphur_dioxide,carbon_monoxide',
        'timezone': 'Europe/Madrid',
      },
    );

    final response = await http.get(uri).timeout(
      const Duration(seconds: 10),
    );

    if (response.statusCode != 200) {
      throw Exception('Error al obtener la calidad del aire');
    }

    return jsonDecode(response.body) as Map<String, dynamic>;
  }
}