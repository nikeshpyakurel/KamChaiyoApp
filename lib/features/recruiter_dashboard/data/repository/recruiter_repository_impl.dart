import 'package:dartz/dartz.dart';
import 'package:kamchaiyo/core/error/exception.dart';
import 'package:kamchaiyo/core/error/failure.dart';
import 'package:kamchaiyo/features/recruiter_dashboard/data/data_source/remote/recruiter_remote_data_source.dart';
import 'package:kamchaiyo/features/recruiter_dashboard/domain/entity/recruiter_stats_entity.dart';
import 'package:kamchaiyo/features/recruiter_dashboard/domain/repository/recruiter_repository.dart';

class RecruiterRepositoryImpl implements RecruiterRepository {
  final RecruiterRemoteDataSource remoteDataSource;

  RecruiterRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, RecruiterStatsEntity>> getRecruiterStats() async {
    try {
      final recruiterStatsDto = await remoteDataSource.getRecruiterStats();
      return Right(recruiterStatsDto.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }
}