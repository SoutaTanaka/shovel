import 'package:shovel/src/interface/shovel.dart';
import 'package:shovel/src/implementation/ground_impl.dart';

abstract interface class Ground {
  factory Ground() = GroundImpl;

  void bury<T>(T Function(Shovel shovel) callback);

  void buryWithArg<T, A>(DigWithArg<T, A> callback);

  void reclaim(Ground ground);

  Shovel shovel();
}
