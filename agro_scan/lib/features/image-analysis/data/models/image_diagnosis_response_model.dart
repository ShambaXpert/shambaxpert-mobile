import 'package:agro_scan/features/image-analysis/domain/entities/image_diagnosis_response.dart';

class ImageDiagnosisResponseModel extends ImageDiagnosisResponseEntity {
  const ImageDiagnosisResponseModel({
    required super.diseaseName,
    required super.diseaseDescription,
    required super.recomendationItems,
  });

  factory ImageDiagnosisResponseModel.fromJson(Map<String, dynamic> json) {
    return ImageDiagnosisResponseModel(
      diseaseName: json["disease_name"] as String,
      diseaseDescription: json["disease_description"] as String,
      recomendationItems: List<String>.from(json["recomendation_items"]),
    );
  }

  ImageDiagnosisResponseEntity toEntity() {
    return ImageDiagnosisResponseEntity(
      diseaseName: diseaseName,
      diseaseDescription: diseaseDescription,
      recomendationItems: recomendationItems,
    );
  }

  factory ImageDiagnosisResponseModel.from(
    ImageDiagnosisResponseEntity entity,
  ) {
    return ImageDiagnosisResponseModel(
      diseaseName: entity.diseaseName,
      diseaseDescription: entity.diseaseDescription,
      recomendationItems: entity.recomendationItems,
    );
  }
}
