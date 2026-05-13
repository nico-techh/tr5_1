import 'package:flutter_test/flutter_test.dart';
import 'package:tr5_1/viewmodels/air_vm.dart';

import '../fakes/fake_air_repository.dart';

void main() {
  group('Integración top-down AirVm + FakeAirRepository', () {
    test('AirVm carga datos usando un repositorio fake', () async {
      final vm = AirVm(repository: FakeAirRepository());

      await vm.loadData();

      expect(vm.errorMessage, null);
      expect(vm.isLoading, false);
      expect(vm.citiesData.length, 2);
      expect(vm.selectedCityData?.city.name, 'A Coruña');
    });

    test('AirVm gestiona error cuando el repositorio falla', () async {
      final vm = AirVm(repository: FakeErrorAirRepository());

      await vm.loadData();

      expect(vm.isLoading, false);
      expect(vm.citiesData, isEmpty);
      expect(
        vm.errorMessage,
        'No se pudieron cargar los datos de calidad del aire.',
      );
    });
  });
}