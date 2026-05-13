import 'package:tr5_1/data/air_api.dart';
import 'package:tr5_1/data/air_repository.dart';
import 'package:tr5_1/models/air_reading.dart';
import 'package:tr5_1/models/city.dart';

class FakeAirApi extends AirApi {}

class FakeAirRepository extends AirRepository {
  FakeAirRepository() : super(api: FakeAirApi());

  @override
  Future<List<CityAirData>> getGalicianCitiesAirData() async {
    return [
      CityAirData(
        city: City(
          name: 'A Coruña',
          country: 'España',
          latitude: 43.3713,
          longitude: -8.396,
        ),
        reading: AirReading(
          time: '2026-05-12T10:00',
          europeanAqi: 35,
          pm10: 10,
          pm25: 5,
          nitrogenDioxide: 20,
          ozone: 60,
          sulphurDioxide: 2,
          carbonMonoxide: 150,
        ),
      ),
      CityAirData(
        city: City(
          name: 'Vigo',
          country: 'España',
          latitude: 42.2406,
          longitude: -8.7207,
        ),
        reading: AirReading(
          time: '2026-05-12T10:00',
          europeanAqi: 85,
          pm10: 20,
          pm25: 12,
          nitrogenDioxide: 30,
          ozone: 75,
          sulphurDioxide: 4,
          carbonMonoxide: 180,
        ),
      ),
    ];
  }
}

class FakeErrorAirRepository extends AirRepository {
  FakeErrorAirRepository() : super(api: FakeAirApi());

  @override
  Future<List<CityAirData>> getGalicianCitiesAirData() async {
    throw Exception('Error de prueba');
  }
}