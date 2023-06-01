import 'dart:collection';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:poke_app/screens/pokemon.dart';

class Data extends ChangeNotifier {
  final int _limit = 20;
  int _offset = 0;
  bool _loading = false;
  bool _isMore = true;
  final List<PokemonListItemModel> _pokemenList = [];

  final dio = Dio();

  int get pokemonListCount {
    return _pokemenList.length;
  }

  int get limit {
    return _limit;
  }

  int get offset {
    return _offset;
  }

  bool get loading {
    return _loading;
  }

  bool get isMore {
    return _isMore;
  }

  UnmodifiableListView<PokemonListItemModel> get pokemonList {
    return UnmodifiableListView(_pokemenList);
  }

  void updatePokemonList(List<PokemonListItemModel> data) {
    _pokemenList.addAll(data);
    notifyListeners();
  }

  void updateOffset() {
    _offset += _limit;
    notifyListeners();
  }

  void updateLoading(bool load) {
    _loading = load;
    notifyListeners();
  }

  void updateIsMore(bool more) {
    _isMore = more;
    notifyListeners();
  }

  Future<void> fetchPage() async {
    Response<Map<String, dynamic>> response;
    updateLoading(true);
    try {
      response = await dio.get(
          'https://pokeapi.co/api/v2/pokemon?limit=$_limit&offset=$_offset');
      var res = response.data;
      List<PokemonListItemModel> data = List<PokemonListItemModel>.from(
          res?['results'].map((e) => PokemonListItemModel.fromJSON(e)));
      if (data.length < limit) {
        updateIsMore(false);
      }
      updatePokemonList(data);
      updateLoading(false);
      debugPrint('prevOffset: $_offset');
      updateOffset();
      debugPrint('nextOffset: $_offset');
    } catch (error) {
      debugPrint('error: $error');
      updateLoading(false);
    }
  }
}
