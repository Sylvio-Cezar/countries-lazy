import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:countries_lazy/services/countries_service_interface.dart';
import 'package:countries_lazy/models/countries.model.dart';

@GenerateMocks(
  [CountriesServiceInterface],
  customMocks: [MockSpec<CountriesServiceInterface>(as: #MockCountriesService)],
)
class MockCountriesServiceHelper {
  static Country getMockCountry() {
    return Country(
      name: 'Brasil',
      capital: ['Brasília'],
      region: 'Americas',
      subregion: 'South America',
      population: 212559417,
      area: 8515767.0,
      timezones: ['UTC-05:00', 'UTC-04:00', 'UTC-03:00', 'UTC-02:00'],
      borders: [
        'ARG',
        'BOL',
        'COL',
        'GUF',
        'GUY',
        'PRY',
        'PER',
        'SUR',
        'URY',
        'VEN',
      ],
      languages: {'por': 'Portuguese'},
      currencies: {
        'BRL': {'name': 'Brazilian Real', 'symbol': 'R\$'},
      },
      flagUrl: 'https://flagcdn.com/br.png',
      cca2: 'BR',
      cca3: 'BRA',
      independent: true,
    );
  }

  static List<Country> getMockCountries() {
    return [
      getMockCountry(),
      Country(
        name: 'Argentina',
        capital: ['Buenos Aires'],
        region: 'Americas',
        subregion: 'South America',
        population: 45195774,
        area: 2780400.0,
        timezones: ['UTC-03:00'],
        borders: ['BOL', 'BRA', 'CHL', 'PRY', 'URY'],
        languages: {'spa': 'Spanish'},
        currencies: {
          'ARS': {'name': 'Argentine Peso', 'symbol': '\$'},
        },
        flagUrl: 'https://flagcdn.com/ar.png',
        cca2: 'AR',
        cca3: 'ARG',
        independent: true,
      ),
    ];
  }
}
