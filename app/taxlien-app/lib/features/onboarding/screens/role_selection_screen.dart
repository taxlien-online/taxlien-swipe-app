import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/models/expert_role.dart';
import '../widgets/skip_button.dart';
import '../widgets/role_card.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: () => context.pop()),
        actions: [
          SkipButton(onSkip: () => context.go('/')),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Title
              Text(
                'Ваша специализация?',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                '(AI адаптирует фокус под ваш профиль)',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              // Role grid
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 1.2,
                  children: [
                    RoleCard(
                      role: ExpertRole.builder,
                      emoji: '👷',
                      title: 'Строитель',
                      subtitle: 'структура, крыша',
                      onTap: () => _selectRole(context, ExpertRole.builder),
                    ),
                    RoleCard(
                      role: ExpertRole.restorer,
                      emoji: '🛋️',
                      title: 'Мебель',
                      subtitle: 'интерьер, антиквариат',
                      onTap: () => _selectRole(context, ExpertRole.restorer),
                    ),
                    RoleCard(
                      role: ExpertRole.inventor,
                      emoji: '🚗',
                      title: 'Авто/Наука',
                      subtitle: 'гараж, история',
                      onTap: () => _selectRole(context, ExpertRole.inventor),
                    ),
                    RoleCard(
                      role: ExpertRole.businessman,
                      emoji: '💰',
                      title: 'Инвестор',
                      subtitle: 'ROI, риски',
                      onTap: () => _selectRole(context, ExpertRole.businessman),
                    ),
                    RoleCard(
                      role: ExpertRole.caregiver,
                      emoji: '🏠',
                      title: 'Для семьи',
                      subtitle: 'район, школы',
                      onTap: () => _selectRole(context, ExpertRole.caregiver),
                    ),
                  ],
                ),
              ),

              // Universal option
              OutlinedButton(
                onPressed: () => _selectRole(context, ExpertRole.guest),
                child: const Text('Универсальный профиль'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _selectRole(BuildContext context, ExpertRole role) {
    // TODO: Save role to provider
    context.push('/onboarding/geo');
  }
}
