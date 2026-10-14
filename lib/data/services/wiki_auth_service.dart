import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:wikimedia_oauth2/wikimedia_oauth2.dart';
import 'package:wiki_talk/oauth_config.dart';

class WikiAuthState {
  final bool isLoggedIn;
  final bool isLoading;
  final String? username;
  final String? errorMessage;

  const WikiAuthState({
    required this.isLoggedIn,
    this.isLoading = false,
    this.username,
    this.errorMessage,
  });

  WikiAuthState copyWith({
    bool? isLoggedIn,
    bool? isLoading,
    String? username,
    String? errorMessage,
  }) {
    return WikiAuthState(
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      isLoading: isLoading ?? this.isLoading,
      username: username ?? this.username,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

/// Authentication service interacting with Wikimedia OAuth 2.0.
class WikiAuthService {
  static final String clientId = OAuthConfig.clientId.isNotEmpty
      ? OAuthConfig.clientId
      : const String.fromEnvironment(
          'WIKIMEDIA_CLIENT_ID',
          defaultValue: '3c96e96e95240c93b3ed2eb653429795',
        );
  static final String redirectUrl = OAuthConfig.redirectUrl.isNotEmpty
      ? OAuthConfig.redirectUrl
      : const String.fromEnvironment(
          'WIKIMEDIA_REDIRECT_URL',
          defaultValue: 'https://sslaia.github.io/wikitalk/callback',
        );

  late final AuthService _oauth;

  WikiAuthService({String domain = 'id.wikipedia.org'}) {
    _oauth = AuthService(
      clientId: clientId,
      redirectUrl: redirectUrl,
      authorizationEndpoint: 'https://$domain/w/rest.php/oauth2/authorize',
      tokenEndpoint: 'https://$domain/w/rest.php/oauth2/access_token',
    );
  }

  Future<bool> isLoggedIn() => _oauth.isLoggedIn();

  Future<String?> getValidAccessToken() => _oauth.getValidAccessToken();

  Future<void> login(BuildContext context) => _oauth.login(context);

  Future<void> logout() => _oauth.logout();

  Future<String?> fetchCurrentUsername(String domain) async {
    final token = await getValidAccessToken();
    if (token == null || token.isEmpty) return null;

    final uri = Uri.https(domain, '/w/api.php', {
      'action': 'query',
      'meta': 'userinfo',
      'format': 'json',
      'formatversion': '2',
    });

    try {
      final res = await http.get(
        uri,
        headers: {
          'User-Agent': 'WikiTalk/1.0.0 (Wikimedia Community Discussion Tool)',
          'Authorization': 'Bearer $token',
        },
      ).timeout(const Duration(seconds: 10));

      if (res.statusCode == 200) {
        final data = json.decode(res.body) as Map<String, dynamic>;
        final userinfo = data['query']?['userinfo'] as Map<String, dynamic>?;
        if (userinfo != null) {
          final isAnon = userinfo['anon'] != null;
          final name = userinfo['name'] as String?;
          if (!isAnon && name != null && name.isNotEmpty) {
            return name;
          }
        }
      }
    } catch (_) {}

    return null;
  }
}
