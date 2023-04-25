import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:touristic_wallet/provider/amounts_provider.dart';
import 'package:touristic_wallet/provider/exchange_rates_provider.dart';
import 'package:touristic_wallet/view/home/amount_dialog.dart';
import 'package:touristic_wallet/view/home/home_page.dart';
import 'package:touristic_wallet/view/statistics/statistics_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final amountsProvider = AmountsProvider();
  await amountsProvider.loadAmountsFromStorage();

  final exchangeRatesProvider = ExchangeRatesProvider();
  await exchangeRatesProvider.initDatabase();

  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(create: (_) => exchangeRatesProvider),
      ChangeNotifierProvider(create: (_) => amountsProvider),
    ], child: const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Touristic Wallet',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
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
        title: const Text('My Touristic Wallet'),
      ),
      body: selectedPageIndex == 0 ? const HomePage() : const StatisticsPage(),
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
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pie_chart),
            label: 'Statistics',
          ),
        ],
        onTap: (int index) {
          setState(() {
            selectedPageIndex = index;
          });
        },
        currentIndex: selectedPageIndex,
      ),
    );
  }
}
