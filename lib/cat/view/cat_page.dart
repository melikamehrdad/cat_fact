import 'package:cat_trivia/cat/bloc/cat_bloc.dart';
import 'package:cat_trivia/cat/bloc/cat_event.dart';
import 'package:cat_trivia/cat/view/cat_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

class CatsPage extends StatelessWidget {
  const CatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cats')),
      body: BlocProvider(
        create: (_) => CatBloc(httpClient: http.Client())..add(CatFactFetched()),
        child: const Padding(
          padding: EdgeInsets.only(top: 8.0),
          child: CatsList(),
        ),
      ),
      floatingActionButton: ElevatedButton(
          onPressed: () => CatBloc(httpClient: http.Client()).add(AddNewFact()),
          child: const Text('Another Fact!')),
    );
  }
}
