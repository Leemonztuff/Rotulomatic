import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/clients_provider.dart';
import '../services/pdf_service.dart';
import 'client_form_screen.dart';
import 'pdf_preview_screen.dart';

class ClientsListScreen extends StatelessWidget {
  const ClientsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final clientsProvider = Provider.of<ClientsProvider>(context);
    final clients = clientsProvider.clients;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Clientes'),
      ),
      body: ListView.builder(
        itemCount: clients.length,
        itemBuilder: (ctx, i) => ListTile(
          title: Text(clients[i].name),
          subtitle: Text(clients[i].address),
          trailing: IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            onPressed: () async {
              final pdfPath = await PdfService().generateClientLabel(clients[i]);
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => PdfPreviewScreen(filePath: pdfPath),
                ),
              );
            },
          ),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ClientFormScreen(client: clients[i]),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const ClientFormScreen(),
            ),
          );
        },
      ),
    );
  }
}
