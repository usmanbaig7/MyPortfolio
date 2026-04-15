// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProjectModelAdapter extends TypeAdapter<ProjectModel> {
  @override
  final int typeId = 0;

  @override
  ProjectModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProjectModel(
      id: fields[0] as String,
      title: fields[1] as String,
      shortDescription: fields[2] as String,
      fullDescription: fields[3] as String,
      techStack: (fields[4] as List).cast<String>(),
      imageUrl: fields[5] as String,
      liveUrl: fields[6] as String,
      githubUrl: fields[7] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ProjectModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.shortDescription)
      ..writeByte(3)
      ..write(obj.fullDescription)
      ..writeByte(4)
      ..write(obj.techStack)
      ..writeByte(5)
      ..write(obj.imageUrl)
      ..writeByte(6)
      ..write(obj.liveUrl)
      ..writeByte(7)
      ..write(obj.githubUrl);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProjectModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
