import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:countries_lazy/screens/countries_list.dart';
import 'package:countries_lazy/screens/country_details.dart';
import 'package:countries_lazy/services/countries_service_interface.dart';
import 'package:mockito/mockito.dart';
import 'services/mock_countries_service.dart';
import 'services/mock_countries_service.mocks.dart';

void main() {
  group('Testes Unitários - Serviço de Países', () {
    late MockCountriesService mockService;

    setUp(() {
      mockService = MockCountriesService();
    });

    test('deve retornar lista de países', () async {
      final mockCountries = MockCountriesServiceHelper.getMockCountries();
      when(
        mockService.getAllCountries(),
      ).thenAnswer((_) async => mockCountries);

      final result = await mockService.getAllCountries();

      expect(result.length, equals(2));
      expect(result[0].name, equals('Brasil'));
      expect(result[1].name, equals('Argentina'));
    });
  });

  group('Testes de Widget - Lista de Países', () {
    late MockCountriesService mockService;

    setUp(() {
      mockService = MockCountriesService();
    });

    testWidgets('deve exibir lista de países', (WidgetTester tester) async {
      final mockCountries = MockCountriesServiceHelper.getMockCountries();
      when(
        mockService.getAllCountries(),
      ).thenAnswer((_) async => mockCountries);

      await tester.pumpWidget(
        MaterialApp(
          home: CountriesList(service: mockService, useMockImage: true),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      expect(find.text('Brasil'), findsOneWidget);
      expect(find.text('Argentina'), findsOneWidget);
    });

    testWidgets('deve navegar para detalhes ao clicar', (
      WidgetTester tester,
    ) async {
      final mockCountries = MockCountriesServiceHelper.getMockCountries();
      when(
        mockService.getAllCountries(),
      ).thenAnswer((_) async => mockCountries);

      await tester.pumpWidget(
        MaterialApp(
          home: CountriesList(service: mockService, useMockImage: true),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      await tester.tap(find.text('Brasil'));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      expect(find.text('Brasil'), findsOneWidget);
      expect(find.text('Capital: '), findsOneWidget);
      expect(find.text('Brasília'), findsOneWidget);
    });
  });

  group('Testes de Widget - Detalhes do País', () {
    testWidgets('deve exibir detalhes do país', (WidgetTester tester) async {
      final mockCountry = MockCountriesServiceHelper.getMockCountry();

      await tester.pumpWidget(
        MaterialApp(
          home: CountryDetails(country: mockCountry, useMockImage: true),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      expect(find.text('Brasil'), findsOneWidget);
      expect(find.byType(Container), findsOneWidget);
      expect(find.byIcon(Icons.image), findsOneWidget);
    });
  });
}
