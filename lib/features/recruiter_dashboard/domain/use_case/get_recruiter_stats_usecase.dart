import 'package:dartz/dartz.dart';
import 'package:kamchaiyo/app/use_case/usecase.dart';
import 'package:kamchaiyo/core/error/failure.dart';
import 'package:kamchaiyo/features/auth/domain/use_case/check_auth_status_usecase.dart';
import 'package:kamchaiyo/features/recruiter_dashboard/domain/entity/recruiter_stats_entity.dart';
import 'package:kamchaiyo/features/recruiter_dashboard/domain/repository/recruiter_repository.dart';

class GetRecruiterStatsUseCase
    implements UseCase<RecruiterStatsEntity, NoParams> {
  final RecruiterRepository repository;

  GetRecruiterStatsUseCase(this.repository);

  @override
  Future<Either<Failure, RecruiterStatsEntity>> call(NoParams params) async {
    return await repository.getRecruiterStats();
  }
}