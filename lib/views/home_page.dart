import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/air_repository.dart';
import '../viewmodels/air_vm.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final airVm = context.watch<AirVm>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('AirCheck Galicia'),
        actions: [
          IconButton(
            tooltip: 'Recargar datos',
            onPressed: airVm.isLoading ? null : airVm.loadData,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Builder(
        builder: (context) {
          if (airVm.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (airVm.errorMessage != null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  airVm.errorMessage!,
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          if (airVm.citiesData.isEmpty || airVm.selectedCityData == null) {
            return const Center(
              child: Text('No hay datos disponibles.'),
            );
          }

          final favorite = airVm.selectedCityData!;

          return RefreshIndicator(
            onRefresh: airVm.loadData,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _FavoriteCityCard(cityData: favorite),
                const SizedBox(height: 20),
                const Text(
                  'Ciudades consultadas',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                ...airVm.citiesData.map(
                  (cityData) => _CityListTile(cityData: cityData),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _FavoriteCityCard extends StatelessWidget {
  final CityAirData cityData;

  const _FavoriteCityCard({
    required this.cityData,
  });

  @override
  Widget build(BuildContext context) {
    final airVm = context.watch<AirVm>();
    final reading = cityData.reading;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ciudad favorita',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              cityData.city.name,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 12),
            Text('AQI europeo: ${reading.europeanAqi.toStringAsFixed(0)}'),
            Text('PM2.5: ${reading.pm25.toStringAsFixed(1)} µg/m³'),
            Text('Ozono: ${reading.ozone.toStringAsFixed(1)} µg/m³'),
            const SizedBox(height: 12),
            Text('Actualizado: ${reading.time}'),
            const SizedBox(height: 12),
            Text(
              airVm.getSportVerdict(reading.europeanAqi),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CityListTile extends StatelessWidget {
  final CityAirData cityData;

  const _CityListTile({
    required this.cityData,
  });

  @override
  Widget build(BuildContext context) {
    final airVm = context.read<AirVm>();
    final reading = cityData.reading;

    return Card(
      child: ListTile(
        title: Text(cityData.city.name),
        subtitle: Text(
          'AQI: ${reading.europeanAqi.toStringAsFixed(0)} · Actualizado: ${reading.time}',
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          airVm.selectCity(cityData);
        },
        onLongPress: () {
          airVm.setFavoriteCity(cityData);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${cityData.city.name} marcada como favorita'),
            ),
          );
        },
      ),
    );
  }
}