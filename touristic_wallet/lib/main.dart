import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:touristic_wallet/provider/amounts_provider.dart';
import 'package:touristic_wallet/provider/currencies_provider.dart';
import 'package:touristic_wallet/provider/exchange_rates_provider.dart';
import 'package:touristic_wallet/theme.dart';
import 'package:touristic_wallet/view/common/total_amount_indicator.dart';
import 'package:touristic_wallet/view/home/amount_dialog.dart';
import 'package:touristic_wallet/view/home/home_page.dart';
import 'package:touristic_wallet/view/statistics/statistics_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final currenciesProvider = CurrenciesProvider();
  await currenciesProvider.initDatabase();

  final amountsProvider = AmountsProvider();
  await amountsProvider.loadAmountsFromStorage();

  final exchangeRatesProvider = ExchangeRatesProvider();
  await exchangeRatesProvider.initDatabase();

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.transparent,
    ),
  );

  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(create: (_) => exchangeRatesProvider),
      ChangeNotifierProvider(create: (_) => amountsProvider),
      ChangeNotifierProvider(create: (_) => currenciesProvider),
    ], child: const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Touristic Wallet',
      theme: lightCustomTheme,
      darkTheme: darkCustomTheme,
      themeMode: ThemeMode.system,
      home: const MyAppPage(),
    );
  }
}

class MyAppPage extends StatefulWidget {
  const MyAppPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return MyAppPageState();
  }
}

class MyAppPageState extends State<MyAppPage> {
  int selectedPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('My Touristic Wallet'),
      ),
      body: Column(children: [
        const TotalAmountIndicator(),
        Expanded(
            child: selectedPageIndex == 0
                ? const HomePage()
                : const StatisticsPage())
      ]),
      floatingActionButton: selectedPageIndex == 0
          ? FloatingActionButton(
              onPressed: () {
                showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) => const AmountDialog());
              },
              child: const Icon(Icons.add),
            )
          : null,
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            selectedPageIndex = index;
          });
        },
        selectedIndex: selectedPageIndex,
        destinations: const <NavigationDestination>[
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.leaderboard_outlined),
            selectedIcon: Icon(Icons.leaderboard),
            label: 'Statistics',
          ),
        ],
      ),
    );
  }
}
