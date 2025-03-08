import 'package:shovel/shovel.dart';

import 'package:shovel/src/implementation/ground_impl.dart';

/// A implementation of [Shovel] that resolves dependencies from a [Ground].
class ShovelImpl implements Shovel {
  /// Creates a new instance of [ShovelImpl].
  ShovelImpl(this._graph, this._graphWithArg);

  final Map<Type, Dig> _graph;
  final Map<Type, DigWithArg> _graphWithArg;
  final Set<Type> _visited = {};

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

  @override
  T digWithArg<T, A>(A arg) {
    if (_visited.contains(T)) {
      throw StateError('Circular dependency detected for type $T');
    }
    _visited.add(T);
    final result = _graphWithArg[T];
    if (result == null) {
      throw StateError('No instance of type $T found');
    }
    final instance = result.call(this, arg);
    _visited.remove(T);
    return instance;
  }
}
