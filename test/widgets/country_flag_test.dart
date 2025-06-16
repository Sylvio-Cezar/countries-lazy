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

  testWidgets('Deve exibir a bandeira na lista de países', (
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

    expect(
      find.byType(Container),
      findsNWidgets(2),
    );
    expect(find.byIcon(Icons.image), findsNWidgets(2));
  });

  testWidgets('Deve exibir a bandeira na tela de detalhes', (
    WidgetTester tester,
  ) async {
    final mockCountry = MockCountriesServiceHelper.getMockCountry();

    await tester.pumpWidget(
      MaterialApp(
        home: CountryDetails(country: mockCountry, useMockImage: true),
      ),
    );

    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(find.byType(Container), findsOneWidget);
    expect(find.byIcon(Icons.image), findsOneWidget);

    expect(find.byType(ClipRRect), findsOneWidget);

    final RenderBox flagBox = tester.renderObject<RenderBox>(
      find.byType(Container).first,
    );
    expect(flagBox.size.width, 250);
    expect(flagBox.size.height, 150);
  });
}
