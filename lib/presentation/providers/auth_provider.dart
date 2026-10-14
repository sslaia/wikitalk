import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/services/wiki_auth_service.dart';
import 'settings_provider.dart';

final authServiceProvider = Provider<WikiAuthService>((ref) {
  final target = ref.watch(settingsProvider).target;
  return WikiAuthService(domain: target.domain);
});

class AuthNotifier extends StateNotifier<WikiAuthState> {
  final WikiAuthService _authService;
  final String _domain;

  AuthNotifier(this._authService, this._domain)
      : super(const WikiAuthState(isLoggedIn: false, isLoading: true)) {
    checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    state = state.copyWith(isLoading: true);
    final loggedIn = await _authService.isLoggedIn();
    String? username;
    if (loggedIn) {
      username = await _authService.fetchCurrentUsername(_domain);
    }
    state = WikiAuthState(
      isLoggedIn: loggedIn,
      isLoading: false,
      username: username,
    );
  }

  Future<void> login(BuildContext context) async {
    state = state.copyWith(isLoading: true);
    try {
      await _authService.login(context);
    } finally {
      await checkLoginStatus();
    }
  }

  Future<void> logout() async {
    state = state.copyWith(isLoading: true);
    await _authService.logout();
    await checkLoginStatus();
  }

  Future<String?> getValidAccessToken() => _authService.getValidAccessToken();
}

final authProvider = StateNotifierProvider<AuthNotifier, WikiAuthState>((ref) {
  final authService = ref.watch(authServiceProvider);
  final domain = ref.watch(settingsProvider).target.domain;
  return AuthNotifier(authService, domain);
});
