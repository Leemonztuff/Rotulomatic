import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'cliente.dart';

class ClienteForm extends StatefulWidget {
  final Cliente? cliente;

  const ClienteForm({Key? key, this.cliente}) : super(key: key);

  @override
  _ClienteFormState createState() => _ClienteFormState();
}

class _ClienteFormState extends State<ClienteForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _razonSocialController;
  late TextEditingController _cuitCuilController;
  late TextEditingController _direccionController;
  late TextEditingController _localidadController;

  List<bool> _diasSeleccionados = List.generate(5, (_) => false);
  TimeOfDay _horaInicio = const TimeOfDay(hour: 9, minute: 0);
  TimeOfDay _horaFin = const TimeOfDay(hour: 17, minute: 0);

  @override
  void initState() {
    super.initState();
    _razonSocialController = TextEditingController(text: widget.cliente?.razonSocial ?? '');
    _cuitCuilController = TextEditingController(text: widget.cliente?.cuitCuil ?? '');
    _direccionController = TextEditingController(text: widget.cliente?.direccion ?? '');
    _localidadController = TextEditingController(text: widget.cliente?.localidad ?? '');

    if (widget.cliente != null) {
      _parseHorarioEntrega(widget.cliente!.horarioEntrega);
    }
  }

  void _parseHorarioEntrega(String horarioEntrega) {
    List<String> partes = horarioEntrega.split(' ');
    List<String> dias = partes[0].split(', ');
    _diasSeleccionados = ['Lun', 'mar', 'mié', 'Jue', 'Vie'].map((dia) => dias.contains(dia)).toList();
    
    List<String> horas = partes[1].split('-');
    _horaInicio = TimeOfDay(
      hour: int.parse(horas[0].split(':')[0]),
      minute: int.parse(horas[0].split(':')[1])
    );
    _horaFin = TimeOfDay(
      hour: int.parse(horas[1].split(':')[0]),
      minute: int.parse(horas[1].split(':')[1])
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.cliente == null ? 'Agregar Cliente' : 'Editar Cliente'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                controller: _razonSocialController,
                decoration: InputDecoration(labelText: 'Razón Social'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese la razón social';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _cuitCuilController,
                decoration: InputDecoration(labelText: 'CUIT/CUIL'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese el CUIT/CUIL';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _direccionController,
                decoration: InputDecoration(labelText: 'Dirección'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese la dirección';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _localidadController,
                decoration: InputDecoration(labelText: 'Localidad'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese la localidad';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              Text('Días de entrega:', style: TextStyle(fontWeight: FontWeight.bold)),
              Wrap(
                spacing: 8.0,
                children: [
                  for (int i = 0; i < 5; i++)
                    FilterChip(
                      label: Text(['Lun', 'mar', 'mie', 'Jue', 'Vie'][i]),
                      selected: _diasSeleccionados[i],
                      onSelected: (bool selected) {
                        setState(() {
                          _diasSeleccionados[i] = selected;
                        });
                      },
                    ),
                ],
              ),
              SizedBox(height: 20),
              Text('Rango horario de entrega:', style: TextStyle(fontWeight: FontWeight.bold)),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      child: Text('Inicio: ${_horaInicio.format(context)}'),
                      onPressed: () async {
                        final TimeOfDay? time = await showTimePicker(
                          context: context,
                          initialTime: _horaInicio,
                        );
                        if (time != null) {
                          setState(() {
                            _horaInicio = time;
                          });
                        }
                      },
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      child: Text('Fin: ${_horaFin.format(context)}'),
                      onPressed: () async {
                        final TimeOfDay? time = await showTimePicker(
                          context: context,
                          initialTime: _horaFin,
                        );
                        if (time != null) {
                          setState(() {
                            _horaFin = time;
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Guardar'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final clientesBox = Hive.box<Cliente>('clientes');
      final cliente = widget.cliente ?? Cliente();
      
      cliente.razonSocial = _razonSocialController.text;
      cliente.cuitCuil = _cuitCuilController.text;
      cliente.direccion = _direccionController.text;
      cliente.localidad = _localidadController.text;
      cliente.horarioEntrega = _formatHorarioEntrega();

      if (widget.cliente == null) {
        clientesBox.add(cliente);
      } else {
        cliente.save();
      }

      Navigator.of(context).pop();
    }
  }

  String _formatHorarioEntrega() {
    List<String> dias = ['Lun', 'mar', 'mie', 'Jue', 'Vie'];
    List<String> diasSeleccionados = [];
    for (int i = 0; i < 5; i++) {
      if (_diasSeleccionados[i]) {
        diasSeleccionados.add(dias[i]);
      }
    }
    String horaInicio = '${_horaInicio.hour.toString().padLeft(2, '0')}:${_horaInicio.minute.toString().padLeft(2, '0')}';
    String horaFin = '${_horaFin.hour.toString().padLeft(2, '0')}:${_horaFin.minute.toString().padLeft(2, '0')}';
    return '${diasSeleccionados.join(", ")} $horaInicio-$horaFin';
  }

  @override
  void dispose() {
    _razonSocialController.dispose();
    _cuitCuilController.dispose();
    _direccionController.dispose();
    _localidadController.dispose();
    super.dispose();
  }
}