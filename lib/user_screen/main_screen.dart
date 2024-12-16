import 'package:flutter/material.dart';

class UserMainScreen extends StatefulWidget {
  String? serviceType;
  String? capacity;
  String? weight;
  String? instructions;
  UserMainScreen({super.key, required this.serviceType, required this.capacity, required this.weight, required this.instructions});

  @override
  State<UserMainScreen> createState() => _UserMainScreenState();
}

class _UserMainScreenState extends State<UserMainScreen> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}