import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(PasadaApps());
}

class PasadaApps extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pasada Apps',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ProfileScreen(),
    );
  }
}

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final DatabaseReference _walletRef =
  FirebaseDatabase.instance.reference().child('users');
  late double _balance;

  @override
  void initState() {
    super.initState();
    _balance = 1000.0;

  }

  void _addToBalance(double amount) {
    setState(() {
      _balance += amount;
    });
    _walletRef.set(_balance);
  }

  void _subtractFromBalance(double amount) {
    setState(() {
      _balance -= amount;
    });
    _walletRef.set(_balance);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text(
            "Profile Screen",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          elevation: 0.0,
        ),
        body: EWalletHomePage(balance: _balance, addToBalance: _addToBalance, subtractFromBalance: _subtractFromBalance),
      ),
    );
  }
}

class EWalletHomePage extends StatelessWidget {
  final double balance;
  final Function(double) addToBalance;
  final Function(double) subtractFromBalance;

  const EWalletHomePage({
    Key? key,
    required this.balance,
    required this.addToBalance,
    required this.subtractFromBalance,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Balance: \$${balance.toStringAsFixed(2)}',
            style: TextStyle(fontSize: 24.0),
          ),
          SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: () => addToBalance(100.0),
            child: Text('Add \$100'),
          ),
          SizedBox(height: 8.0),
          ElevatedButton(
            onPressed: () => subtractFromBalance(100.0),
            child: Text('Subtract \$100'),
          ),
        ],
      ),
    );
  }
}
