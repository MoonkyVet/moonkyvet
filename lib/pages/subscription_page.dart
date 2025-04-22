import 'package:flutter/material.dart';

class SubscriptionPage extends StatelessWidget {
  const SubscriptionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Subscription'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Subscribe to unlock Moonky AI Chat 🧠🐶',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // TODO: Add payment logic here
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Subscription activated!')),
                );
              },
              child: const Text('Subscribe - 10 RON / month'),
            ),
          ],
        ),
      ),
    );
  }
}
