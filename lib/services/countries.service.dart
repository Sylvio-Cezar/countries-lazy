import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/countries.model.dart';
import 'countries_service_interface.dart';

class CountriesService implements CountriesServiceInterface {
  final String _baseUrl =
      'https://restcountries.com/v3.1/all?fields=name,flags,capital,region,population';

  @override
  Future<List<Country>> getAllCountries() async {
    final response = await http.get(Uri.parse(_baseUrl));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      List<Country> countries =
          data.map((json) => Country.fromJson(json)).toList();
      return countries;
    } else {
      throw Exception('Erro ao buscar os países');
    }
  }

  @override
  Future<Country?> getCountryByName(String nome) async {
    final url = Uri.parse(
      'https://restcountries.com/v3.1/name/$nome?fullText=true&fields=name,flags,capital,region,population',
    );
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      if (data.isNotEmpty) return Country.fromJson(data.first);
      return null;
    }
    if (response.statusCode == 404) return null;
    throw Exception('Erro ao buscar país');
  }
}
