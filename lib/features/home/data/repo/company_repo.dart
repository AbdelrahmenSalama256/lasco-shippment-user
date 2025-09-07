// lib/features/company/data/repo/company_repo.dart
import 'package:dartz/dartz.dart';
import 'package:lasco/core/constants/widgets/errors/exceptions.dart';
import 'package:lasco/core/database/api/api_consumer.dart';
import 'package:lasco/core/database/api/end_points.dart';

import '../model/company_model.dart';

class CompanyRepo {
  final ApiConsumer api;

  CompanyRepo(this.api);

  Future<Either<String, CompanyResponse>> getCompanies({
    int page = 1,
    int perPage = 10,
  }) async {
    try {
      final response = await api.get(
        EndPoints.shipmentCompanies,
        queryParameters: {
          'page': page,
          'per_page': perPage,
        },
      );

      return Right(CompanyResponse.fromJson(response.data));
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } on NoInternetException catch (e) {
      return Left(e.errorModel.detail);
    } catch (e) {
      return Left('Failed to fetch companies: $e');
    }
  }

  Future<Either<String, CompanyModel>> getCompanyDetails(int companyId) async {
    try {
      final response = await api.get(
        '${EndPoints.shipmentCompanies}/$companyId',
      );

      return Right(CompanyModel.fromJson(response.data['data']));
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } on NoInternetException catch (e) {
      return Left(e.errorModel.detail);
    } catch (e) {
      return Left('Failed to fetch company details: $e');
    }
  }
}
