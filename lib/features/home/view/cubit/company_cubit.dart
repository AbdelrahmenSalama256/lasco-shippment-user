import 'package:bloc/bloc.dart';

import '../../../../core/constants/widgets/print_util.dart';
import '../../../../core/services/service_locator.dart';
import '../../data/model/company_model.dart';
import '../../data/repo/company_repo.dart';
import 'company_state.dart';

class CompanyCubit extends Cubit<CompanyState> {
  CompanyCubit() : super(CompanyInitial());

  final CompanyRepo _repo = sl<CompanyRepo>();
  int _currentPage = 1;
  bool _hasMore = true;
  final List<CompanyModel> _companies = [];

  List<CompanyModel> get companies => _companies;
  bool get hasMore => _hasMore;
  int get currentPage => _currentPage;

  Future<void> getCompanies({bool loadMore = false}) async {
    try {
      if (!loadMore) {
        emit(CompanyLoading());
        _currentPage = 1;
        _hasMore = true;
        _companies.clear();
      } else {
        if (!_hasMore) return;
        emit(CompanyLoadingMore());
      }

      final result = await _repo.getCompanies(
        page: _currentPage,
        perPage: 10,
      );

      result.fold(
        (error) {
          emit(CompanyError(error));
        },
        (response) {
          if (response.data?.companies != null) {
            _companies.addAll(response.data!.companies!);
          }
          _hasMore = response.data?.meta?.currentPage != null &&
              response.data?.meta?.lastPage != null &&
              (response.data!.meta!.currentPage! <
                  response.data!.meta!.lastPage!);

          if (_hasMore) {
            _currentPage++;
          }

          emit(CompanyLoaded(
            companies: _companies,
            hasMore: _hasMore,
            currentPage: _currentPage,
            totalPages: response.data?.meta?.lastPage ?? 0,
          ));
        },
      );
    } catch (e) {
      PrintUtil.error('Error fetching companies: $e');
      emit(CompanyError('Failed to load companies'));
    }
  }

  Future<void> refreshCompanies() async {
    await getCompanies(loadMore: false);
  }

  Future<void> loadMoreCompanies() async {
    if (_hasMore && state is! CompanyLoadingMore) {
      await getCompanies(loadMore: true);
    }
  }

  Future<void> getCompanyDetails(int? companyId) async {
    if (companyId == null) {
      emit(CompanyDetailsError('Invalid company ID'));
      return;
    }
    emit(CompanyDetailsLoading());

    try {
      final result = await _repo.getCompanyDetails(companyId);

      result.fold(
        (error) {
          emit(CompanyDetailsError(error));
        },
        (company) {
          emit(CompanyDetailsLoaded(company));
        },
      );
    } catch (e) {
      PrintUtil.error('Error fetching company details: $e');
      emit(CompanyDetailsError('Failed to load company details'));
    }
  }
}
