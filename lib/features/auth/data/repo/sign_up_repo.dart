import 'package:dartz/dartz.dart';
import 'package:lasco/core/database/api/api_consumer.dart';

import '../../../../core/constants/widgets/errors/exceptions.dart';
import '../../../../core/database/api/end_points.dart';
import '../models/sign_up_models.dart';

class SignUpRepo {
  final ApiConsumer api;

  SignUpRepo(this.api);

  //! Register
  Future<Either<String, ResponseModel>> registerUser({
    required String username,
    required String phone,
    required String email,
    required String password,
    required String passwordConfirmation,
    required String countryCode,
  }) async {
    try {
      // final fcmToken = NotificationHandler.fcmToken;

      final response = await api.post(
        EndPoints.register,
        data: {
          "username": username,
          "phone": phone,
          "email": email,
          "password": password,
          "password_confirmation": passwordConfirmation,
          "country_code": "+$countryCode",
          // "fcm_token": fcmToken,
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
}
