class Country {
  final String name;
  final List<String> capital;
  final String region;
  final String subregion;
  final int population;
  final double area;
  final List<String> timezones;
  final List<String> borders;
  final Map<String, String> languages;
  final Map<String, dynamic> currencies;
  final String flagUrl;
  final String cca2;
  final String cca3;
  final bool independent;

  Country({
    required this.name,
    required this.capital,
    required this.region,
    required this.subregion,
    required this.population,
    required this.area,
    required this.timezones,
    required this.borders,
    required this.languages,
    required this.currencies,
    required this.flagUrl,
    required this.cca2,
    required this.cca3,
    required this.independent,
  });

  factory Country.fromJson(Map<String, dynamic> json) {
    Map<String, String> parseLanguages(Map<String, dynamic>? langs) {
      if (langs == null) return {};
      return langs.map((key, value) => MapEntry(key, value.toString()));
    }

    Map<String, dynamic> parseCurrencies(Map<String, dynamic>? currs) {
      if (currs == null) return {};
      return currs;
    }

    return Country(
      name: json['name']?['common'] ?? '',
      capital:
          json['capital'] != null ? List<String>.from(json['capital']) : [],
      region: json['region'] ?? '',
      subregion: json['subregion'] ?? '',
      population: json['population'] ?? 0,
      area: (json['area'] != null) ? (json['area'] as num).toDouble() : 0.0,
      timezones:
          json['timezones'] != null ? List<String>.from(json['timezones']) : [],
      borders:
          json['borders'] != null ? List<String>.from(json['borders']) : [],
      languages: parseLanguages(json['languages']),
      currencies: parseCurrencies(json['currencies']),
      flagUrl: json['flags']?['png'] ?? '',
      cca2: json['cca2'] ?? '',
      cca3: json['cca3'] ?? '',
      independent: json['independent'] ?? false,
    );
  }
}
