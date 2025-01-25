import 'package:shovel/src/interface/shovel.dart';
import 'package:shovel/src/implementation/ground_impl.dart';

abstract interface class Ground {
  factory Ground() = GroundImpl;

  void bury<T>(T Function(Shovel shovel) callback);

  void reclaim(Ground ground);
// void buryMulti<T, A1>(List<T> Function(Shovel shovel, A1 arg1) callback);

  Shovel shovel();
}