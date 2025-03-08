// Example of how to use Shovel
// ignore_for_file: avoid_print

import 'package:shovel/shovel.dart';

void main() {
  final ground1 = Ground()
    ..buryWithArg<A, String>((shovel, arg) => A(name: arg));

  final ground2 = Ground()
    ..buryWithArg<B, String>(
      (shovel, arg) => B(shovel.digWithArg<A, String>(arg)),
    )
    ..bury<C>(
      (shovel) => C(
        shovel.digWithArg<A, String>('CCC'),
        shovel.digWithArg<B, String>('CCCC'),
      ),
    )
    ..reclaim(ground1);

  final shovel = ground2.shovel();

  print('---A---');
  shovel.digWithArg<A, String>('AAA').hello();

  print('---B---');
  shovel.digWithArg<B, String>('BBB').hello();

  print('---C---');
  shovel.dig<C>().hello();
}

class A {
  A({required this.name});
  final String name;
  void hello({String? from}) {
    print('Hello A ${from != null ? 'from $from' : ''} $name');
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

class D {
  D(this.e);
  final E e;

  void hello() {
    print('Hello D');
  }
}

class E {
  E(this.d);
  final D d;
}

class F {
  F(this.g);
  final G g;

  void hello() {
    print('Hello F');
  }
}

class G {
  G(this.d);
  final D d;
}
