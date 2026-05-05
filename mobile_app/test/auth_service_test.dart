import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';

import 'package:cesizen/services/auth_service.dart';

class FakeSecureStorage extends FlutterSecureStorage {
  final Map<String, String?> _data = {};

  @override
  Future<void> write({
    required String key,
    required String? value,
    AndroidOptions? aOptions,
    AppleOptions? iOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    AppleOptions? mOptions,
    WindowsOptions? wOptions,
  }) async {
    if (value != null) _data[key] = value;
  }

  @override
  Future<String?> read({
    required String key,
    AndroidOptions? aOptions,
    AppleOptions? iOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    AppleOptions? mOptions,
    WindowsOptions? wOptions,
  }) async => _data[key];

  @override
  Future<void> delete({
    required String key,
    AndroidOptions? aOptions,
    AppleOptions? iOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    AppleOptions? mOptions,
    WindowsOptions? wOptions,
  }) async => _data.remove(key);
}

void main() {
  late FakeSecureStorage fakeStorage;

  setUp(() {
    fakeStorage = FakeSecureStorage();
  });

  group('AuthService - Tests Unitaires login()', () {
    test('retourne true si le serveur répond 200 avec un token', () async {
      final mockClient = MockClient((request) async {
        expect(request.url.path, contains('/auth/login'));
        return http.Response(
          jsonEncode({
            'token': 'fake_jwt_token',
            'user': {'id': 1, 'pseudo': 'TestUser'},
          }),
          200,
          headers: {'content-type': 'application/json'},
        );
      });

      final authService = AuthService(client: mockClient, storage: fakeStorage);
      final result = await authService.login('test@test.com', 'password123');

      expect(result, true);
    });

    test('retourne false si le serveur répond 401', () async {
      final mockClient = MockClient((request) async {
        return http.Response('{"error": "Unauthorized"}', 401);
      });

      final authService = AuthService(client: mockClient, storage: fakeStorage);
      final result = await authService.login('test@test.com', 'mauvais_mdp');

      expect(result, false);
    });

    test('retourne false en cas d\'erreur réseau', () async {
      final mockClient = MockClient((request) async {
        throw Exception('Pas de réseau');
      });

      final authService = AuthService(client: mockClient, storage: fakeStorage);
      final result = await authService.login('test@test.com', 'password123');

      expect(result, false);
    });

    // vérifie que le token est bien sauvegardé après login
    test('sauvegarde le token et le pseudo après un login réussi', () async {
      final mockClient = MockClient((request) async {
        return http.Response(
          jsonEncode({
            'token': 'mon_vrai_token',
            'user': {'id': 42, 'pseudo': 'Robin'},
          }),
          200,
          headers: {'content-type': 'application/json'},
        );
      });

      final authService = AuthService(client: mockClient, storage: fakeStorage);
      await authService.login('test@test.com', 'password123');

      // On vérifie ce que le service a réellement stocké
      expect(await authService.getToken(), 'mon_vrai_token');
      expect(await authService.getPseudo(), 'Robin');
    });
  });

  group('AuthService - Tests Unitaires register()', () {
    test('retourne null si la création réussit (201)', () async {
      final mockClient = MockClient((request) async {
        return http.Response('{"message": "Créé"}', 201);
      });

      final authService = AuthService(client: mockClient, storage: fakeStorage);
      final result = await authService.register(
        'UserTest',
        'user@test.com',
        'Pass123!',
      );

      expect(result, isNull);
    });

    test('retourne un message d\'erreur si email déjà utilisé (409)', () async {
      final mockClient = MockClient((request) async {
        return http.Response('Email déjà utilisé', 409);
      });

      final authService = AuthService(client: mockClient, storage: fakeStorage);
      final result = await authService.register(
        'User',
        'deja@pris.com',
        'Pass123!',
      );

      expect(result, isNotNull);
      expect(result, contains('409'));
    });

    test(
      'retourne une erreur de connexion si le serveur est injoignable',
      () async {
        final mockClient = MockClient((request) async {
          throw Exception('Serveur injoignable');
        });

        final authService = AuthService(
          client: mockClient,
          storage: fakeStorage,
        );
        final result = await authService.register(
          'User',
          'user@test.com',
          'Pass123!',
        );

        expect(result, contains('Erreur de connexion'));
      },
    );
  });
}
