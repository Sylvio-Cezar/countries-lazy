import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:countries_lazy/screens/countries_list.dart';
import 'package:countries_lazy/services/countries_service_interface.dart';
import 'package:mockito/mockito.dart';
import '../services/mock_countries_service.dart';
import '../services/mock_countries_service.mocks.dart';

void main() {
  late MockCountriesService mockService;

  setUp(() {
    mockService = MockCountriesService();
  });

  testWidgets('Deve exibir o nome do país na lista', (
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
    expect(find.text('Argentina'), findsOneWidget);
  });

  testWidgets('Deve exibir mensagem de carregamento inicialmente', (
    WidgetTester tester,
  ) async {
    when(mockService.getAllCountries()).thenAnswer((_) async => []);

    await tester.pumpWidget(
      MaterialApp(
        home: CountriesList(service: mockService, useMockImage: true),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
