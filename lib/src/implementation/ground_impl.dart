import 'dart:collection';

import 'package:shovel/src/implementation/shovel_impl.dart';

import 'package:shovel/src/interface/ground.dart';
import 'package:shovel/src/interface/shovel.dart';

/// A dependency injection container that manages object creation and dependencies.
typedef Dig<T> = T Function(Shovel shovel);

/// A dependency injection container that manages object creation and dependencies.
typedef DigWithArg<T, A> = T Function(Shovel shovel, dynamic arg);

/// An implementation of [Ground] that manages dependency registrations.
class GroundImpl implements Ground {
  /// Creates a new instance of [GroundImpl].
  GroundImpl();

  final Map<Type, Dig> _container = HashMap();
  final Map<Type, DigWithArg> _containerWithArg = HashMap();

  @override
  void bury<T>(Dig<T> callback) {
    assert(!_container.containsKey(T), 'Type $T is already registered');
    _container[T] = callback;
  }

  @override
  void buryWithArg<T, A>(DigWithArg<T, A> callback) {
    assert(!_containerWithArg.containsKey(T), 'Type $T is already registered');
    _containerWithArg[T] = callback;
  }

  @override
  void reclaim(Ground ground) {
    ground as GroundImpl;
    assert(
      _container.keys.every((key) => !ground._container.containsKey(key)),
      'Types already registered',
    );
    _container.addAll(ground._container);
    assert(
      _containerWithArg.keys
          .every((key) => !ground._containerWithArg.containsKey(key)),
      'Types already registered',
    );
    _containerWithArg.addAll(ground._containerWithArg);
  }

  @override
  Shovel shovel() {
    return ShovelImpl(_container, _containerWithArg);
  }
}
