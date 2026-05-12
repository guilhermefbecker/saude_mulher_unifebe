import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';
import '../../theme/colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Set<String> _favorites = {};

  void _toggleFavorite(String category) {
    setState(() {
      if (_favorites.contains(category)) {
        _favorites.remove(category);
      } else {
        _favorites.add(category);
      }
    });
  }

  IconData _getIconForCategory(String category) {
    switch (category) {
      case 'Saúde Menstrual': return Icons.water_drop;
      case 'Gestação': return Icons.pregnant_woman;
      case 'Saúde Mental': return Icons.psychology;
      case 'Pré-natal': return Icons.health_and_safety;
      case 'Câncer de Mama': return Icons.volunteer_activism;
      case 'Menopausa': return Icons.spa;
      default: return Icons.category;
    }
  }

  void _showCategoryInfo(BuildContext context, String title) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text('Aqui estão as informações detalhadas sobre $title. Estas informações são personalizadas para o seu momento.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fechar', style: TextStyle(color: AppColors.primaryHighlight)),
          ),
        ],
      ),
    );
  }

  void _showProfileEditDialog(BuildContext context, UserProvider userProvider) {
    final nameController = TextEditingController(text: userProvider.name);
    UserProfileType selectedProfile = userProvider.profile;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Editar Perfil'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: 'Nome'),
                  ),
                  const SizedBox(height: 16),
                  DropdownButton<UserProfileType>(
                    value: selectedProfile,
                    isExpanded: true,
                    items: UserProfileType.values.map((profile) {
                      return DropdownMenuItem(
                        value: profile,
                        child: Text(profile.toString().split('.').last.toUpperCase()),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => selectedProfile = val);
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancelar'),
                ),
                ElevatedButton(
                  onPressed: () {
                    userProvider.updateUserInfo(name: nameController.text);
                    userProvider.updateProfile(selectedProfile);
                    Navigator.pop(context);
                  },
                  child: const Text('Salvar'),
                ),
              ],
            );
          }
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();
    
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header & Search
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Olá, ${userProvider.name.isEmpty ? "Amiga" : userProvider.name}',
                        style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 24),
                      ),
                      Text(
                        'Modo: ${userProvider.getProfileName()}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.secondaryCycle,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () => _showProfileEditDialog(context, userProvider),
                    child: const CircleAvatar(
                      backgroundColor: AppColors.interactionHover,
                      child: Icon(Icons.person, color: AppColors.primaryHighlight),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Buscar artigos, dicas...',
                  prefixIcon: const Icon(Icons.search, color: AppColors.primaryHighlight),
                  fillColor: AppColors.cardBackground,
                  filled: true,
                ),
              ),
              const SizedBox(height: 24),

              // Motivational Card
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.interactionHover,
                  borderRadius: BorderRadius.circular(24.0),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.format_quote, color: AppColors.primaryHighlight, size: 40),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        '"Cuide do seu corpo, é o único lugar que você tem para viver."',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppColors.primaryHighlight,
                          fontWeight: FontWeight.w600,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Dynamic Carousel
              Text(
                'Para o seu momento',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 20),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 160,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _CarouselCard(
                      title: 'Dica do Dia',
                      subtitle: 'Como melhorar o sono',
                      color: AppColors.secondaryCycle,
                      icon: Icons.nights_stay,
                      onTap: () => _showCategoryInfo(context, 'Dica do Dia: Como melhorar o sono'),
                    ),
                    const SizedBox(width: 16),
                    _CarouselCard(
                      title: 'Alimentação',
                      subtitle: 'Alimentos para a fase lútea',
                      color: AppColors.earthyHealth,
                      icon: Icons.restaurant,
                      onTap: () => _showCategoryInfo(context, 'Alimentação: Alimentos para a fase lútea'),
                    ),
                    const SizedBox(width: 16),
                    _CarouselCard(
                      title: 'Exercício',
                      subtitle: 'Yoga suave',
                      color: AppColors.primaryHighlight,
                      icon: Icons.self_improvement,
                      onTap: () => _showCategoryInfo(context, 'Exercício: Yoga suave'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Favoritos Grid
              if (_favorites.isNotEmpty) ...[
                Text(
                  'Meus Favoritos',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 20),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 140,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _favorites.length,
                    itemBuilder: (context, index) {
                      final cat = _favorites.elementAt(index);
                      return Padding(
                        padding: const EdgeInsets.only(right: 16),
                        child: SizedBox(
                          width: 160,
                          child: _CategoryCard(
                            cat,
                            _getIconForCategory(cat),
                            true,
                            () => _toggleFavorite(cat),
                            () => _showCategoryInfo(context, cat),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 32),
              ],

              // Categories Grid
              Text(
                'Categorias',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 20),
              ),
              const SizedBox(height: 16),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 1.2,
                children: [
                  _CategoryCard('Saúde Menstrual', Icons.water_drop, _favorites.contains('Saúde Menstrual'), () => _toggleFavorite('Saúde Menstrual'), () => _showCategoryInfo(context, 'Saúde Menstrual')),
                  _CategoryCard('Gestação', Icons.pregnant_woman, _favorites.contains('Gestação'), () => _toggleFavorite('Gestação'), () => _showCategoryInfo(context, 'Gestação')),
                  _CategoryCard('Saúde Mental', Icons.psychology, _favorites.contains('Saúde Mental'), () => _toggleFavorite('Saúde Mental'), () => _showCategoryInfo(context, 'Saúde Mental')),
                  _CategoryCard('Pré-natal', Icons.health_and_safety, _favorites.contains('Pré-natal'), () => _toggleFavorite('Pré-natal'), () => _showCategoryInfo(context, 'Pré-natal')),
                  _CategoryCard('Câncer de Mama', Icons.volunteer_activism, _favorites.contains('Câncer de Mama'), () => _toggleFavorite('Câncer de Mama'), () => _showCategoryInfo(context, 'Câncer de Mama')),
                  _CategoryCard('Menopausa', Icons.spa, _favorites.contains('Menopausa'), () => _toggleFavorite('Menopausa'), () => _showCategoryInfo(context, 'Menopausa')),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CarouselCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color color;
  final IconData icon;
  final VoidCallback onTap;

  const _CarouselCard({
    required this.title,
    required this.subtitle,
    required this.color,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
      width: 240,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(24.0),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white, size: 32),
          const Spacer(),
          Text(
            title,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 14),
          ),
        ],
      ),
    ),
   );
  }
}

class _CategoryCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isFavorite;
  final VoidCallback onFavoriteTap;
  final VoidCallback onCardTap;

  const _CategoryCard(this.title, this.icon, this.isFavorite, this.onFavoriteTap, this.onCardTap);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onCardTap,
      child: Container(
        padding: const EdgeInsets.all(16),
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: AppColors.interactionHover,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: AppColors.primaryHighlight, size: 24),
              ),
              GestureDetector(
                onTap: onFavoriteTap,
                child: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? AppColors.primaryHighlight : AppColors.textSecondary,
                  size: 24,
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 14),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    ),
   );
  }
}
