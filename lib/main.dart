import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/clients_provider.dart';
import 'screens/clients_list_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ClientsProvider(),
      child: MaterialApp(
        title: 'Gestión de Clientes',
        theme: ThemeData(
          primarySwatch: Colors.blueGrey,
        ),
        home: ClientsListScreen(),
      ),
    );
  }
}
