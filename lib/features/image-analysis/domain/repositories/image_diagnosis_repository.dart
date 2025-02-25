import 'package:agro_scan/core/error/failure.dart';
import 'package:agro_scan/features/image-analysis/domain/entities/image_diagnosis_request.dart';
import 'package:agro_scan/features/image-analysis/domain/entities/image_diagnosis_response.dart';
import 'package:dartz/dartz.dart';

abstract class ImageDiagnosisRepository {
  Future<Either<Failure,ImageDiagnosisResponseEntity>> getDiagnosis(ImageDiagnosisRequestEntity request);
}