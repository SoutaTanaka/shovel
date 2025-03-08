import 'package:shovel/shovel.dart';
import 'package:test/test.dart';

void main() {
  group('Shovel Basic Functionality Tests', () {
    test('should register and resolve a basic dependency', () {
      // Arrange
      final ground = Ground()..bury<String>((shovel) => 'test string');

      // Act
      final shovel = ground.shovel();
      final result = shovel.dig<String>();

      // Assert
      expect(result, equals('test string'));
    });

    test('should register and resolve a dependency with argument', () {
      // Arrange
      final ground = Ground()
        ..buryWithArg<String, int>((shovel, arg) => 'number: $arg');

      // Act
      final shovel = ground.shovel();
      final result = shovel.digWithArg<String, int>(42);

      // Assert
      expect(result, equals('number: 42'));
    });

    test('should register and resolve multiple dependencies', () {
      // Arrange
      final ground = Ground()
        ..bury<int>((shovel) => 123)
        ..bury<double>((shovel) => 45.6)
        ..bury<String>((shovel) => 'test');

      // Act
      final shovel = ground.shovel();

      // Assert
      expect(shovel.dig<int>(), equals(123));
      expect(shovel.dig<double>(), equals(45.6));
      expect(shovel.dig<String>(), equals('test'));
    });

    test('should resolve dependencies in chain', () {
      // Arrange
      final ground = Ground()
        ..bury<int>((shovel) => 42)
        ..bury<String>((shovel) => 'number: ${shovel.dig<int>()}');

      // Act
      final shovel = ground.shovel();
      final result = shovel.dig<String>();

      // Assert
      expect(result, equals('number: 42'));
    });

    test('should merge dependencies from another Ground with reclaim', () {
      // Arrange
      final ground1 = Ground()..bury<int>((shovel) => 123);
      final ground2 = Ground()
        ..bury<String>((shovel) => 'test')

        // Act
        ..reclaim(ground1);
      final shovel = ground2.shovel();

      // Assert
      expect(shovel.dig<int>(), equals(123));
      expect(shovel.dig<String>(), equals('test'));
    });

    test('should throw StateError when resolving unregistered type', () {
      // Arrange
      final ground = Ground();
      final shovel = ground.shovel();

      // Act & Assert
      expect(() => shovel.dig<int>(), throwsA(isA<StateError>()));
    });

    test('should detect circular dependency', () {
      // Arrange
      final ground = Ground()

        // Create circular dependency
        ..bury<A>((shovel) => A(shovel.dig<B>()))
        ..bury<B>((shovel) => B(shovel.dig<A>()));

      final shovel = ground.shovel();

      // Act & Assert
      expect(() => shovel.dig<A>(), throwsA(isA<StateError>()));
    });

    test('should detect recursive dependency', () {
      // Arrange
      final ground = Ground()

        // Create recursive dependency
        ..bury<RecursiveClass>(
          (shovel) => RecursiveClass(shovel.dig<RecursiveClass>()),
        );

      final shovel = ground.shovel();

      // Act & Assert
      expect(() => shovel.dig<RecursiveClass>(), throwsA(isA<StateError>()));
    });

    test(
        'should throw StateError when resolving unregistered type with argument',
        () {
      // Arrange
      final ground = Ground();
      final shovel = ground.shovel();

      // Act & Assert
      expect(
        () => shovel.digWithArg<String, int>(42),
        throwsA(isA<StateError>()),
      );
    });

    test('should detect recursive dependency with digWithArg', () {
      // Arrange
      final ground = Ground()
        // Create recursive dependency with argument
        ..buryWithArg<RecursiveClassWithArg, String>(
          (shovel, arg) => RecursiveClassWithArg(
            shovel.digWithArg<RecursiveClassWithArg, String>('nested-$arg'),
            arg,
          ),
        );

      final shovel = ground.shovel();

      // Act & Assert
      expect(
        () => shovel.digWithArg<RecursiveClassWithArg, String>('start'),
        throwsA(isA<StateError>()),
      );
    });

    test('should detect circular dependency with digWithArg', () {
      // Arrange
      final ground = Ground()
        ..buryWithArg<AWithArg, String>(
          (shovel, arg) => AWithArg(
            shovel.digWithArg<BWithArg, String>('B-$arg'),
            arg,
          ),
        )
        ..buryWithArg<BWithArg, String>(
          (shovel, arg) => BWithArg(
            shovel.digWithArg<AWithArg, String>('A-$arg'),
            arg,
          ),
        );

      final shovel = ground.shovel();

      // Act & Assert
      expect(
        () => shovel.digWithArg<AWithArg, String>('start'),
        throwsA(isA<StateError>()),
      );
    });
  });

  group('Real-world Usage Tests', () {
    test('should resolve service and repository dependencies', () {
      // Arrange
      final ground = Ground()
        ..buryWithArg<UserService, String>(
          (shovel, apiKey) => UserService(apiKey: apiKey),
        )
        ..bury<UserRepository>(
          (shovel) => UserRepository(
            shovel.digWithArg<UserService, String>('test-api-key'),
          ),
        );

      // Act
      final shovel = ground.shovel();
      final repository = shovel.dig<UserRepository>();

      // Assert
      expect(repository, isA<UserRepository>());
      expect(repository.userService, isA<UserService>());
      expect(repository.userService.apiKey, equals('test-api-key'));
    });

    test('should resolve complex dependency graph', () {
      // Arrange - Create a complex dependency graph
      final ground = Ground()
        ..bury<ConfigService>((shovel) => ConfigService(environment: 'test'))
        ..bury<LoggerService>((shovel) => LoggerService())
        ..bury<ApiClient>(
          (shovel) => ApiClient(
            config: shovel.dig<ConfigService>(),
            logger: shovel.dig<LoggerService>(),
          ),
        )
        ..buryWithArg<UserService, String>(
          (shovel, apiKey) => UserService(apiKey: apiKey),
        )
        ..bury<UserRepository>(
          (shovel) => UserRepository(
            shovel.digWithArg<UserService, String>('test-api-key'),
          ),
        )
        ..bury<UserController>(
          (shovel) => UserController(
            repository: shovel.dig<UserRepository>(),
            apiClient: shovel.dig<ApiClient>(),
            logger: shovel.dig<LoggerService>(),
          ),
        );

      // Act
      final shovel = ground.shovel();
      final controller = shovel.dig<UserController>();

      // Assert - Verify the entire dependency graph
      expect(controller, isA<UserController>());
      expect(controller.repository, isA<UserRepository>());
      expect(controller.apiClient, isA<ApiClient>());
      expect(controller.logger, isA<LoggerService>());
      expect(controller.repository.userService, isA<UserService>());
      expect(controller.repository.userService.apiKey, equals('test-api-key'));
      expect(controller.apiClient.config, isA<ConfigService>());
      expect(controller.apiClient.config.environment, equals('test'));
    });
  });
}

// Test classes for dependency tests
class A {
  A(this.b);

  final B b;
}

class B {
  B(this.a);

  final A a;
}

// Class with recursive dependency
class RecursiveClass {
  RecursiveClass(this.dependency);

  final RecursiveClass dependency;
}

// Service classes for real-world tests
class UserService {
  UserService({required this.apiKey});

  final String apiKey;
}

class UserRepository {
  UserRepository(this.userService);

  final UserService userService;
}

class ConfigService {
  ConfigService({required this.environment});

  final String environment;
}

class LoggerService {
  void log(String message) {
    // Logging logic
  }
}

class ApiClient {
  ApiClient({required this.config, required this.logger});

  final ConfigService config;
  final LoggerService logger;
}

class UserController {
  UserController({
    required this.repository,
    required this.apiClient,
    required this.logger,
  });

  final UserRepository repository;
  final ApiClient apiClient;
  final LoggerService logger;
}

// Classes for testing recursive dependency with arguments
class RecursiveClassWithArg {
  RecursiveClassWithArg(this.dependency, this.value);

  final RecursiveClassWithArg dependency;
  final String value;
}

class AWithArg {
  AWithArg(this.b, this.value);

  final BWithArg b;
  final String value;
}

class BWithArg {
  BWithArg(this.a, this.value);

  final AWithArg a;
  final String value;
}
