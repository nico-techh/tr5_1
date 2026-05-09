import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../data/air_repository.dart';


/// Gráfica de barras que compara el AQI europeo entre ciudades.
///
/// Utiliza datos reales agrupados en [CityAirData]. La gráfica ayuda a decidir
/// qué ciudad tiene mejor calidad del aire, ya que un AQI menor indica mejores
/// condiciones.
class AirBarChart extends StatelessWidget {

    /// Lista de ciudades con sus lecturas actuales.
  final List<CityAirData> citiesData;

  const AirBarChart({
    super.key,
    required this.citiesData,
  });

  Color _getAqiColor(double aqi) {
    if (aqi <= 40) {
      return const Color(0xFF2E7D32);
    }

    if (aqi <= 80) {
      return const Color(0xFFF9A825);
    }

    return const Color(0xFFC62828);
  }

  @override
  Widget build(BuildContext context) {
    if (citiesData.isEmpty) {
      return const SizedBox.shrink();
    }

    final maxAqi = citiesData
        .map((item) => item.reading.europeanAqi)
        .reduce((a, b) => a > b ? a : b);

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
            'Comparativa entre ciudades',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Color(0xFF173B33),
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'El AQI más bajo indica mejor calidad del aire para entrenar.',
            style: TextStyle(
              color: Color(0xFF49645E),
            ),
          ),
          const SizedBox(height: 22),
          SizedBox(
            height: 280,
            child: BarChart(
              BarChartData(
                maxY: maxAqi < 100 ? 100 : maxAqi + 20,
                alignment: BarChartAlignment.spaceAround,
                barGroups: List.generate(
                  citiesData.length,
                  (index) {
                    final cityData = citiesData[index];
                    final aqi = cityData.reading.europeanAqi;

                    return BarChartGroupData(
                      x: index,
                      barRods: [
                        BarChartRodData(
                          toY: aqi,
                          width: 18,
                          color: _getAqiColor(aqi),
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ],
                      showingTooltipIndicators: [0],
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  leftTitles: const AxisTitles(
                    axisNameWidget: Text('AQI'),
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 38,
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 44,
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();

                        if (index < 0 || index >= citiesData.length) {
                          return const SizedBox.shrink();
                        }

                        final name = citiesData[index].city.name;

                        return Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            _shortCityName(name),
                            style: const TextStyle(
                              fontSize: 11,
                              color: Color(0xFF173B33),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                gridData: const FlGridData(show: true),
                borderData: FlBorderData(show: false),
                barTouchData: BarTouchData(
                  enabled: true,
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipColor: (_) => const Color(0xFF173B33),
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      final cityData = citiesData[group.x.toInt()];
                      return BarTooltipItem(
                        '${cityData.city.name}\nAQI: ${rod.toY.toStringAsFixed(0)}',
                        const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          const Wrap(
            spacing: 14,
            runSpacing: 8,
            children: [
              _LegendItem(color: Color(0xFF2E7D32), text: 'Bueno'),
              _LegendItem(color: Color(0xFFF9A825), text: 'Moderado'),
              _LegendItem(color: Color(0xFFC62828), text: 'Malo'),
            ],
          ),
        ],
      ),
    );
  }

  static String _shortCityName(String name) {
    if (name == 'Santiago de Compostela') {
      return 'Sant.';
    }

    if (name.length <= 5) {
      return name;
    }

    return name.substring(0, 5);
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String text;

  const _LegendItem({
    required this.color,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(99),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          text,
          style: const TextStyle(
            color: Color(0xFF173B33),
          ),
        ),
      ],
    );
  }
}