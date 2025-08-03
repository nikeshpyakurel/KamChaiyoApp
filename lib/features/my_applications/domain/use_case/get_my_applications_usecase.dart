import 'package:dartz/dartz.dart';
import 'package:kamchaiyo/app/use_case/usecase.dart';
import 'package:kamchaiyo/core/error/failure.dart';
import 'package:kamchaiyo/features/auth/domain/use_case/check_auth_status_usecase.dart';
import 'package:kamchaiyo/features/my_applications/domain/entity/my_application_entity.dart';
import 'package:kamchaiyo/features/my_applications/domain/repository/my_applications_repository.dart';

class GetMyApplicationsUseCase
    implements UseCase<List<MyApplicationEntity>, NoParams> {
  final MyApplicationsRepository repository;
  GetMyApplicationsUseCase(this.repository);

  @override
  Future<Either<Failure, List<MyApplicationEntity>>> call(NoParams params) {
    return repository.getMyApplications();
  }
}