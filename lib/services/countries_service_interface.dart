import '../models/countries.model.dart';

/// Interface que define como obter dados de países
abstract class CountriesServiceInterface {
  /// Obtém a lista de todos os países
  Future<List<Country>> getAllCountries();

  /// Busca um país específico pelo nome
  Future<Country?> getCountryByName(String nome);
} 