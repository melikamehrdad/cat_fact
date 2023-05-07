import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:cat_trivia/cat/bloc/cat_event.dart';
import 'package:cat_trivia/cat/bloc/cat_state.dart';
import 'package:cat_trivia/cat/models/cat.dart';
import 'package:http/http.dart' as http;

class CatBloc extends Bloc<CatEvent, CatState> {
  final http.Client httpClient;

  CatBloc({required this.httpClient}) : super(const CatState()) {
    on<CatFactFetched>(
      _onCatFetched,
    );
    on<AddNewFact>(
      _onAddNewFact,
    );
  }

  Future<void> _onAddNewFact(
      AddNewFact event,
      Emitter<CatState> emit,
      ) async {
    if (state.hasReachedMax) return;
    try {
      if (state.status == CatStatus.initial) {
        final newFact = await _getNewFacts();
        final cats = state.cats;
        cats.add(newFact);
        return emit(
          state.copyWith(
            status: CatStatus.success,
            cats: cats,
            hasReachedMax: false,
          ),
        );
      }
    } catch (_) {
      emit(state.copyWith(status: CatStatus.failure));
    }
  }

  Future<void> _onCatFetched(
      CatFactFetched event,
      Emitter<CatState> emit,
      ) async {
    if (state.hasReachedMax) return;
    try {
      if (state.status == CatStatus.initial) {
        final cats = await _fetchCats();
        return emit(
          state.copyWith(
            status: CatStatus.success,
            cats: cats,
            hasReachedMax: false,
          ),
        );
      }
      final cats = await _fetchCats();
      cats.isEmpty
          ? emit(state.copyWith(hasReachedMax: true))
          : emit(
        state.copyWith(
          status: CatStatus.success,
          cats: List.of(state.cats)..addAll(cats),
          hasReachedMax: false,
        ),
      );
    } catch (_) {
      emit(state.copyWith(status: CatStatus.failure));
    }
  }

  Future<Cat> _getNewFacts() async {
    final response = await httpClient.get(
      Uri.https(
        'cat-fact.herokuapp.com',
        '/facts/random',
        <String, String>{'animal_type': 'cat', 'amount': '1'},
      ),
    );
    if (response.statusCode == 200) {
      return Cat.fromJson(jsonDecode(response.body));
    }
    throw Exception('error get new cats fact');
  }



  Future<List<Cat>> _fetchCats() async {
    final response = await httpClient.get(
      Uri.https(
        'cat-fact.herokuapp.com',
        '/facts/random',
        <String, String>{'animal_type': 'cat', 'amount': '20'},
      ),
    );
    if (response.statusCode == 200) {
      final body = json.decode(response.body) as List;
      return body.map((dynamic json) {
        final map = json as Map<String, dynamic>;
        return Cat(
          id: map['_id'] as String,
          text: map['text'] as String,
          image: 'https://cataas.com/cat',
          createdAt: DateTime.parse(map['createdAt']),
          deleted: map['deleted'] as bool,
          type: map['type'] as String,
          updatedAt: DateTime.parse(map['updatedAt']),
          user: map['user'] as String,
          v: map['__v'] as int,
        );
      }).toList();
    }
    throw Exception('error fetching Cats');
  }
}