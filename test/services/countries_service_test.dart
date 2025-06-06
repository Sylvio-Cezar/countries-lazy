import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:countries_lazy/services/countries_service_interface.dart';
import 'package:countries_lazy/models/countries.model.dart';
import 'countries_service_test.mocks.dart';

// Testes do serviço de países
// Aqui testamos se o app consegue listar e buscar países corretamente
// usando mocks para simular as respostas da API
@GenerateMocks([CountriesServiceInterface])
void main() {
  // Criar o mock do serviço
  late MockCountriesServiceInterface mockService;
  
  // Dados de exemplo para os testes
  late List<Country> exemploPaises;

  // Configuração inicial para cada teste
  setUp(() {
    mockService = MockCountriesServiceInterface();
    exemploPaises = [
      Country(
        name: 'Testland', capital: ['Testville'],
        region: 'TestRegion', subregion: 'TestSub',
        population: 12345, area: 67.8,
        timezones: ['UTC+01:00'], borders: [],
        languages: {'en': 'English'},
        currencies: {'TST': {'name': 'Test Dollar','symbol': 'T\$'}},
        flagUrl: 'https://flag.png', cca2: 'TL', cca3: 'TST', independent: true
      )
    ];
  });

  // Teste 1: Listar países com sucesso
  test('Deve retornar lista de países corretamente', () async {
    // 1. Configurar o mock para retornar nossa lista de exemplo
    when(mockService.getAllCountries())
        .thenAnswer((_) async => exemploPaises);
    
    // 2. Chamar o método que queremos testar
    final lista = await mockService.getAllCountries();

    // 3. Verificar se o resultado está correto
    expect(lista, isNotEmpty);
    final pais = lista.first;
    expect(pais.name, 'Testland');
    expect(pais.capital.first, 'Testville');
    expect(pais.flagUrl, 'https://flag.png');
  });

  // Teste 2: Erro ao listar países
  test('Deve lançar exceção quando API falha', () async {
    // 1. Configurar o mock para simular erro
    when(mockService.getAllCountries())
        .thenThrow(Exception('Falha de API'));

    // 2. Verificar se o erro é tratado corretamente
    expect(() => mockService.getAllCountries(), throwsException);
  });

  // Teste 3: Buscar país existente
  test('Deve encontrar país pelo nome', () async {
    // 1. Configurar o mock para encontrar o país
    when(mockService.getCountryByName('Testland'))
        .thenAnswer((_) async => exemploPaises.first);

    // 2. Chamar o método de busca
    final resultado = await mockService.getCountryByName('Testland');
    
    // 3. Verificar se encontrou o país certo
    expect(resultado, isNotNull);
    expect(resultado!.population, 12345);
  });

  // Teste 4: Buscar país inexistente
  test('Deve retornar null para país inexistente', () async {
    // 1. Configurar o mock para simular país não encontrado
    when(mockService.getCountryByName('NoLand'))
        .thenAnswer((_) async => null);

    // 2. Tentar encontrar o país
    final resultado = await mockService.getCountryByName('NoLand');
    
    // 3. Verificar se retornou null
    expect(resultado, isNull);
  });

  // Teste 5: Dados incompletos
  test('Deve lidar com dados incompletos', () async {
    // 1. Criar país com dados faltando
    final incompleto = Country(
      name: 'Vazio', capital: [], region: '', subregion: '',
      population: 0, area: 0.0, timezones: [], borders: [],
      languages: {}, currencies: {}, flagUrl: '',
      cca2: '', cca3: '', independent: false
    );
    when(mockService.getAllCountries())
        .thenAnswer((_) async => [incompleto]);

    // 2. Tentar pegar a lista
    final lista = await mockService.getAllCountries();
    
    // 3. Verificar se lida bem com dados faltantes
    expect(lista.first.capital, isEmpty);
    expect(lista.first.flagUrl, isEmpty);
  });

  // Teste 6: Verificar chamadas
  test('Deve chamar getAllCountries() uma vez', () async {
    // 1. Configurar o mock
    when(mockService.getAllCountries())
        .thenAnswer((_) async => exemploPaises);

    // 2. Chamar o método
    await mockService.getAllCountries();
    
    // 3. Verificar se foi chamado uma vez
    verify(mockService.getAllCountries()).called(1);
  });
}