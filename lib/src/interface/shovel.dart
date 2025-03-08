import 'package:shovel/src/interface/ground.dart';

/// A tool for resolving dependencies registered in a [Ground] container.
///
/// [Shovel] provides methods to retrieve instances of registered dependencies,
/// both with and without arguments.
///
/// Example:
/// ```dart
/// final shovel = ground.shovel();
/// final service = shovel.dig<Service>();
/// final repository = shovel.digWithArg<Repository, String>('api-key');
/// ```
abstract interface class Shovel {
  /// Resolves and returns an instance of type [T].
  ///
  /// This method retrieves an instance of [T] that was previously registered
  /// in the [Ground] container using [Ground.bury].
  ///
  /// Example:
  /// ```dart
  /// final userService = shovel.dig<UserService>();
  /// ```
  ///
  /// Throws an error if the type [T] has not been registered.
  T dig<T extends Object>();

  /// Resolves and returns an instance of type [T] with an argument of type [A].
  ///
  /// This method retrieves an instance of [T] that was previously registered
  /// in the [Ground] container using [Ground.buryWithArg], passing the provided
  /// argument of type [A] to the creation callback.
  ///
  /// Example:
  /// ```dart
  /// final userService = shovel.digWithArg<UserService, String>('api-key');
  /// ```
  ///
  /// Throws an error if the type [T] has not been registered with argument type [A].
  T digWithArg<T extends Object, A extends Object>(A arg);
}
