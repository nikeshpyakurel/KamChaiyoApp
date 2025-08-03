import 'package:dartz/dartz.dart';
import 'package:kamchaiyo/core/error/exception.dart';
import 'package:kamchaiyo/core/error/failure.dart';
import 'package:kamchaiyo/features/my_interviews/data/data_source/remote/my_interviews_remote_data_source.dart';
import 'package:kamchaiyo/features/my_interviews/domain/entity/interview_details_entity.dart';
import 'package:kamchaiyo/features/my_interviews/domain/repository/my_interviews_repository.dart';
class MyInterviewsRepositoryImpl implements MyInterviewsRepository {
final MyInterviewsRemoteDataSource remoteDataSource;
MyInterviewsRepositoryImpl({required this.remoteDataSource});
@override
Future<Either<Failure, List<InterviewDetailsEntity>>> getMyInterviews() async {
try {
final result = await remoteDataSource.getMyInterviews();
return Right(result.map((dto) => dto.toEntity()).toList());
} on ServerException catch (e) {
return Left(ServerFailure(message: e.message));
}
}
}