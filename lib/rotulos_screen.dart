import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:flutter/services.dart';
import 'cliente.dart'; // Importa la clase Cliente

class RotulosScreen extends StatelessWidget {
  final List<Cliente> clientes;

  const RotulosScreen({Key? key, required this.clientes}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Generar Rótulos'),
        elevation: 8,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Rótulos seleccionados: ${clientes.length}',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 33),
            ElevatedButton.icon(
              icon: const Icon(Icons.print),
              label: const Text('Imprimir Rótulos'),
              onPressed: () => _imprimirRotulos(context),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                textStyle: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _imprimirRotulos(BuildContext context) async {
    final pdf = pw.Document();

    try {
      final image = pw.MemoryImage(
        (await rootBundle.load('assets/logo.png')).buffer.asUint8List(),
      );

      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          build: (context) {
            List<pw.Widget> rotulos = [];
            for (var cliente in clientes) {
              rotulos.add(
                pw.Container(
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(),
                  ),
                  padding: const pw.EdgeInsets.all(10),
                  margin: const pw.EdgeInsets.only(bottom: 5),
                  width: double.infinity,
                  child: pw.Row(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Column(
                        mainAxisAlignment: pw.MainAxisAlignment.center,
                        children: [
                          pw.Image(image, width: 120, height: 120), // Adjust the size of your logo here
                        ],
                      ),
                      pw.SizedBox(width: 15),
                      pw.Expanded(
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text(cliente.razonSocial, style: pw.TextStyle(fontSize: 19, fontWeight: pw.FontWeight.bold)),
                            pw.SizedBox(height: 5),
                            pw.Text(cliente.cuitCuil, style: const pw.TextStyle(fontSize: 17)),
                            pw.Text(cliente.direccion, style: pw.TextStyle(fontSize: 19, fontWeight: pw.FontWeight.bold)),
                            pw.Text(cliente.localidad, style: const pw.TextStyle(fontSize: 17)),
                            pw.SizedBox(height: 6),
                            pw.Text('Horario de entrega:', style: pw.TextStyle(fontSize: 17, fontWeight: pw.FontWeight.bold)),
                            pw.Wrap(
                              spacing: 4.0,
                              alignment: pw.WrapAlignment.start,
                              children: [
                                for (var i = 0; i < cliente.diasEntrega.length; i++)
                                  if (cliente.diasEntrega[i])
                                    pw.Container(
                                      padding: const pw.EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                                      margin: const pw.EdgeInsets.only(right: 4.0, bottom: 4.0),
                                      decoration: pw.BoxDecoration(
                                        color: PdfColors.lightGreenAccent,
                                        borderRadius: pw.BorderRadius.circular(4.0),
                                      ),
                                      child: pw.Text(['Lun', 'mar', 'mie', 'Jue', 'Vie'][i], style: const pw.TextStyle(fontSize: 15, color: PdfColors.white)),
                                    ),
                              ],
                            ),
                            pw.Text('Rango: ${cliente.rangoHorario}', style: const pw.TextStyle(fontSize: 17)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            List<pw.Widget> pages = [];
            for (int i = 0; i < rotulos.length; i += 5) {
              pages.add(pw.Column(children: rotulos.skip(i).take(5).toList()));
            }

            return pages;
          },
        ),
      );

      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdf.save(),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al generar el PDF: $e')),
      );
    }
  }
}
