import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../models/countries.model.dart';
import '../services/countries.service.dart';
import '../services/countries_service_interface.dart';
import 'country_details.dart';

class CountriesList extends StatefulWidget {
  final CountriesServiceInterface service;
  final bool useMockImage;

  CountriesList({
    super.key,
    CountriesServiceInterface? service,
    this.useMockImage = false,
  }) : service = service ?? CountriesService();

  @override
  State<CountriesList> createState() => _CountriesListState();
}

class _CountriesListState extends State<CountriesList> {
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
      final countries = await widget.service.getAllCountries();
      if (!mounted) return;

      setState(() {
        _allCountries = countries;
        _currentMaxIndex =
            _itemsPerPage < _allCountries.length
                ? _itemsPerPage
                : _allCountries.length;
        _displayedCountries = _allCountries.sublist(0, _currentMaxIndex);
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;

    if (_scrollController.position.maxScrollExtent == 0 ||
        _scrollController.position.maxScrollExtent -
                _scrollController.position.pixels <
            100) {
      _loadMoreItems();
    }
  }

  Future<void> _loadMoreItems() async {
    if (_isLoadingMore || _currentMaxIndex >= _allCountries.length) return;

    setState(() {
      _isLoadingMore = true;
    });

    await Future.delayed(const Duration(milliseconds: 1000));

    if (!mounted) return;

    setState(() {
      final nextMax = _currentMaxIndex + _itemsPerPage;
      _currentMaxIndex =
          nextMax < _allCountries.length ? nextMax : _allCountries.length;
      _displayedCountries = _allCountries.sublist(0, _currentMaxIndex);
      _isLoadingMore = false;
    });

    if (_currentMaxIndex < _allCountries.length &&
        _scrollController.hasClients &&
        _scrollController.position.maxScrollExtent == 0) {
      _loadMoreItems();
    }
  }

  void _navigateToDetails(Country country) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => CountryDetails(
              country: country,
              useMockImage: widget.useMockImage,
            ),
      ),
    );
  }

  Widget _buildFlagImage(String url, {double width = 50, double height = 30}) {
    if (widget.useMockImage) {
      return Container(
        width: width,
        height: height,
        color: Colors.blue,
        child: const Center(child: Icon(Icons.image, color: Colors.white)),
      );
    }
    return Image.network(url, width: width, height: height, fit: BoxFit.cover);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Lista de Países',
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        elevation: 4,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (_scrollController.hasClients &&
                _currentMaxIndex < _allCountries.length &&
                _scrollController.position.maxScrollExtent == 0) {
              _loadMoreItems();
            }
          });

          if (_isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (_displayedCountries.isEmpty) {
            return const Center(child: Text('Nenhum país encontrado'));
          }

          return NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification scrollInfo) {
              if (scrollInfo is ScrollEndNotification) {
                _onScroll();
              }
              return true;
            },
            child: ListView.builder(
              controller: _scrollController,
              itemCount: _displayedCountries.length + (_isLoadingMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _displayedCountries.length) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                final country = _displayedCountries[index];
                return ListTile(
                  leading: SizedBox(
                    width: 50,
                    height: 30,
                    child: _buildFlagImage(country.flagUrl),
                  ),
                  title: Text(country.name),
                  onTap: () => _navigateToDetails(country),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
