import 'dart:convert';

import 'package:agro_scan/features/image-analysis/domain/entities/image_diagnosis_request.dart';

class ImageDiagnosisRequestModel extends ImageDiagnosisRequestEntity {
  const ImageDiagnosisRequestModel({required super.image});

  Map<String, dynamic> toJson() {
    return {"image": base64Encode(image)};
  }

  ImageDiagnosisRequestEntity toEntity() {
    return ImageDiagnosisRequestEntity(image: image);
  }

  factory ImageDiagnosisRequestModel.fromEntity(
    ImageDiagnosisRequestEntity entity,
  ) {
    return ImageDiagnosisRequestModel(image: entity.image);
  }
}
