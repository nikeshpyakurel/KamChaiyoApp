import 'package:dartz/dartz.dart';
import 'package:kamchaiyo/app/use_case/usecase.dart';
import 'package:kamchaiyo/core/error/failure.dart';
import 'package:kamchaiyo/features/auth/domain/use_case/check_auth_status_usecase.dart';
import 'package:kamchaiyo/features/my_interviews/domain/entity/interview_details_entity.dart';
import 'package:kamchaiyo/features/my_interviews/domain/repository/my_interviews_repository.dart';

class GetMyInterviewsUseCase
    implements UseCase<List<InterviewDetailsEntity>, NoParams> {
  final MyInterviewsRepository repository;
  GetMyInterviewsUseCase(this.repository);

  @override
  Future<Either<Failure, List<InterviewDetailsEntity>>> call(NoParams params) {
    return repository.getMyInterviews();
  }
}