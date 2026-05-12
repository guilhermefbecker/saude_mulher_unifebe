import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'providers/user_provider.dart';
import 'theme/theme.dart';
import 'screens/onboarding/onboarding_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('pt_BR', null);
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: const MinhaSaudeFemininaApp(),
    ),
  );
}

class MinhaSaudeFemininaApp extends StatelessWidget {
  const MinhaSaudeFemininaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Minha Saúde Feminina',
      theme: AppTheme.theme,
      debugShowCheckedModeBanner: false,
      home: const OnboardingScreen(),
    );
  }
}
