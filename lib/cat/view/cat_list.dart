import 'package:cat_trivia/cat/bloc/cat_bloc.dart';
import 'package:cat_trivia/cat/bloc/cat_event.dart';
import 'package:cat_trivia/cat/bloc/cat_state.dart';
import 'package:cat_trivia/cat/widgets/bottom_loader.dart';
import 'package:cat_trivia/cat/widgets/cat_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CatsList extends StatefulWidget {
  const CatsList({super.key});

  @override
  State<CatsList> createState() => _CatsListState();
}

class _CatsListState extends State<CatsList> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CatBloc, CatState>(
      builder: (context, state) {
        switch (state.status) {
          case CatStatus.failure:
            return const Center(child: Text('failed to fetch Cats'));
          case CatStatus.success:
            if (state.cats.isEmpty) {
              return const Center(child: Text('no Cats'));
            }
            return ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                return index >= state.cats.length
                    ? const BottomLoader()
                    : CatListItem(cat: state.cats[index]);
              },
              itemCount: state.hasReachedMax
                  ? state.cats.length
                  : state.cats.length + 1,
              controller: _scrollController,
            );
          case CatStatus.initial:
            return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) context.read<CatBloc>().add(CatFactFetched());
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }
}