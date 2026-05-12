import 'package:flutter_test/flutter_test.dart';
import 'package:tr5_1/models/city.dart';

void main() {
  group('City.fromJson', () {
    test('crea una ciudad correctamente con todos los datos', () {
      final json = {
        'name': 'Vigo',
        'country': 'España',
        'latitude': 42.2406,
        'longitude': -8.7207,
      };

      final city = City.fromJson(json);

      expect(city.name, 'Vigo');
      expect(city.country, 'España');
      expect(city.latitude, 42.2406);
      expect(city.longitude, -8.7207);
    });

    test('normaliza La Coruña como A Coruña', () {
      final json = {
        'name': 'La Coruña',
        'country': 'España',
        'latitude': 43.3713,
        'longitude': -8.3960,
      };

      final city = City.fromJson(json);

      expect(city.name, 'A Coruña');
      expect(city.country, 'España');
      expect(city.latitude, 43.3713);
      expect(city.longitude, -8.3960);
    });

    test('usa valores por defecto si faltan datos', () {
      final json = <String, dynamic>{};

      final city = City.fromJson(json);

      expect(city.name, 'Ciudad desconocida');
      expect(city.country, 'País desconocido');
      expect(city.latitude, 0);
      expect(city.longitude, 0);
    });
  });
}