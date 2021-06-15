import 'package:flutter/material.dart';
import 'package:flutter_frontend/domain/profile/profile.dart';

class ItemElementWidget extends StatelessWidget {

  final String name;
  final String description;
  final List<Profile> profiles;

  const ItemElementWidget({
    required this.name,
    required this.description,
    required this.profiles,
  });

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
