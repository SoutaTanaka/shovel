import 'package:shovel/shovel.dart';

void main() {
  final Ground ground1 = Ground()..bury<A>((_) => A());

  final Ground ground2 = Ground()
    ..bury<B>((shovel) => B(shovel.dig<A>()))
    ..bury<C>((shovel) => C(shovel.dig<A>(), shovel.dig<B>()))
    ..reclaim(ground1);

  final shovel = ground2.excavate();

  final a = shovel.dig<A>();
}

class A {}

class B {
  B(A a) {}
}

class C {
  C(A a, B b) {}
}
