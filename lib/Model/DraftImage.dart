/* CODE TO GENERATE ADAPTER CODE
c */

import 'dart:typed_data';
import 'package:hive/hive.dart';

part 'DraftImage.g.dart';

@HiveType(typeId: 1)
class DraftImage {
  @HiveField(0)
  String? fileName;

  @HiveField(1)
  Uint8List? image;

  DraftImage(this.fileName, this.image);
}
