import 'package:flutter_test/flutter_test.dart';
import 'package:tr5_1/data/air_api.dart';
import 'package:tr5_1/data/air_repository.dart';
import 'package:tr5_1/models/air_reading.dart';
import 'package:tr5_1/models/city.dart';
import 'package:tr5_1/viewmodels/air_vm.dart';

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

void main() {
  group('AirVm', () {
    test('loadData carga ciudades y selecciona la favorita', () async {
      final vm = AirVm(repository: FakeAirRepository());

      await vm.loadData();

      expect(vm.isLoading, false);
      expect(vm.errorMessage, null);
      expect(vm.citiesData.length, 2);
      expect(vm.selectedCityData?.city.name, 'A Coruña');
    });

    test('loadData guarda mensaje de error si falla el repositorio', () async {
      final vm = AirVm(repository: FakeErrorAirRepository());

      await vm.loadData();

      expect(vm.isLoading, false);
      expect(vm.citiesData, isEmpty);
      expect(
        vm.errorMessage,
        'No se pudieron cargar los datos de calidad del aire.',
      );
    });

    test('getSportVerdict devuelve textos según el AQI', () {
      final vm = AirVm(repository: FakeAirRepository());

      expect(vm.getSportVerdict(20), 'Sí, adelante');
      expect(vm.getSportVerdict(60), 'Con moderación');
      expect(vm.getSportVerdict(100), 'Mejor hoy no');
    });

    test('setFavoriteCity cambia la ciudad favorita y la seleccionada', () async {
      final vm = AirVm(repository: FakeAirRepository());

      await vm.loadData();

      final vigo = vm.citiesData[1];
      vm.setFavoriteCity(vigo);

      expect(vm.favoriteCityName, 'Vigo');
      expect(vm.selectedCityData?.city.name, 'Vigo');
    });
  });
}