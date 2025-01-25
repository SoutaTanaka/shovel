import 'package:shovel/shovel.dart';

void main() {
  final Ground ground1 = Ground()..bury<A>((_) => A());

  final Ground ground2 = Ground()
    ..bury<B>((shovel) => B(shovel.dig<A>()))
    ..bury<C>((shovel) => C(shovel.dig<A>(), shovel.dig<B>()))
    ..reclaim(ground1);

  final shovel = ground2.shovel();

  print('---A---');
  final a = shovel.dig<A>();
  a.hello();

  print('---B---');
  final b = shovel.dig<B>();
  b.hello();

  print('---C---');
  final c = shovel.dig<C>();
  c.hello();
}

class A {
  void hello({String? from}) {
    print('Hello A ${from != null ? 'from $from' : ''}');
  }
}

class B {
  B(this.a);
  final A a;

  void hello({String? from}) {
    print('Hello B ${from != null ? 'from $from' : ''}');
    a.hello(from: from ?? 'B');
  }
}

class C {
  C(this.a, this.b);
  final A a;
  final B b;

  void hello() {
    print('Hello C');
    a.hello(from: 'C');
    b.hello(from: 'C');
  }
}
