import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';
import '../../theme/colors.dart';
import '../main_layout.dart';

class ProfileSelectorScreen extends StatelessWidget {
  const ProfileSelectorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(''),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Qual é o seu\nmomento atual?',
                style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 28),
              ),
              const SizedBox(height: 16),
              Text(
                'Isso nos ajuda a personalizar seu conteúdo',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 32),
              Expanded(
                child: ListView(
                  children: [
                    _ProfileCard(
                      title: 'Adolescente',
                      subtitle: 'Conhecendo meu corpo e ciclo',
                      icon: Icons.face,
                      profileType: UserProfileType.adolescente,
                    ),
                    const SizedBox(height: 16),
                    _ProfileCard(
                      title: 'Gestante',
                      subtitle: 'Acompanhando minha gravidez',
                      icon: Icons.pregnant_woman,
                      profileType: UserProfileType.gestante,
                    ),
                    const SizedBox(height: 16),
                    _ProfileCard(
                      title: 'Tentante',
                      subtitle: 'Planejando uma gravidez',
                      icon: Icons.child_care,
                      profileType: UserProfileType.tentante,
                    ),
                    const SizedBox(height: 16),
                    _ProfileCard(
                      title: 'Menopausa',
                      subtitle: 'Navegando por novas fases',
                      icon: Icons.spa,
                      profileType: UserProfileType.menopausa,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final UserProfileType profileType;

  const _ProfileCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.profileType,
  });

  @override
  Widget build(BuildContext context) {
    final currentProfile = context.watch<UserProvider>().profile;
    final isSelected = currentProfile == profileType;

    return GestureDetector(
      onTap: () {
        context.read<UserProvider>().updateProfile(profileType);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainLayout()),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? AppColors.interactionHover : AppColors.cardBackground,
          borderRadius: BorderRadius.circular(24.0),
          border: Border.all(
            color: isSelected ? AppColors.primaryHighlight : Colors.transparent,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primaryHighlight : AppColors.interactionHover,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: isSelected ? Colors.white : AppColors.primaryHighlight,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 18),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: AppColors.textSecondary.withOpacity(0.5),
            ),
          ],
        ),
      ),
    );
  }
}
