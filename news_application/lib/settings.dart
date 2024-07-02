import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key});

  @override
    State<StatefulWidget> createState() => _SettingsPageState();
}

  class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar (
        title : const Text('Settings'),
      ),
    );
  }

  }
