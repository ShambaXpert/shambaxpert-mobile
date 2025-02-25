import 'dart:io';
import 'package:agro_scan/core/error/exception.dart';
import 'package:agro_scan/core/error/failure.dart';
import 'package:agro_scan/features/image-analysis/data/data-sources/remote_data_source.dart';
import 'package:agro_scan/features/image-analysis/data/models/image_diagnosis_request_model.dart';
import 'package:agro_scan/features/image-analysis/domain/entities/image_diagnosis_request.dart';
import 'package:agro_scan/features/image-analysis/domain/entities/image_diagnosis_response.dart';
import 'package:agro_scan/features/image-analysis/domain/repositories/image_diagnosis_repository.dart';
import 'package:dartz/dartz.dart';

class ImageDiagnosisRepositoryIpml extends ImageDiagnosisRepository {
  final ImageDiagnosisRemoteDataSource imageDiagnosisRemoteDataSource;
  ImageDiagnosisRepositoryIpml({required this.imageDiagnosisRemoteDataSource});

  @override
  Future<Either<Failure, ImageDiagnosisResponseEntity>> getDiagnosis(
    ImageDiagnosisRequestEntity request,
  ) async {
    try {
      final result = await imageDiagnosisRemoteDataSource.getImageDiagnosis(
        ImageDiagnosisRequestModel.fromEntity(request),
      );
      return Right(result.toEntity());
    } on ServerException {
      return Left(ServerFailure("A sever-side error occured"));
    } on SocketException {
      return Left(
        ConnectionFailure("Check your internet connection and try again"),
      );
    }
  }
}
