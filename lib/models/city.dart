library;
/// Representa una ciudad obtenida desde la API de geocodificación.

class City {
  /// Nombre de la ciudad mostrado en la interfaz.
  final String name;

  ///País al que pertenece la ciudad
  final String country;

  ///Latituud usada para consultar la API de calidad del aire
  final double latitude;

  ///Longitud usada para la API de calidad del aire
  final double longitude;

  City({
    required this.name,
    required this.country,
    required this.latitude,
    required this.longitude,
  });

  /// Crea una instancia de [City] a partir del JSON devuelto por Open-Meteo.
  ///
  /// Se normaliza el nombre de A Coruña porque la API puede devolverlo como
  /// "La Coruña".
  ///
  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      name: _normalizeCityName(
        json['name']?.toString() ?? 'Ciudad desconocida',
      ),
      country: json['country']?.toString() ?? 'País desconocido',
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0,
    );
  }

  static String _normalizeCityName(String name) {
    if (name == 'La Coruña') {
      return 'A Coruña';
    }

    return name;
  }
}
