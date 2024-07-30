import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'cliente.dart';
import 'cliente_form.dart';
import 'rotulos_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appDocumentDir = await path_provider.getApplicationDocumentsDirectory();
  Hive.init(appDocumentDir.path);
  Hive.registerAdapter(ClienteAdapter());
  await Hive.openBox<Cliente>('clientes');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestión de Clientes',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Box<Cliente> clientesBox;

  @override
  void initState() {
    super.initState();
    clientesBox = Hive.box<Cliente>('clientes');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gestión de Clientes'),
        actions: [
          IconButton(
            icon: Icon(Icons.print),
            onPressed: _generarRotulos,
          ),
        ],
      ),
      body: ValueListenableBuilder(
        valueListenable: clientesBox.listenable(),
        builder: (context, Box<Cliente> box, _) {
          if (box.values.isEmpty) {
            return Center(child: Text('No hay clientes registrados'));
          }
          return ListView.builder(
            itemCount: box.values.length,
            itemBuilder: (context, index) {
              final cliente = box.getAt(index);
              return CheckboxListTile(
                title: Text(cliente!.razonSocial),
                subtitle: Text(cliente.cuitCuil),
                value: cliente.isSelected,
                onChanged: (bool? value) {
                  setState(() {
                    cliente.isSelected = value!;
                    cliente.save();
                  });
                },
                secondary: IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () => _editarCliente(cliente),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: _agregarCliente,
      ),
    );
  }

  void _agregarCliente() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => ClienteForm()),
    );
  }

  void _editarCliente(Cliente cliente) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => ClienteForm(cliente: cliente)),
    );
  }

  void _generarRotulos() {
    final clientesSeleccionados = clientesBox.values.where((cliente) => cliente.isSelected).toList();
    if (clientesSeleccionados.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor, seleccione al menos un cliente')),
      );
    } else {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => RotulosScreen(clientes: clientesSeleccionados)),
      );
    }
  }
}