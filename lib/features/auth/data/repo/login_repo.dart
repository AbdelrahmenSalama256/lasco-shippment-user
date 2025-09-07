import 'package:dartz/dartz.dart';
import 'package:lasco/core/database/api/api_consumer.dart';

import '../../../../core/constants/widgets/errors/exceptions.dart';
import '../../../../core/database/api/end_points.dart';
import '../models/sign_up_models.dart';

class LoginRepo {
  final ApiConsumer api;

  LoginRepo(this.api);

  //! Forget Password - Send OTP
  Future<Either<String, ResponseModel>> sendForgotPasswordOtp({
    required String phone,
  }) async {
    try {
      final response = await api.post(
        EndPoints.sendOtpReset,
        data: {
          "phone": phone,
        },
      );

      return Right(ResponseModel.fromJson(response.data));
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } on NoInternetException catch (e) {
      return Left(e.errorModel.detail);
    } catch (e) {
      return Left(e.toString());
    }
  }

  //! Forget Password - Verify OTP
  Future<Either<String, ResponseModel>> verifyForgotPasswordOtp({
    required String phone,
    required String code,
  }) async {
    try {
      final response = await api.post(
        EndPoints.verifyForgotPasswordOtp,
        data: {
          "phone": phone,
          "code": code,
        },
      );

      return Right(ResponseModel.fromJson(response.data));
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } on NoInternetException catch (e) {
      return Left(e.errorModel.detail);
    } catch (e) {
      return Left(e.toString());
    }
  }

  //! Forget Password - Reset Password
  Future<Either<String, ResponseModel>> resetPassword({
    required String phone,
    required String newPassword,
    required String confirmPassword,
  }) async {
    try {
      final response = await api.post(
        EndPoints.resetPassword,
        data: {
          "password": newPassword,
          'phone': phone,
          "password_confirmation": confirmPassword,
        },
      );

      return Right(ResponseModel.fromJson(response.data));
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } on NoInternetException catch (e) {
      return Left(e.errorModel.detail);
    } catch (e) {
      return Left(e.toString());
    }
  }

  //! Keep your existing methods...
  Future<Either<String, ResponseModel>> userLogin({
    required String phone,
    required String password,
  }) async {
    try {
      final response = await api.post(
        EndPoints.login,
        data: {
          "phone": phone,
          "password": password,
        },
      );

      return Right(ResponseModel.fromJson(response.data));
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } on NoInternetException catch (e) {
      return Left(e.errorModel.detail);
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, ResponseModel>> verifyOtp({
    required String phone,
    required String code,
  }) async {
    try {
      final response = await api.post(
        EndPoints.verify,
        data: {
          "phone": phone,
          "code": code,
        },
      );

      return Right(ResponseModel.fromJson(response.data));
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } on NoInternetException catch (e) {
      return Left(e.errorModel.detail);
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, String>> resendOtp({
    required String phone,
  }) async {
    try {
      final response = await api.post(
        EndPoints.resendOtp,
        data: {
          "phone": phone,
        },
      );

      return Right(response.data['message']);
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } on NoInternetException catch (e) {
      return Left(e.errorModel.detail);
    } catch (e) {
      return Left(e.toString());
    }
  }
}
