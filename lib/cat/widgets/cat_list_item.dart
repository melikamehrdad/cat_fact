import 'package:cat_trivia/cat/models/cat.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CatListItem extends StatelessWidget {
  const CatListItem({super.key, required this.cat});

  final Cat cat;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.network(cat.image, width: 70, fit: BoxFit.cover),
      title: Text(cat.text),
      isThreeLine: true,
      subtitle: Text(DateFormat('dd/MM/yyyy hh:mm:ss').format(cat.createdAt)),
      dense: false,
    );
  }
}