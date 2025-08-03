import 'package:dartz/dartz.dart';
import 'package:kamchaiyo/core/error/failure.dart';
import 'package:kamchaiyo/features/recruiter_dashboard/domain/entity/recruiter_stats_entity.dart';

abstract class RecruiterRepository {
  Future<Either<Failure, RecruiterStatsEntity>> getRecruiterStats();
}