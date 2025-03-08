import 'package:shovel/src/implementation/ground_impl.dart';
import 'package:shovel/src/interface/shovel.dart';

/// A dependency injection container that manages object creation and dependencies.
///
/// [Ground] is responsible for registering dependencies and their creation logic.
/// It provides methods to register both simple and parameterized dependencies,
/// and can merge with other [Ground] instances to combine their registrations.
///
/// Example:
/// ```dart
/// final ground = Ground()
///   ..bury<Service>((shovel) => Service())
///   ..buryWithArg<Repository, String>((shovel, apiKey) => Repository(apiKey));
/// ```
abstract interface class Ground {
  /// Creates a new instance of [Ground].
  factory Ground() = GroundImpl;

  /// Registers a dependency of type [T] with its creation logic.
  ///
  /// The [callback] function receives a [Shovel] instance that can be used
  /// to resolve other dependencies during the creation of [T].
  ///
  /// Example:
  /// ```dart
  /// ground.bury<UserRepository>((shovel) => UserRepository(
  ///   shovel.dig<UserService>(),
  /// ));
  /// ```
  void bury<T extends Object>(Dig<T> callback);

  /// Registers a dependency of type [T] that requires an argument of type [A].
  ///
  /// The [callback] function receives both a [Shovel] instance and the argument
  /// of type [A] that will be provided when resolving the dependency.
  ///
  /// Example:
  /// ```dart
  /// ground.buryWithArg<UserService, String>((shovel, apiKey) =>
  ///   UserService(apiKey: apiKey),
  /// );
  /// ```
  void buryWithArg<T extends Object, A extends Object>(
    DigWithArg<T, A> callback,
  );

  /// Merges the registrations from another [Ground] instance into this one.
  ///
  /// All dependencies registered in the provided [ground] will be available
  /// through this instance after reclaiming.
  ///
  /// Example:
  /// ```dart
  /// final groundA = Ground()..bury<ServiceA>((s) => ServiceA());
  /// final groundB = Ground()..bury<ServiceB>((s) => ServiceB());
  /// groundB.reclaim(groundA); // Now groundB has both ServiceA and ServiceB
  /// ```
  void reclaim(Ground ground);

  /// Creates a new [Shovel] instance for resolving dependencies.
  ///
  /// The returned [Shovel] will have access to all dependencies registered
  /// in this [Ground] instance.
  ///
  /// Example:
  /// ```dart
  /// final shovel = ground.shovel();
  /// final service = shovel.dig<Service>();
  /// ```
  Shovel shovel();
}
