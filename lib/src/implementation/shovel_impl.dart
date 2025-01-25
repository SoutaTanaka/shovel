import '../../shovel.dart';

import 'ground_impl.dart';

class ShovelImpl implements Shovel {
  final Map<Type, Dig> _graph;

  ShovelImpl(this._graph);

  @override
  T dig<T>() {
    final result = _graph[T];
    if (result == null) {
      throw StateError('No instance of type $T found');
    }
    return result.call(this);
  }
}