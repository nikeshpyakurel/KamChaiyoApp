import 'package:dartz/dartz.dart';
import 'package:kamchaiyo/core/error/exception.dart';
import 'package:kamchaiyo/core/error/failure.dart';
import 'package:kamchaiyo/features/my_applications/data/data_source/remote/my_applications_remote_data_source.dart';
import 'package:kamchaiyo/features/my_applications/domain/entity/my_application_entity.dart';
import 'package:kamchaiyo/features/my_applications/domain/repository/my_applications_repository.dart';

class MyApplicationsRepositoryImpl implements MyApplicationsRepository {
  final MyApplicationsRemoteDataSource remoteDataSource;
  MyApplicationsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<MyApplicationEntity>>> getMyApplications() async {
    try {
      final result = await remoteDataSource.getMyApplications();
      return Right(result.map((dto) => dto.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }
}