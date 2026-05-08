import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../data/air_repository.dart';

class AirPieChart extends StatelessWidget {
  final CityAirData cityData;

  const AirPieChart({
    super.key,
    required this.cityData,
  });

  @override
  Widget build(BuildContext context) {
    final reading = cityData.reading;

    final pollutants = [
      _PollutantData(
        name: 'PM10',
        value: reading.pm10,
        color: const Color(0xFF0B6B57),
      ),
      _PollutantData(
        name: 'PM2.5',
        value: reading.pm25,
        color: const Color(0xFF4E8D7C),
      ),
      _PollutantData(
        name: 'NO₂',
        value: reading.nitrogenDioxide,
        color: const Color(0xFFF9A825),
      ),
      _PollutantData(
        name: 'Ozono',
        value: reading.ozone,
        color: const Color(0xFFC62828),
      ),
    ];

    final total = pollutants.fold<double>(
      0,
      (sum, item) => sum + item.value,
    );

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFF4FAF8),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: const Color(0xFFD5E8E2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Composición de contaminantes',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Color(0xFF173B33),
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Permite ver qué contaminante tiene más peso en la ciudad seleccionada.',
            style: TextStyle(
              color: Color(0xFF49645E),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 230,
            child: PieChart(
              PieChartData(
                centerSpaceRadius: 52,
                sectionsSpace: 3,
                sections: pollutants.map((item) {
                  final percentage = total == 0 ? 0 : item.value / total * 100;

                  return PieChartSectionData(
                    value: item.value <= 0 ? 0.1 : item.value,
                    title: '${percentage.toStringAsFixed(0)}%',
                    color: item.color,
                    radius: 70,
                    titleStyle: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: 18),
          Column(
            children: pollutants.map((item) {
              return _LegendRow(
                color: item.color,
                name: item.name,
                value: item.value,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class _PollutantData {
  final String name;
  final double value;
  final Color color;

  const _PollutantData({
    required this.name,
    required this.value,
    required this.color,
  });
}

class _LegendRow extends StatelessWidget {
  final Color color;
  final String name;
  final double value;

  const _LegendRow({
    required this.color,
    required this.name,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Container(
            width: 14,
            height: 14,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(99),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              name,
              style: const TextStyle(
                color: Color(0xFF173B33),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Text(
            '${value.toStringAsFixed(1)} µg/m³',
            style: const TextStyle(
              color: Color(0xFF49645E),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}