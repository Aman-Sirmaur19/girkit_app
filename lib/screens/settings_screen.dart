import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.wifi_rounded),
              label: const Text('Connect to Wi-Fi'),
            ),
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(CupertinoIcons.cloud_upload),
              label: const Text('Upload data to cloud'),
            ),
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.share_outlined),
              label: const Text('Share data'),
            ),
          ],
        ),
      ),
    );
  }
}
