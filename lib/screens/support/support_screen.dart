import 'package:flutter/material.dart';
import '../../theme/colors.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  void _showInfoDialog(BuildContext context, String title, String description) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content:
            Text('$description\n\n(Conteúdo detalhado será carregado aqui)'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Apoio e Trilhas',
                style: Theme.of(context)
                    .textTheme
                    .displayLarge
                    ?.copyWith(fontSize: 24),
              ),
              const SizedBox(height: 24),

              // Trilhas de Aprendizado
              Text(
                'Trilhas de Aprendizado',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontSize: 20),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 200,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _PathCard(
                      title: 'Trilha da Gestante',
                      subtitle: 'O que esperar em cada trimestre.',
                      color: AppColors.earthyHealth,
                      icon: Icons.pregnant_woman,
                      progress: 0.3,
                      onTap: () => _showInfoDialog(
                          context,
                          'Trilha da Gestante',
                          'O que esperar em cada trimestre.'),
                    ),
                    const SizedBox(width: 16),
                    _PathCard(
                      title: 'Conhecendo meu Ciclo',
                      subtitle: 'Do primeiro dia à próxima fase.',
                      color: AppColors.primaryHighlight,
                      icon: Icons.water_drop,
                      progress: 0.8,
                      onTap: () => _showInfoDialog(
                          context,
                          'Conhecendo meu Ciclo',
                          'Do primeiro dia à próxima fase.'),
                    ),
                    const SizedBox(width: 16),
                    _PathCard(
                      title: 'Menopausa com Saúde',
                      subtitle: 'Cuidados e bem-estar.',
                      color: AppColors.secondaryCycle,
                      icon: Icons.spa,
                      progress: 0.0,
                      onTap: () => _showInfoDialog(context,
                          'Menopausa com Saúde', 'Cuidados e bem-estar.'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Rede de Cuidado
              Text(
                'Rede de Cuidado (Emergência)',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontSize: 20),
              ),
              const SizedBox(height: 16),

              _ContactCard(
                title: 'Disque Saúde',
                number: '136',
                description: 'Ouvidoria Geral do SUS',
                icon: Icons.health_and_safety,
                color: AppColors.primaryHighlight,
                onTap: () => _showInfoDialog(
                    context, 'Disque Saúde', 'Ouvidoria Geral do SUS (136)'),
              ),
              const SizedBox(height: 16),
              _ContactCard(
                title: 'CVV - Valorização da Vida',
                number: '188',
                description: 'Apoio emocional e prevenção do suicídio',
                icon: Icons.favorite,
                color: AppColors.secondaryCycle,
                onTap: () => _showInfoDialog(
                    context,
                    'CVV - Valorização da Vida',
                    'Apoio emocional e prevenção do suicídio (188)'),
              ),
              const SizedBox(height: 16),
              _ContactCard(
                title: 'Central de Atendimento à Mulher',
                number: '180',
                description: 'Apoio à violência contra a mulher',
                icon: Icons.shield,
                color: AppColors.earthyHealth,
                onTap: () => _showInfoDialog(
                    context,
                    'Central de Atendimento à Mulher',
                    'Apoio à violência contra a mulher (180)'),
              ),
              const SizedBox(height: 16),
              _ContactCard(
                title: 'Encontrar UBS mais próxima',
                number: '',
                description: 'Unidade Básica de Saúde',
                icon: Icons.local_hospital,
                color: Colors.blueAccent,
                isMap: true,
                onTap: () => _showInfoDialog(context,
                    'Encontrar UBS mais próxima', 'Unidade Básica de Saúde'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PathCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color color;
  final IconData icon;
  final double progress;
  final VoidCallback onTap;

  const _PathCard({
    required this.title,
    required this.subtitle,
    required this.color,
    required this.icon,
    required this.progress,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 260,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(24.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: color, size: 28),
                ),
                const Spacer(),
                Icon(Icons.arrow_forward_ios,
                    color: AppColors.textSecondary.withOpacity(0.5), size: 16),
              ],
            ),
            const Spacer(),
            Text(
              title,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontSize: 18),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(fontSize: 14),
            ),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: progress,
              backgroundColor: AppColors.interactionHover,
              valueColor: AlwaysStoppedAnimation<Color>(color),
              borderRadius: BorderRadius.circular(8.0),
              minHeight: 6,
            ),
          ],
        ),
      ),
    );
  }
}

class _ContactCard extends StatelessWidget {
  final String title;
  final String number;
  final String description;
  final IconData icon;
  final Color color;
  final bool isMap;
  final VoidCallback onTap;

  const _ContactCard({
    required this.title,
    required this.number,
    required this.description,
    required this.icon,
    required this.color,
    this.isMap = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(24.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(fontSize: 16),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(fontSize: 12),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color:
                    isMap ? color.withOpacity(0.1) : AppColors.primaryHighlight,
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(isMap ? Icons.map : Icons.phone,
                      color: isMap ? color : Colors.white, size: 16),
                  if (!isMap) ...[
                    const SizedBox(width: 8),
                    Text(
                      number,
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
