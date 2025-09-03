import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lasco/core/database/api/api_consumer.dart';

import '../../../../core/constants/widgets/errors/exceptions.dart';
import '../../../../core/database/api/end_points.dart';
import '../../../auth/data/models/sign_up_models.dart';

class ProfileRepo {
  final ApiConsumer api;

  ProfileRepo(this.api);
  //! Logout
  Future<Either<String, ResponseModel>> userLogout() async {
    try {
      final Response response = await api.delete(EndPoints.userLogout);
      return Right(ResponseModel.fromJson(response.data));
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } on NoInternetException catch (e) {
      return Left(e.errorModel.detail);
    } catch (e) {
      return Left(e.toString());
    }
  }

//! delete Account
  Future<Either<String, ResponseModel>> deleteAccount() async {
    try {
      final Response response = await api.get(EndPoints.deleteAccount);
      return Right(ResponseModel.fromJson(response.data));
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } on NoInternetException catch (e) {
      return Left(e.errorModel.detail);
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, ResponseModel>> getUserProfile() async {
    try {
      final response = await api.get(
        EndPoints.getProfile,
      );
      return Right(ResponseModel.fromJson(response.data));
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } on NoInternetException catch (e) {
      return Left(e.errorModel.detail);
    }
  }

  Future<Either<String, String>> updateProfile({
    required String username,
    required String phone,
    required String email,
    XFile? image,
  }) async {
    try {
      Map<String, dynamic> data = {
        "username": username,
        "phone": phone,
        "email": email,
      };

      if (image != null) {
        data['image'] =
            await MultipartFile.fromFile(image.path, filename: image.name);
      }

      final response = await api.post(
        EndPoints.updateProfile,
        data: data,
        isFormData: true,
      );

      return Right(response.data['message']);
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } on NoInternetException catch (e) {
      return Left(e.errorModel.detail);
    } catch (e) {
      return Left('Failed to update profile: $e');
    }
  }
}
