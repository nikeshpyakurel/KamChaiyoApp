import 'package:dartz/dartz.dart';
import 'package:kamchaiyo/core/error/failure.dart';
import 'package:kamchaiyo/features/my_applications/domain/entity/my_application_entity.dart';

abstract class MyApplicationsRepository {
  Future<Either<Failure, List<MyApplicationEntity>>> getMyApplications();
}