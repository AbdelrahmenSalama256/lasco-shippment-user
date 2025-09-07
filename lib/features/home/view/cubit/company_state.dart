import '../../data/model/company_model.dart';

sealed class CompanyState {}

final class CompanyInitial extends CompanyState {}

class CompanyLoading extends CompanyState {}

class CompanyLoadingMore extends CompanyState {}

class CompanyLoaded extends CompanyState {
  final List<CompanyModel> companies;
  final bool hasMore;
  final int currentPage;
  final int totalPages;

  CompanyLoaded({
    required this.companies,
    required this.hasMore,
    required this.currentPage,
    required this.totalPages,
  });
}

class CompanyError extends CompanyState {
  final String message;

  CompanyError(this.message);
}

class CompanyDetailsLoading extends CompanyState {}

class CompanyDetailsLoaded extends CompanyState {
  final CompanyModel company;

  CompanyDetailsLoaded(this.company);
}

class CompanyDetailsError extends CompanyState {
  final String message;

  CompanyDetailsError(this.message);
}
