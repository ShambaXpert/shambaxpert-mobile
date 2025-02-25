import 'dart:typed_data';

import 'package:equatable/equatable.dart';

class ImageDiagnosisRequestEntity extends Equatable {
  final Uint8List image;

  const ImageDiagnosisRequestEntity({required this.image});

  @override
  List<Object?> get props => [image];
}
