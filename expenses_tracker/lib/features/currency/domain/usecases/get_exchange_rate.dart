import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../repositories/currency_repository.dart';

class GetExchangeRate {
  final CurrencyRepository repository;

  GetExchangeRate(this.repository);

  Future<Either<Failure, double>> call({
    required String from,
    required String to,
  }) async {
    return await repository.getExchangeRate(from: from, to: to);
  }
}
