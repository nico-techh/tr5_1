import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../data/air_repository.dart';
/// Servicio encargado de generar informes PDF.
///
/// Usa el paquete `pdf` para construir un documento con widgets propios del
/// paquete. Recibe un [CityAirData] y lo transforma en un informe imprimible
/// con valores actuales, fechas y recomendación deportiva.
class PdfService {

  /// Genera un informe PDF para una ciudad concreta.
  ///
  /// Incluye cabecera, coordenadas, tabla con parámetros de calidad del aire,
  /// veredicto deportivo, fecha de generación y fuente de datos.
  Future<Uint8List> generateCityReport({
    required CityAirData cityData,
    required String verdict,
    required String explanation,
  }) async {
    final pdf = pw.Document();

    final city = cityData.city;
    final reading = cityData.reading;
    final generatedAt = DateTime.now();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        footer: (context) {
          return pw.Align(
            alignment: pw.Alignment.centerRight,
            child: pw.Text(
              'Datos: Open-Meteo Air Quality API',
              style: const pw.TextStyle(
                fontSize: 10,
                color: PdfColors.grey700,
              ),
            ),
          );
        },
        build: (context) {
          return [
            pw.Text(
              'Informe de calidad del aire',
              style: pw.TextStyle(
                fontSize: 26,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            pw.SizedBox(height: 8),
            pw.Text(
              'AirCheck Galicia',
              style: const pw.TextStyle(
                fontSize: 14,
                color: PdfColors.grey700,
              ),
            ),
            pw.SizedBox(height: 24),

            pw.Container(
              padding: const pw.EdgeInsets.all(14),
              decoration: pw.BoxDecoration(
                color: PdfColors.green50,
                borderRadius: pw.BorderRadius.circular(8),
                border: pw.Border.all(
                  color: PdfColors.green200,
                ),
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    city.name,
                    style: pw.TextStyle(
                      fontSize: 22,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.SizedBox(height: 4),
                  pw.Text('País: ${city.country}'),
                  pw.Text(
                    'Coordenadas: ${city.latitude.toStringAsFixed(4)}, ${city.longitude.toStringAsFixed(4)}',
                  ),
                  pw.Text('Datos actualizados: ${reading.time}'),
                  pw.Text(
                    'Informe generado: ${_formatDateTime(generatedAt)}',
                  ),
                ],
              ),
            ),

            pw.SizedBox(height: 24),

            pw.Text(
              'Valores actuales',
              style: pw.TextStyle(
                fontSize: 18,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            pw.SizedBox(height: 10),

            pw.Table(
              border: pw.TableBorder.all(
                color: PdfColors.grey400,
                width: 0.7,
              ),
              columnWidths: {
                0: const pw.FlexColumnWidth(2),
                1: const pw.FlexColumnWidth(1),
                2: const pw.FlexColumnWidth(1),
              },
              children: [
                _tableHeader(),
                _tableRow(
                  parameter: 'AQI europeo',
                  value: reading.europeanAqi.toStringAsFixed(0),
                  unit: '',
                ),
                _tableRow(
                  parameter: 'PM10',
                  value: reading.pm10.toStringAsFixed(1),
                  unit: 'µg/m³',
                ),
                _tableRow(
                  parameter: 'PM2.5',
                  value: reading.pm25.toStringAsFixed(1),
                  unit: 'µg/m³',
                ),
                _tableRow(
                  parameter: 'Dióxido de nitrógeno NO2',
                  value: reading.nitrogenDioxide.toStringAsFixed(1),
                  unit: 'µg/m³',
                ),
                _tableRow(
                  parameter: 'Ozono O3',
                  value: reading.ozone.toStringAsFixed(1),
                  unit: 'µg/m3',
                ),
                _tableRow(
                  parameter: 'Dióxido de azufre SO2',
                  value: reading.sulphurDioxide.toStringAsFixed(1),
                  unit: 'µg/m3',
                ),
                _tableRow(
                  parameter: 'Monóxido de carbono CO',
                  value: reading.carbonMonoxide.toStringAsFixed(1),
                  unit: 'µg/m3',
                ),
              ],
            ),

            pw.SizedBox(height: 24),

            pw.Container(
              padding: const pw.EdgeInsets.all(14),
              decoration: pw.BoxDecoration(
                color: PdfColors.blue50,
                borderRadius: pw.BorderRadius.circular(8),
                border: pw.Border.all(
                  color: PdfColors.blue200,
                ),
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    '¿Salgo a hacer deporte al aire libre?',
                    style: pw.TextStyle(
                      fontSize: 17,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.SizedBox(height: 8),
                  pw.Text(
                    verdict,
                    style: pw.TextStyle(
                      fontSize: 16,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.SizedBox(height: 6),
                  pw.Text(explanation),
                  pw.SizedBox(height: 8),
                  pw.Text(
                    'Lógica usada: Sí si AQI ≤ 40, con moderación si 40 < AQI ≤ 80, mejor no si AQI > 80.',
                    style: const pw.TextStyle(
                      fontSize: 11,
                      color: PdfColors.grey700,
                    ),
                  ),
                ],
              ),
            ),
          ];
        },
      ),
    );

    return pdf.save();
  }

  pw.TableRow _tableHeader() {
    return pw.TableRow(
      decoration: const pw.BoxDecoration(
        color: PdfColors.grey300,
      ),
      children: [
        _tableCell('Parámetro', isHeader: true),
        _tableCell('Valor', isHeader: true),
        _tableCell('Unidad', isHeader: true),
      ],
    );
  }

  pw.TableRow _tableRow({
    required String parameter,
    required String value,
    required String unit,
  }) {
    return pw.TableRow(
      children: [
        _tableCell(parameter),
        _tableCell(value),
        _tableCell(unit),
      ],
    );
  }

  pw.Widget _tableCell(String text, {bool isHeader = false}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(8),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontSize: 11,
          fontWeight: isHeader ? pw.FontWeight.bold : pw.FontWeight.normal,
        ),
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    final day = dateTime.day.toString().padLeft(2, '0');
    final month = dateTime.month.toString().padLeft(2, '0');
    final year = dateTime.year.toString();
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');

    return '$day/$month/$year $hour:$minute';
  }
}