import 'dart:io';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import '../models/client.dart';

class PdfService {
  Future<String> generateClientLabel(Client client) async {
    final pdf = pw.Document();
    
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('Cliente: ${client.name}', style: const pw.TextStyle(fontSize: 24)),
            pw.Text('Dirección: ${client.address}', style: const pw.TextStyle(fontSize: 18)),
            pw.Text('Horario de Entrega: ${client.deliveryTime}', style: const pw.TextStyle(fontSize: 18)),
            pw.Text('Notas: ${client.notes}', style: const pw.TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );

    return _savePdfFile(pdf, client.id);
  }

  Future<String> _savePdfFile(pw.Document pdf, String clientId) async {
    final output = await getTemporaryDirectory();
    final file = File("${output.path}/label_$clientId.pdf");
    await file.writeAsBytes(await pdf.save());
    return file.path;
  }
}