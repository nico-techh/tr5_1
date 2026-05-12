import 'package:flutter_test/flutter_test.dart';
import 'package:tr5_1/models/air_reading.dart';

void main() {
  group('AirReading.fromJson', () {
    test('crea una lectura correctamente con todos los valores', () {
      final json = {
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

      final reading = AirReading.fromJson(json);

      expect(reading.time, '2026-05-12T10:00');
      expect(reading.europeanAqi, 35);
      expect(reading.pm10, 12.5);
      expect(reading.pm25, 7.3);
      expect(reading.nitrogenDioxide, 18.2);
      expect(reading.ozone, 64.1);
      expect(reading.sulphurDioxide, 2.4);
      expect(reading.carbonMonoxide, 156.0);
    });

    test('usa valores por defecto si falta current', () {
      final json = <String, dynamic>{};

      final reading = AirReading.fromJson(json);

      expect(reading.time, 'Sin fecha');
      expect(reading.europeanAqi, 0);
      expect(reading.pm10, 0);
      expect(reading.pm25, 0);
      expect(reading.nitrogenDioxide, 0);
      expect(reading.ozone, 0);
      expect(reading.sulphurDioxide, 0);
      expect(reading.carbonMonoxide, 0);
    });
  });
}