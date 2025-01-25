import 'dart:collection';

import '../../shovel.dart';

import 'ground_impl.dart';

class ShovelImpl implements Shovel {
  final Map<Type, Dig> _graph;
  final Set<Type> _visited = {};

  ShovelImpl(this._graph);

  @override
  T dig<T>() {
    if (_visited.contains(T)) {
      throw StateError('Circular dependency detected for type $T');
    }
    _visited.add(T);
    final result = _graph[T];
    if (result == null) {
      throw StateError('No instance of type $T found');
    }
    final instance = result.call(this);
    _visited.remove(T);
    return instance;
  }
}