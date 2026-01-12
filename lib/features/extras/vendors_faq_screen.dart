import 'package:flutter/material.dart';

class VendorsFaqScreen extends StatelessWidget {
  const VendorsFaqScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Resources'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'VENDORS'),
              Tab(text: 'FAQ'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _VendorsList(),
            _FaqList(),
          ],
        ),
      ),
    );
  }
}

class _VendorsList extends StatelessWidget {
  const _VendorsList();

  @override
  Widget build(BuildContext context) {
    // Mock Data
    final vendors = [
      {'name': 'EcoTank Solutions', 'phone': '+91 98765 43210', 'loc': 'Trivandrum'},
      {'name': 'RainHarvest Co.', 'phone': '+91 98765 12345', 'loc': 'Kochi'},
      {'name': 'Green Water Systems', 'phone': '+91 98765 67890', 'loc': 'Calicut'},
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: vendors.length,
      itemBuilder: (context, index) {
        final v = vendors[index];
        return Card(
          child: ListTile(
            leading: const Icon(Icons.business),
            title: Text(v['name']!),
            subtitle: Text(v['loc']!),
            trailing: IconButton(
              icon: const Icon(Icons.phone),
              onPressed: () {
                // Launch dialer
              },
            ),
          ),
        );
      },
    );
  }
}

class _FaqList extends StatelessWidget {
  const _FaqList();

  @override
  Widget build(BuildContext context) {
    final faqs = [
      {'q': 'How accurate is the measurement?', 'a': 'We use a dual-verification system (Satellite + AR) to ensure error margins are below 10%.'},
      {'q': 'Where do you get rainfall data?', 'a': 'We source historical rainfall norms from the Meteostat API based on your precise location.'},
      {'q': 'What is the "Runoff Coefficient"?', 'a': 'It is a factor (0.8 for concrete) that accounts for water loss due to evaporation and absorption.'},
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: faqs.length,
      itemBuilder: (context, index) {
        return ExpansionTile(
          title: Text(faqs[index]['q']!, style: const TextStyle(fontWeight: FontWeight.bold)),
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(faqs[index]['a']!),
            ),
          ],
        );
      },
    );
  }
}
