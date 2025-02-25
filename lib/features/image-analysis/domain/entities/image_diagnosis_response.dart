import 'package:equatable/equatable.dart';

class ImageDiagnosisResponseEntity extends Equatable {
  final String diseaseName;
  final String diseaseDescription;
  final List<String> recomendationItems;

  const ImageDiagnosisResponseEntity({
    required this.diseaseName,
    required this.diseaseDescription,
    required this.recomendationItems,
  });

  @override
  List<Object?> get props => [
    diseaseName,
    diseaseDescription,
    recomendationItems,
  ];
}
