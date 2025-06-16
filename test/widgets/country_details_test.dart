import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:countries_lazy/screens/countries_list.dart';
import 'package:countries_lazy/screens/country_details.dart';
import 'package:countries_lazy/services/countries_service_interface.dart';
import 'package:mockito/mockito.dart';
import '../services/mock_countries_service.dart';
import '../services/mock_countries_service.mocks.dart';

void main() {
  late MockCountriesService mockService;

  setUp(() {
    mockService = MockCountriesService();
  });

  testWidgets('Deve navegar para tela de detalhes ao clicar em um país', (
    WidgetTester tester,
  ) async {
    final mockCountries = MockCountriesServiceHelper.getMockCountries();
    when(mockService.getAllCountries()).thenAnswer((_) async => mockCountries);

    await tester.pumpWidget(
      MaterialApp(
        home: CountriesList(service: mockService, useMockImage: true),
      ),
    );

    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(find.text('Brasil'), findsOneWidget);

    await tester.tap(find.text('Brasil'));
    await tester.pumpAndSettle();

    expect(find.byType(CountryDetails), findsOneWidget);
    expect(
      find.text('Brasil'),
      findsOneWidget,
    );
    expect(find.text('Capital: '), findsOneWidget);
    expect(find.text('Brasília'), findsOneWidget);
    expect(find.text('Region: '), findsOneWidget);
    expect(find.text('Americas'), findsOneWidget);
    expect(find.text('Population: '), findsOneWidget);
    expect(find.text('212559417'), findsOneWidget);
  });

  testWidgets('Deve exibir todos os detalhes do país corretamente', (
    WidgetTester tester,
  ) async {
    final mockCountry = MockCountriesServiceHelper.getMockCountry();

    await tester.pumpWidget(
      MaterialApp(
        home: CountryDetails(country: mockCountry, useMockImage: true),
      ),
    );

    await tester.pump();
    await tester.pumpAndSettle();

    // Assert
    expect(find.text('Brasil'), findsOneWidget);
    expect(find.text('Capital: '), findsOneWidget);
    expect(find.text('Brasília'), findsOneWidget);
    expect(find.text('Region: '), findsOneWidget);
    expect(find.text('Americas'), findsOneWidget);
    expect(find.text('Subregion: '), findsOneWidget);
    expect(find.text('South America'), findsOneWidget);
    expect(find.text('Population: '), findsOneWidget);
    expect(find.text('212559417'), findsOneWidget);
    expect(find.text('Languages: '), findsOneWidget);
    expect(find.text('Portuguese'), findsOneWidget);
    expect(find.text('Currencies: '), findsOneWidget);
    expect(find.text('Brazilian Real (R\$)'), findsOneWidget);
    expect(find.text('Country Codes: '), findsOneWidget);
    expect(find.text('BR, BRA'), findsOneWidget);
    expect(find.text('Independent: '), findsOneWidget);
    expect(find.text('Yes'), findsOneWidget);
  });
}
