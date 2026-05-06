import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'data/air_api.dart';
import 'data/air_repository.dart';
import 'viewmodels/air_vm.dart';
import 'views/home_page.dart';

void main() {
  runApp(const AirCheckApp());
}

class AirCheckApp extends StatelessWidget {
  const AirCheckApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AirVm(
        repository: AirRepository(
          api: AirApi(),
        ),
      )..loadData(),
      child: MaterialApp(
        title: 'AirCheck Galicia',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
          useMaterial3: true,
        ),
        home: const HomePage(),
      ),
    );
  }
}