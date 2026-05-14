import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../theme/colors.dart';
import 'package:intl/intl.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  final Map<String, List<String>> _dailyLogs = {};

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
  }

  Color _getColorForPhase(String phase) {
    switch (phase) {
      case 'Menstruação':
        return AppColors.primaryHighlight;
      case 'Fase Folicular':
        return AppColors.interactionHover;
      case 'Ovulação':
        return AppColors.secondaryCycle;
      case 'Fase Lútea':
        return AppColors.earthyHealth;
      default:
        return Colors.transparent;
    }
  }

  String _getPhaseForDay(DateTime date) {
    int dayIndex = date.day % 28;
    if (dayIndex >= 1 && dayIndex <= 5) return 'Menstruação';
    if (dayIndex >= 6 && dayIndex <= 13) return 'Fase Folicular';
    if (dayIndex >= 14 && dayIndex <= 16) return 'Ovulação';
    return 'Fase Lútea';
  }

  void _showLogDialog(BuildContext context, String logType) {
    final TextEditingController annotationController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Registro de $logType'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
                'Anotação para o dia ${DateFormat("dd/MM/yyyy").format(_selectedDay ?? DateTime.now())}:'),
            const SizedBox(height: 16),
            TextField(
              controller: annotationController,
              decoration: const InputDecoration(
                hintText: 'Digite suas observações...',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
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
              if (annotationController.text.isNotEmpty) {
                final dateKey = DateFormat('yyyy-MM-dd')
                    .format(_selectedDay ?? DateTime.now());
                setState(() {
                  if (!_dailyLogs.containsKey(dateKey)) {
                    _dailyLogs[dateKey] = [];
                  }
                  _dailyLogs[dateKey]!
                      .add('[$logType] ${annotationController.text}');
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('$logType registrado com sucesso!')),
                );
              }
              Navigator.pop(context);
            },
            child: const Text('Salvar'),
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
                'Meu Ciclo',
                style: Theme.of(context)
                    .textTheme
                    .displayLarge
                    ?.copyWith(fontSize: 24),
              ),
              const SizedBox(height: 24),

              // Resumo do Dia
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      AppColors.secondaryCycle,
                      AppColors.interactionHover
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      DateFormat("EEEE, d 'de' MMMM", "pt_BR")
                          .format(_selectedDay ?? DateTime.now()),
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _getPhaseForDay(_selectedDay ?? DateTime.now()),
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.lightbulb_outline,
                              color: Colors.white, size: 16),
                          SizedBox(width: 8),
                          Text(
                            'Dica: Mantenha-se hidratada hoje.',
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Calendário Menstrual
              Container(
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
                padding: const EdgeInsets.all(16),
                child: TableCalendar(
                  firstDay: DateTime.utc(2020, 1, 1),
                  lastDay: DateTime.utc(2030, 12, 31),
                  focusedDay: _focusedDay,
                  selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                    });
                  },
                  calendarBuilders: CalendarBuilders(
                    defaultBuilder: (context, day, focusedDay) {
                      final phase = _getPhaseForDay(day);
                      final color = _getColorForPhase(phase);
                      return Container(
                        margin: const EdgeInsets.all(4.0),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.3),
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          '${day.day}',
                          style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.bold),
                        ),
                      );
                    },
                  ),
                  calendarStyle: const CalendarStyle(
                    todayDecoration: BoxDecoration(
                      color: AppColors.interactionHover,
                      shape: BoxShape.circle,
                    ),
                    todayTextStyle: TextStyle(
                        color: AppColors.primaryHighlight,
                        fontWeight: FontWeight.bold),
                    selectedDecoration: BoxDecoration(
                      color: AppColors.primaryHighlight,
                      shape: BoxShape.circle,
                    ),
                    markerDecoration: BoxDecoration(
                      color: AppColors.earthyHealth,
                      shape: BoxShape.circle,
                    ),
                  ),
                  headerStyle: const HeaderStyle(
                    formatButtonVisible: false,
                    titleCentered: true,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Legenda
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _LegendItem(
                      color: _getColorForPhase('Menstruação'),
                      label: 'Menstruação'),
                  _LegendItem(
                      color: _getColorForPhase('Fase Folicular'),
                      label: 'Folicular'),
                  _LegendItem(
                      color: _getColorForPhase('Ovulação'), label: 'Ovulação'),
                  _LegendItem(
                      color: _getColorForPhase('Fase Lútea'), label: 'Lútea'),
                ],
              ),
              const SizedBox(height: 32),

              // Registros Diários
              Text(
                'Registros Diários',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontSize: 20),
              ),
              const SizedBox(height: 16),

              _LogCard(
                title: 'Sintomas e Humor',
                subtitle: 'Como você está se sentindo?',
                icon: Icons.mood,
                onTap: () => _showLogDialog(context, 'Sintomas e Humor'),
              ),
              const SizedBox(height: 16),
              _LogCard(
                title: 'Medicação',
                subtitle: 'Adicionar nova medicação ou confirmar uso',
                icon: Icons.medication,
                isActive: true,
                onTap: () => _showLogDialog(context, 'Medicação'),
              ),
              const SizedBox(height: 32),
              Text(
                'Consultar Registros do Dia',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontSize: 20),
              ),
              const SizedBox(height: 16),
              ...(_dailyLogs[DateFormat('yyyy-MM-dd')
                          .format(_selectedDay ?? DateTime.now())] ??
                      [])
                  .asMap()
                  .entries
                  .map((entry) {
                final index = entry.key;
                final log = entry.value;
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.cardBackground,
                    borderRadius: BorderRadius.circular(16.0),
                    border: Border.all(color: AppColors.interactionHover),
                  ),
                  child: Row(
                    children: [
                      Expanded(child: Text(log, style: const TextStyle(fontSize: 14))),
                      IconButton(
                        icon: const Icon(Icons.delete_outline, color: AppColors.primaryHighlight),
                        onPressed: () {
                          setState(() {
                            final dateKey = DateFormat('yyyy-MM-dd')
                                .format(_selectedDay ?? DateTime.now());
                            _dailyLogs[dateKey]?.removeAt(index);
                          });
                        },
                      ),
                    ],
                  ),
                );
              }),
              if ((_dailyLogs[DateFormat('yyyy-MM-dd')
                          .format(_selectedDay ?? DateTime.now())] ??
                      [])
                  .isEmpty)
                const Text('Nenhum registro adicionado para este dia.',
                    style: TextStyle(color: Colors.grey)),
            ],
          ),
        ),
      ),
    );
  }
}

class _LogCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool isActive;
  final VoidCallback onTap;

  const _LogCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    this.isActive = false,
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
                color: isActive
                    ? AppColors.primaryHighlight
                    : AppColors.interactionHover,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: isActive ? Colors.white : AppColors.primaryHighlight,
                size: 24,
              ),
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
                    subtitle,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(fontSize: 14),
                  ),
                ],
              ),
            ),
            Icon(Icons.add_circle_outline,
                color: AppColors.textSecondary.withOpacity(0.5)),
          ],
        ),
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendItem({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 10)),
      ],
    );
  }
}
