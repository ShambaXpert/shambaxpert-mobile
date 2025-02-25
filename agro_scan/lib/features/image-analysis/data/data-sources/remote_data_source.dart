import 'dart:convert';

import 'package:agro_scan/core/constants/urls.dart';
import 'package:agro_scan/core/error/exception.dart';
import 'package:agro_scan/features/image-analysis/data/models/image_diagnosis_request_model.dart';
import 'package:agro_scan/features/image-analysis/data/models/image_diagnosis_response_model.dart';
import 'package:http/http.dart' as http;

abstract class ImageDiagnosisRemoteDataSource {
  Future<ImageDiagnosisResponseModel> getImageDiagnosis(
    ImageDiagnosisRequestModel request,
  );
}

class ImageDiagnosisRemoteDataSourceImpl
    implements ImageDiagnosisRemoteDataSource {
  final http.Client httpClient;

  ImageDiagnosisRemoteDataSourceImpl({required this.httpClient});
  @override
  Future<ImageDiagnosisResponseModel> getImageDiagnosis(
    ImageDiagnosisRequestModel request,
  ) async {
    final response = await httpClient.post(
      Uri.parse(Urls.diagnosisEndpoint),
      body: request,
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return ImageDiagnosisResponseModel.fromJson(json);
    } else {
      throw ServerException();
    }
  }
}
