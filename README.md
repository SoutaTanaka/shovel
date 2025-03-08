<!-- 
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/tools/pub/writing-package-pages). 

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/to/develop-packages). 
-->

# Shovel

A lightweight dependency injection framework for Dart applications that provides an intuitive way to manage dependencies. Shovel is inspired by [Kodein](https://github.com/kosi-libs/Kodein), a dependency injection library for Kotlin.

[日本語のREADMEはこちら](README.ja.md)

## Features

- Simple and intuitive API for dependency registration and resolution
- Support for parameterized dependency injection
- Ability to merge multiple dependency containers
- Type-safe dependency resolution
- Flexible dependency configuration

## Getting Started

Add `shovel` to your `pubspec.yaml`:

```yaml
dependencies:
  shovel: ^1.0.0
```

## Usage

Here's a basic example of how to use Shovel:

```dart
// Define your classes
class UserService {
  final String apiKey;
  UserService({required this.apiKey});
}

class UserRepository {
  final UserService userService;
  UserRepository(this.userService);
}

// Set up dependency injection
final ground = Ground()
  ..buryWithArg<UserService, String>((shovel, apiKey) => UserService(apiKey: apiKey))
  ..bury<UserRepository>((shovel) => UserRepository(
        shovel.digWithArg<UserService, String>('your-api-key'),
      ));

// Get instances
final shovel = ground.shovel();
final repository = shovel.dig<UserRepository>();
```

For more complex examples, check the `/example` folder.

## Additional Information

- Package is compatible with Dart SDK 3.6.0 or higher
- For bug reports and feature requests, please visit the issue tracker
- Contributions are welcome!
