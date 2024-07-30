import 'package:hive/hive.dart';

part 'cliente.g.dart';

@HiveType(typeId: 0)
class Cliente extends HiveObject {
  @HiveField(0)
  late String razonSocial;
  
  @HiveField(1)
  late String cuitCuil;
  
  @HiveField(2)
  late String direccion;
  
  @HiveField(3)
  late String localidad;
  
  @HiveField(4)
  late String horarioEntrega;
  
  @HiveField(5)
  bool isSelected = false;

  List<bool> get diasEntrega {
    List<String> dias = horarioEntrega.split(' ')[0].split(', ');
    return ['Lun', 'mar', 'mié', 'Jue', 'Vie'].map((dia) => dias.contains(dia)).toList();
  }

  String get rangoHorario {
    return horarioEntrega.split(' ').sublist(1).join(' ');
  }
}