import 'package:dartz/dartz.dart';
import 'package:kamchaiyo/core/error/exception.dart';
import 'package:kamchaiyo/core/error/failure.dart';
import 'package:kamchaiyo/features/interview/data/data_source/remote/interview_remote_data_source.dart';
import 'package:kamchaiyo/features/interview/domain/entity/interview_entity.dart';
import 'package:kamchaiyo/features/interview/domain/repository/interview_repository.dart';
import 'package:kamchaiyo/features/interview/domain/use_case/schedule_interview_usecase.dart';

class InterviewRepositoryImpl implements InterviewRepository {
  final InterviewRemoteDataSource remoteDataSource;
  InterviewRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, InterviewEntity>> scheduleInterview(
      ScheduleInterviewParams params) async {
    try {
      final result = await remoteDataSource.scheduleInterview(params);
      return Right(InterviewEntity(id: result.id));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }
}