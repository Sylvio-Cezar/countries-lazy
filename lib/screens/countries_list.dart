import 'package:flutter/material.dart';
import '../models/countries.model.dart';
import '../services/countries.service.dart';
import 'country_details.dart';

class CountriesList extends StatefulWidget {
  const CountriesList({super.key});

  @override
  State<CountriesList> createState() => _CountriesListState();
}

class _CountriesListState extends State<CountriesList> {
  final CountriesService _service = CountriesService();
  final ScrollController _scrollController = ScrollController();

  List<Country> _allCountries = [];
  List<Country> _displayedCountries = [];
  bool _isLoading = true;
  bool _isLoadingMore = false;
  final int _itemsPerPage = 10;
  int _currentMaxIndex = 0;

  @override
  void initState() {
    super.initState();
    _fetchCountries();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _fetchCountries() async {
    try {
      final countries = await _service.getAllCountries();
      setState(() {
        _allCountries = countries;
        _currentMaxIndex = _itemsPerPage < _allCountries.length ? _itemsPerPage : _allCountries.length;
        _displayedCountries = _allCountries.sublist(0, _currentMaxIndex);
        _isLoading = false;
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.position.maxScrollExtent == 0 && _currentMaxIndex < _allCountries.length) {
          _loadMoreItems();
        }
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 100) {
      _loadMoreItems();
    }
  }

  Future<void> _loadMoreItems() async {
    if (_isLoadingMore || _currentMaxIndex >= _allCountries.length) return;

    setState(() {
      _isLoadingMore = true;
    });

    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      final nextMax = _currentMaxIndex + _itemsPerPage;
      _currentMaxIndex = nextMax < _allCountries.length ? nextMax : _allCountries.length;
      _displayedCountries = _allCountries.sublist(0, _currentMaxIndex);
      _isLoadingMore = false;
    });
  }

  void _navigateToDetails(Country country) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CountryDetails(country: country),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Lista de Países',
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.bold
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        elevation: 4,
      ),
      body: ListView.builder(
        controller: _scrollController,
        itemCount: _displayedCountries.length + 1,
        itemBuilder: (context, index) {
          if (index < _displayedCountries.length) {
            final country = _displayedCountries[index];
            return ListTile(
              leading: Image.network(
                country.flagUrl,
                width: 50,
                height: 30,
                fit: BoxFit.cover,
              ),
              title: Text(country.name),
              onTap: () => _navigateToDetails(country),
            );
          } else {
            if (_isLoadingMore) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Center(child: CircularProgressIndicator()),
              );
            } else if (_currentMaxIndex >= _allCountries.length) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Center(child: Text('Todos os países carregados')),
              );
            } else {
              return const SizedBox.shrink();
            }
          }
        },
      ),
    );
  }
}
