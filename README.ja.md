# Shovel

Dartアプリケーションのための軽量な依存性注入フレームワークです。直感的な依存関係の管理を提供します。Shovelは、Kotlin向けの依存性注入ライブラリである[Kodein](https://github.com/kosi-libs/Kodein)にインスパイアされています。

[English README is here](README.md)

## 特徴

- シンプルで直感的な依存関係の登録・解決API
- パラメータ化された依存性注入のサポート
- 複数の依存関係コンテナの統合機能
- 型安全な依存関係の解決
- 柔軟な依存関係の設定

## 始め方

`pubspec.yaml`に`shovel`を追加してください：

```yaml
dependencies:
  shovel: ^1.0.0
```

## 使用方法

基本的な使用例：

```dart
// クラスの定義
class UserService {
  final String apiKey;
  UserService({required this.apiKey});
}

class UserRepository {
  final UserService userService;
  UserRepository(this.userService);
}

// 依存性注入の設定
final ground = Ground()
  ..buryWithArg<UserService, String>((shovel, apiKey) => UserService(apiKey: apiKey))
  ..bury<UserRepository>((shovel) => UserRepository(
        shovel.digWithArg<UserService, String>('your-api-key'),
      ));

// インスタンスの取得
final shovel = ground.shovel();
final repository = shovel.dig<UserRepository>();
```

より詳細な例は`/example`フォルダをご覧ください。

## 追加情報

- Dart SDK 3.6.0以上が必要です
- バグ報告や機能リクエストはissueトラッカーをご利用ください
- コントリビューションを歓迎します！ 