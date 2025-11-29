import 'dart:convert';
import 'package:http/http.dart' as http;

abstract class CurrencyRemoteDataSource {
  Future<double> getExchangeRate({
    required String from,
    required String to,
  });
}

class CurrencyRemoteDataSourceImpl implements CurrencyRemoteDataSource {
  final http.Client client;

  CurrencyRemoteDataSourceImpl(this.client);

  @override
  Future<double> getExchangeRate({
    required String from,
    required String to,
  }) async {
    try {
      final response = await client.get(
        Uri.parse('https://open.er-api.com/v6/latest/$from'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final rates = data['rates'] as Map<String, dynamic>;
        
        if (rates.containsKey(to)) {
          return (rates[to] as num).toDouble();
        } else {
          throw Exception('Currency $to not found');
        }
      } else {
        throw Exception('Failed to fetch exchange rate');
      }
    } catch (e) {
      throw Exception('Error fetching exchange rate: $e');
    }
  }
}
