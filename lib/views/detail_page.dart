import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodels/air_vm.dart';

import '../widgets/air_pie_chart.dart';

import 'package:printing/printing.dart';

import '../services/pdf_service.dart';

class DetailPage extends StatelessWidget {
  const DetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final airVm = context.watch<AirVm>();
    final cityData = airVm.selectedCityData;

    if (cityData == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Detalle')),
        body: const Center(child: Text('No hay ciudad seleccionada.')),
      );
    }

    final city = cityData.city;
    final reading = cityData.reading;
    final verdict = airVm.getSportVerdict(reading.europeanAqi);
    final explanation = airVm.getSportExplanation(reading.europeanAqi);

    return Scaffold(
      appBar: AppBar(
        title: Text(city.name),
        actions: [
          IconButton(
            tooltip: 'Marcar como favorita',
            onPressed: () {
              airVm.setFavoriteCity(cityData);

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${city.name} marcada como favorita')),
              );
            },
            icon: const Icon(Icons.star_border),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _CityHeaderCard(
            cityName: city.name,
            country: city.country,
            latitude: city.latitude,
            longitude: city.longitude,
            updatedAt: reading.time,
          ),
          const SizedBox(height: 16),
          _SportCard(verdict: verdict, explanation: explanation),
          const SizedBox(height: 16),
          AirPieChart(cityData: cityData),
          const SizedBox(height: 16),
          _ValuesCard(reading: reading),
          const SizedBox(height: 16),
          Tooltip(
  message: 'Generar informe PDF de la ciudad',
  child: FilledButton.icon(
    onPressed: () async {
      final pdfService = PdfService();

      await Printing.layoutPdf(
        name: 'informe_${city.name.toLowerCase().replaceAll(' ', '_')}.pdf',
        onLayout: (_) {
          return pdfService.generateCityReport(
            cityData: cityData,
            verdict: verdict,
            explanation: explanation,
          );
        },
      );

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Informe PDF generado correctamente'),
          ),
        );
      }
    },
    icon: const Icon(Icons.picture_as_pdf),
    label: const Text('Generar informe PDF'),
  ),
),
        ],
      ),
    );
  }
}

class _CityHeaderCard extends StatelessWidget {
  final String cityName;
  final String country;
  final double latitude;
  final double longitude;
  final String updatedAt;

  const _CityHeaderCard({
    required this.cityName,
    required this.country,
    required this.latitude,
    required this.longitude,
    required this.updatedAt,
  });

  @override
  Widget build(BuildContext context) {
    return _AirCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            cityName,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w900,
              color: Color(0xFF173B33),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            country,
            style: const TextStyle(fontSize: 16, color: Color(0xFF49645E)),
          ),
          const SizedBox(height: 14),
          Text(
            'Coordenadas: ${latitude.toStringAsFixed(4)}, ${longitude.toStringAsFixed(4)}',
          ),
          Text('Datos actualizados: $updatedAt'),
        ],
      ),
    );
  }
}

class _SportCard extends StatelessWidget {
  final String verdict;
  final String explanation;

  const _SportCard({required this.verdict, required this.explanation});

  @override
  Widget build(BuildContext context) {
    return _AirCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '¿Salgo a hacer deporte?',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Color(0xFF173B33),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            verdict,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: Color(0xFF0B6B57),
            ),
          ),
          const SizedBox(height: 8),
          Text(explanation, style: const TextStyle(color: Color(0xFF49645E))),
        ],
      ),
    );
  }
}

class _ValuesCard extends StatelessWidget {
  final dynamic reading;

  const _ValuesCard({required this.reading});

  @override
  Widget build(BuildContext context) {
    return _AirCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Valores actuales',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Color(0xFF173B33),
            ),
          ),
          const SizedBox(height: 12),
          _ValueRow(
            label: 'AQI europeo',
            value: reading.europeanAqi.toStringAsFixed(0),
            unit: '',
          ),
          _ValueRow(
            label: 'PM10',
            value: reading.pm10.toStringAsFixed(1),
            unit: 'µg/m³',
          ),
          _ValueRow(
            label: 'PM2.5',
            value: reading.pm25.toStringAsFixed(1),
            unit: 'µg/m³',
          ),
          _ValueRow(
            label: 'NO₂',
            value: reading.nitrogenDioxide.toStringAsFixed(1),
            unit: 'µg/m³',
          ),
          _ValueRow(
            label: 'Ozono',
            value: reading.ozone.toStringAsFixed(1),
            unit: 'µg/m³',
          ),
          _ValueRow(
            label: 'SO₂',
            value: reading.sulphurDioxide.toStringAsFixed(1),
            unit: 'µg/m³',
          ),
          _ValueRow(
            label: 'CO',
            value: reading.carbonMonoxide.toStringAsFixed(1),
            unit: 'µg/m³',
          ),
        ],
      ),
    );
  }
}

class _ValueRow extends StatelessWidget {
  final String label;
  final String value;
  final String unit;

  const _ValueRow({
    required this.label,
    required this.value,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(color: Color(0xFF49645E)),
            ),
          ),
          Text(
            unit.isEmpty ? value : '$value $unit',
            style: const TextStyle(
              fontWeight: FontWeight.w800,
              color: Color(0xFF173B33),
            ),
          ),
        ],
      ),
    );
  }
}

class _AirCard extends StatelessWidget {
  final Widget child;

  const _AirCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFF4FAF8),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFD5E8E2)),
      ),
      child: child,
    );
  }
}
