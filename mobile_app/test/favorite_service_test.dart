import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'dart:convert';

import 'package:cesizen/services/favorite_service.dart';

void main() {
  group('FavoriteService - checkIsFavorite()', () {
    test('retourne true si l\'API dit isFavorite: true', () async {
      final mockClient = MockClient((request) async {
        // Vérifie que les bons paramètres sont envoyés
        expect(request.url.queryParameters['id_utilisateur'], '1');
        expect(request.url.queryParameters['id_activity'], '42');
        expect(request.url.path, contains('/favorite/check'));

        return http.Response(
          jsonEncode({'isFavorite': true}),
          200,
          headers: {'content-type': 'application/json'},
        );
      });

      final service = FavoriteService(client: mockClient);
      final result = await service.checkIsFavorite(1, 42);

      expect(result, true);
    });

    test('retourne false si l\'API dit isFavorite: false', () async {
      final mockClient = MockClient((request) async {
        return http.Response(
          jsonEncode({'isFavorite': false}),
          200,
          headers: {'content-type': 'application/json'},
        );
      });

      final service = FavoriteService(client: mockClient);
      final result = await service.checkIsFavorite(1, 42);

      expect(result, false);
    });

    test('retourne false si l\'API répond autre chose que 200', () async {
      final mockClient = MockClient((request) async {
        return http.Response('Unauthorized', 401);
      });

      final service = FavoriteService(client: mockClient);
      final result = await service.checkIsFavorite(1, 42);

      expect(result, false);
    });

    // Non-régression : pas de crash si champ isFavorite absent
    test(
      'retourne false si le champ isFavorite est absent de la réponse',
      () async {
        final mockClient = MockClient((request) async {
          return http.Response(
            jsonEncode({'data': 'quelque chose'}), // isFavorite manquant
            200,
            headers: {'content-type': 'application/json'},
          );
        });

        final service = FavoriteService(client: mockClient);
        final result = await service.checkIsFavorite(1, 42);

        expect(result, false);
      },
    );

    test('retourne false en cas d\'erreur réseau (sans crash)', () async {
      final mockClient = MockClient((request) async {
        throw Exception('Pas de réseau');
      });

      final service = FavoriteService(client: mockClient);
      final result = await service.checkIsFavorite(1, 42);

      expect(result, false);
    });
  });

  group('FavoriteService - toggleFavorite()', () {
    test('retourne true après avoir ajouté aux favoris', () async {
      final mockClient = MockClient((request) async {
        expect(request.url.path, contains('/favorite/toggle'));

        // Vérifie que le body contient les bons IDs
        final body = jsonDecode(request.body);
        expect(body['id_utilisateur'], 1);
        expect(body['id_activity'], 42);

        return http.Response(
          jsonEncode({'isFavorite': true, 'message': 'Ajouté aux favoris'}),
          200,
          headers: {'content-type': 'application/json'},
        );
      });

      final service = FavoriteService(client: mockClient);
      final result = await service.toggleFavorite(1, 42);

      expect(result, true);
    });

    test('retourne false après avoir retiré des favoris', () async {
      final mockClient = MockClient((request) async {
        return http.Response(
          jsonEncode({'isFavorite': false, 'message': 'Retiré des favoris'}),
          200,
          headers: {'content-type': 'application/json'},
        );
      });

      final service = FavoriteService(client: mockClient);
      final result = await service.toggleFavorite(1, 42);

      expect(result, false);
    });

    test('retourne false si le serveur répond 500', () async {
      final mockClient = MockClient((request) async {
        return http.Response('Internal Server Error', 500);
      });

      final service = FavoriteService(client: mockClient);
      final result = await service.toggleFavorite(1, 42);

      expect(result, false);
    });

    test('retourne false en cas d\'erreur réseau (sans crash)', () async {
      final mockClient = MockClient((request) async {
        throw Exception('Timeout');
      });

      final service = FavoriteService(client: mockClient);
      final result = await service.toggleFavorite(1, 42);

      expect(result, false);
    });
  });
}
