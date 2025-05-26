import 'package:flutter/material.dart';
import '../models/countries.model.dart';

class CountryDetails extends StatelessWidget {
  final Country country;

  const CountryDetails({super.key, required this.country});

  String _formatLanguages(Map<String, String> languages) {
    if (languages.isEmpty) return 'N/A';
    return languages.values.join(', ');
  }

  String _formatCurrencies(Map<String, dynamic> currencies) {
    if (currencies.isEmpty) return 'N/A';
    List<String> currencyList = [];
    currencies.forEach((key, value) {
      final name = value['name'] ?? '';
      final symbol = value['symbol'] ?? '';
      currencyList.add('$name ($symbol)');
    });
    return currencyList.join(', ');
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          country.name,
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.bold
          ),
        ),
        backgroundColor: theme.colorScheme.primary,
        elevation: 4,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  country.flagUrl,
                  width: 250,
                  height: 150,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 24),
            _buildInfoRow('Capital', country.capital.isNotEmpty ? country.capital.join(', ') : 'N/A'),
            _buildInfoRow('Region', country.region),
            _buildInfoRow('Subregion', country.subregion.isNotEmpty ? country.subregion : 'N/A'),
            _buildInfoRow('Population', country.population.toString()),
            _buildInfoRow('Area', '${country.area} km²'),
            _buildInfoRow('Languages', _formatLanguages(country.languages)),
            _buildInfoRow('Currencies', _formatCurrencies(country.currencies)),
            _buildInfoRow('Timezones', country.timezones.isNotEmpty ? country.timezones.join(', ') : 'N/A'),
            _buildInfoRow('Borders', country.borders.isNotEmpty ? country.borders.join(', ') : 'N/A'),
            _buildInfoRow('Country Codes', '${country.cca2}, ${country.cca3}'),
            _buildInfoRow('Independent', country.independent ? 'Yes' : 'No'),
          ],
        ),
      ),
    );
  }
}
