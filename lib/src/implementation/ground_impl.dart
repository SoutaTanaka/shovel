import 'dart:collection';

import 'package:shovel/src/implementation/shovel_impl.dart';

import '../interface/ground.dart';
import '../interface/shovel.dart';

typedef Dig<T> = T Function(Shovel shovel);
typedef DigWithArg<T, A> = T Function(Shovel shovel, dynamic arg);

class GroundImpl implements Ground {
  GroundImpl();

  final Map<Type, Dig> _container = HashMap();
  final Map<Type, DigWithArg> _containerWithArg = HashMap();

  @override
  void bury<T>(Dig<T> callback) {
    assert(!_container.containsKey(T));
    _container[T] = callback;
  }

  @override
  void buryWithArg<T, A>(DigWithArg<T, A> callback) {
    assert(!_containerWithArg.containsKey(T));
    _containerWithArg[T] = callback;
  }

  @override
  void reclaim(Ground ground) {
    ground as GroundImpl;
    assert(_container.keys.every((key) => !ground._container.containsKey(key)));
    _container.addAll(ground._container);
    assert(_containerWithArg.keys.every((key) => !ground._containerWithArg.containsKey(key)));
    _containerWithArg.addAll(ground._containerWithArg);
  }

  @override
  Shovel shovel() {
    return ShovelImpl(_container, _containerWithArg);
  }
}