import 'package:flutter/material.dart';
import 'ResponsiveLayout/ResponsiveLayoutGeneretion.dart';
import 'ResponsiveLayout/Mobile/ResponsiveLayoutMobile.dart';

class TelaInicial extends StatefulWidget {
  const TelaInicial({super.key});

  @override
  State<TelaInicial> createState() => _TelaInicialState();
}

class _TelaInicialState extends State<TelaInicial> {
  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(mobile: const MobileNavigation());
  }
}
