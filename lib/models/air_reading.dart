class AirReading {
  final String time;
  final double europeanAqi;
  final double pm10;
  final double pm25;
  final double nitrogenDioxide;
  final double ozone;
  final double sulphurDioxide;
  final double carbonMonoxide;

  AirReading({
    required this.time,
    required this.europeanAqi,
    required this.pm10,
    required this.pm25,
    required this.nitrogenDioxide,
    required this.ozone,
    required this.sulphurDioxide,
    required this.carbonMonoxide,
  });

  factory AirReading.fromJson(Map<String, dynamic> json) {
    final current = json['current'] as Map<String, dynamic>? ?? {};

    return AirReading(
      time: current['time']?.toString() ?? 'Sin fecha',
      europeanAqi: (current['european_aqi'] as num?)?.toDouble() ?? 0,
      pm10: (current['pm10'] as num?)?.toDouble() ?? 0,
      pm25: (current['pm2_5'] as num?)?.toDouble() ?? 0,
      nitrogenDioxide:
          (current['nitrogen_dioxide'] as num?)?.toDouble() ?? 0,
      ozone: (current['ozone'] as num?)?.toDouble() ?? 0,
      sulphurDioxide:
          (current['sulphur_dioxide'] as num?)?.toDouble() ?? 0,
      carbonMonoxide:
          (current['carbon_monoxide'] as num?)?.toDouble() ?? 0,
    );
  }
}