import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:taxlien_swipe_app/features/auth/auth_provider.dart';
import 'package:taxlien_swipe_app/features/auth/auth_state.dart';

/// Optional OAuth step (sdd-taxlien-swipe-app-oauth).
/// Google/Facebook sign-in via AuthProvider; Skip goes to Ready without auth.
class OAuthScreen extends StatelessWidget {
  const OAuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.read<AuthProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Вход'),
        leading: BackButton(onPressed: () => context.pop()),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 24),
              Text(
                'Войдите для облака',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                'Синхронизация между устройствами, общий список с семьёй и доступ с любого устройства.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
              ),
              const Spacer(),
              FilledButton.icon(
                onPressed: () => _signInWithGoogle(context, auth),
                icon: const Icon(Icons.login),
                label: const Text('Войти через Google'),
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: () => _signInWithFacebook(context, auth),
                icon: const Icon(Icons.facebook),
                label: const Text('Войти через Facebook'),
              ),
              const SizedBox(height: 24),
              TextButton(
                onPressed: () {
                  final returnTo = GoRouterState.of(context).uri.queryParameters['returnTo'];
                  if (returnTo == 'profile') {
                    context.pop();
                  } else {
                    context.pushReplacement('/onboarding/ready');
                  }
                },
                child: const Text('Пропустить'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _signInWithGoogle(BuildContext context, AuthProvider auth) async {
    final result = await auth.signInWithGoogle();
    if (!context.mounted) return;
    _handleAuthResult(context, result);
  }

  Future<void> _signInWithFacebook(
      BuildContext context, AuthProvider auth) async {
    final result = await auth.signInWithFacebook();
    if (!context.mounted) return;
    _handleAuthResult(context, result);
  }

  void _handleAuthResult(BuildContext context, AuthResult result) {
    switch (result) {
      case AuthResult.success:
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Успешно')),
          );
          final returnTo = GoRouterState.of(context).uri.queryParameters['returnTo'];
          if (returnTo == 'profile') {
            context.pop();
          } else {
            context.pushReplacement('/onboarding/ready');
          }
        }
        break;
      case AuthResult.cancelled:
      case AuthResult.requiresRecentLogin:
        break;
      case AuthResult.error:
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Ошибка входа. Попробуйте снова.'),
            ),
          );
        }
        break;
    }
  }
}

