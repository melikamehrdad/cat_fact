import 'package:cat_trivia/cat/models/cat.dart';
import 'package:equatable/equatable.dart';

enum CatStatus { initial, success, failure }

class CatState extends Equatable {
  const CatState({
    this.status = CatStatus.initial,
    this.cats = const <Cat>[],
    this.hasReachedMax = false,
  });

  final CatStatus status;
  final List<Cat> cats;
  final bool hasReachedMax;

  CatState copyWith({
    CatStatus? status,
    List<Cat>? cats,
    bool? hasReachedMax,
  }) {
    return CatState(
      status: status ?? this.status,
      cats: cats ?? this.cats,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  String toString() {
    return '''CatState { status: $status, hasReachedMax: $hasReachedMax, Cats: ${cats.length} }''';
  }

  @override
  List<Object> get props => [status, cats, hasReachedMax];
}