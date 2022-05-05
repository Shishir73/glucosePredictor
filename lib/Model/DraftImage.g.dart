// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'DraftImage.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DraftImageAdapter extends TypeAdapter<DraftImage> {
  @override
  final int typeId = 1;

  @override
  DraftImage read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DraftImage(
      fields[0] as String?,
      fields[1] as Uint8List?,
    );
  }

  @override
  void write(BinaryWriter writer, DraftImage obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.fileName)
      ..writeByte(1)
      ..write(obj.image);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DraftImageAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
