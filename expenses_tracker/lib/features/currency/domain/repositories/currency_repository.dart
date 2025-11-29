import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';

abstract class CurrencyRepository {
  Future<Either<Failure, double>> getExchangeRate({
    required String from,
    required String to,
  });
}
