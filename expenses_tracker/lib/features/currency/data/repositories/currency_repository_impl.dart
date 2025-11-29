import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../domain/repositories/currency_repository.dart';
import '../datasources/currency_remote_data_source.dart';

class CurrencyRepositoryImpl implements CurrencyRepository {
  final CurrencyRemoteDataSource remoteDataSource;

  CurrencyRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, double>> getExchangeRate({
    required String from,
    required String to,
  }) async {
    try {
      final rate = await remoteDataSource.getExchangeRate(
        from: from,
        to: to,
      );
      return Right(rate);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
