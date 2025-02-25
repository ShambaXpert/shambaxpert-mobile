import 'package:agro_scan/core/error/failure.dart';
import 'package:agro_scan/features/image-analysis/domain/entities/image_diagnosis_request.dart';
import 'package:agro_scan/features/image-analysis/domain/entities/image_diagnosis_response.dart';
import 'package:agro_scan/features/image-analysis/domain/repositories/image_diagnosis_repository.dart';
import 'package:dartz/dartz.dart';

class ImageDiagnosisUsecase {
  final ImageDiagnosisRepository repository;
  ImageDiagnosisUsecase({required this.repository});

  Future<Either<Failure, ImageDiagnosisResponseEntity>> call(
    ImageDiagnosisRequestEntity request,
  ) {
    return repository.getDiagnosis(request);
  }
}
