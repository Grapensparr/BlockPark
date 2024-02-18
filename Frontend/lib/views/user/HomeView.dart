import 'package:flutter/material.dart';
import 'package:blockpark/widgets/appBar/Header.dart';
import 'package:blockpark/controllers/FetchController.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late Future<Map<String, int>> statusCounts;

  @override
  void initState() {
    super.initState();
    statusCounts = FetchController.fetchStatusCounts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const Header(),
      body: FutureBuilder<Map<String, int>>(
        future: statusCounts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final data = snapshot.data!;
            final screenWidth = MediaQuery.of(context).size.width;
            return screenWidth < 850
                ? _buildStatusListOnePerRow(data)
                : _buildStatusListOneRow(data);
          }
        },
      ),
    );
  }

  Widget _buildStatusListOnePerRow(Map<String, int> data) {
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 16),
          _buildStatusBox('Available parking spaces', data['available'] ?? 0),
          _buildStatusBox('Current rentals', data['rented'] ?? 0),
          _buildStatusBox('Completed rentals', data['rentingComplete'] ?? 0),
        ],
      ),
    );
  }

  Widget _buildStatusListOneRow(Map<String, int> data) {
    return Column(
      children: [
        const SizedBox(height: 100),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildStatusBox('Available parking spaces', data['available'] ?? 0),
            _buildStatusBox('Current rentals', data['rented'] ?? 0),
            _buildStatusBox('Completed rentals', data['rentingComplete'] ?? 0),
          ],
        ),
      ],
    );
  }

  Widget _buildStatusBox(String status, int count) {
    return SizedBox(
      height: 250,
      width: 250,
      child: Card(
        margin: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              status,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              count.toString(),
              style: const TextStyle(fontSize: 24),
            ),
          ],
        ),
      ),
    );
  }
}