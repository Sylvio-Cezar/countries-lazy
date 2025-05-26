import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/countries.model.dart';

class CountriesService {
  final String _baseUrl = 'https://restcountries.com/v3.1/all';

  Future<List<Country>> getAllCountries() async {
    final response = await http.get(Uri.parse(_baseUrl));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      List<Country> countries = data.map((json) => Country.fromJson(json)).toList();
      return countries;
    } else {
      throw Exception('Erro ao buscar os países');
    }
  }
}
