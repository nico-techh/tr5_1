/// Representa una lectura actual de calidad del aire.
///
/// Contiene el índice europeo AQI y los principales contaminantes que la app
/// muestra en la pantalla de detalle y en el informe PDF.
class AirReading {
  /// Hora de actualización de los datos devuelta por la API.
  final String time;

  /// Índice europeo de calidad del aire.
  final double europeanAqi;

  /// Partículas PM10 en microgramos por metro cúbico.
  final double pm10;

  /// Partículas PM2.5 en microgramos por metro cúbico.
  final double pm25;

  /// Dióxido de nitrógeno.
  final double nitrogenDioxide;

  /// Ozono troposférico.
  final double ozone;

  /// Dióxido de azufre.
  final double sulphurDioxide;

  /// Monóxido de carbono.
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

  /// Crea una instancia de [AirReading] a partir del JSON de Air Quality API.
  ///
  /// La API agrupa los valores actuales dentro del objeto `current`.
  factory AirReading.fromJson(Map<String, dynamic> json) {
    final current = json['current'] as Map<String, dynamic>? ?? {};

    return AirReading(
      time: current['time']?.toString() ?? 'Sin fecha',
      europeanAqi: (current['european_aqi'] as num?)?.toDouble() ?? 0,
      pm10: (current['pm10'] as num?)?.toDouble() ?? 0,
      pm25: (current['pm2_5'] as num?)?.toDouble() ?? 0,
      nitrogenDioxide: (current['nitrogen_dioxide'] as num?)?.toDouble() ?? 0,
      ozone: (current['ozone'] as num?)?.toDouble() ?? 0,
      sulphurDioxide: (current['sulphur_dioxide'] as num?)?.toDouble() ?? 0,
      carbonMonoxide: (current['carbon_monoxide'] as num?)?.toDouble() ?? 0,
    );
  }
}
