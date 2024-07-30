// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cliente.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ClienteAdapter extends TypeAdapter<Cliente> {
  @override
  final int typeId = 0;

  @override
  Cliente read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Cliente()
      ..razonSocial = fields[0] as String
      ..cuitCuil = fields[1] as String
      ..direccion = fields[2] as String
      ..localidad = fields[3] as String
      ..horarioEntrega = fields[4] as String
      ..isSelected = fields[5] as bool;
  }

  @override
  void write(BinaryWriter writer, Cliente obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.razonSocial)
      ..writeByte(1)
      ..write(obj.cuitCuil)
      ..writeByte(2)
      ..write(obj.direccion)
      ..writeByte(3)
      ..write(obj.localidad)
      ..writeByte(4)
      ..write(obj.horarioEntrega)
      ..writeByte(5)
      ..write(obj.isSelected);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ClienteAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
