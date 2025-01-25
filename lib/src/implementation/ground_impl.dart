import 'dart:collection';

import 'package:shovel/src/implementation/shovel_impl.dart';

import '../interface/ground.dart';
import '../interface/shovel.dart';

typedef Dig<T> = T Function(Shovel shovel);

class GroundImpl implements Ground {
  GroundImpl();

  final Map<Type, Dig> _buried = HashMap();

  @override
  void bury<T>(T Function(Shovel shovel) callback) {
    assert(!_buried.containsKey(T));
    _buried[T] = callback;
  }

  @override
  void reclaim(Ground ground) {
    ground as GroundImpl;
    assert(_buried.keys.every((key) => !ground._buried.containsKey(key)));
    _buried.addAll(ground._buried);
  }

  @override
  Shovel shovel() {
    return ShovelImpl(_buried);
  }
}