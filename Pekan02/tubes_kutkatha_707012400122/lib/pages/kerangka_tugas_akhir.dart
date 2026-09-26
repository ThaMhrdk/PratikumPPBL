import 'package:flutter/material.dart';

import '../navigation/app_routes.dart';

class KerangkaTugasAkhirPage extends StatefulWidget {
  const KerangkaTugasAkhirPage({super.key});

  @override
  State<KerangkaTugasAkhirPage> createState() => _KerangkaTugasAkhirPageState();
}

class _KerangkaTugasAkhirPageState extends State<KerangkaTugasAkhirPage> {
  int _selectedIndex = 0;
  final _services = const [
    'Konsultasi Psikolog',
    'Forum Komunitas',
    'Artikel Edukasi',
  ];

  Future<void> _openService(String serviceName) async {
    final selected = await Navigator.pushNamed(
      context,
      AppRoutes.serviceDetail,
      arguments: serviceName,
    );
    if (!mounted || selected == null) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('$selected dipilih')));
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final wide = constraints.maxWidth >= 900;
        final medium = constraints.maxWidth >= 600;
        final content = _buildContent();

        return Scaffold(
          appBar: AppBar(title: const Text('Kerangka Tugas Akhir')),
          drawer: medium && !wide ? _buildDrawer() : null,
          body: Row(
            children: [
              if (wide)
                NavigationRail(
                  selectedIndex: _selectedIndex,
                  onDestinationSelected: (index) =>
                      setState(() => _selectedIndex = index),
                  extended: constraints.maxWidth >= 1100,
                  destinations: const [
                    NavigationRailDestination(
                      icon: Icon(Icons.home_outlined),
                      selectedIcon: Icon(Icons.home),
                      label: Text('Beranda'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.design_services_outlined),
                      selectedIcon: Icon(Icons.design_services),
                      label: Text('Layanan'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.person_outline),
                      selectedIcon: Icon(Icons.person),
                      label: Text('Profil'),
                    ),
                  ],
                ),
              Expanded(child: content),
            ],
          ),
          bottomNavigationBar: medium
              ? null
              : NavigationBar(
                  selectedIndex: _selectedIndex,
                  onDestinationSelected: (index) =>
                      setState(() => _selectedIndex = index),
                  destinations: const [
                    NavigationDestination(
                      icon: Icon(Icons.home_outlined),
                      selectedIcon: Icon(Icons.home),
                      label: 'Beranda',
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.design_services_outlined),
                      selectedIcon: Icon(Icons.design_services),
                      label: 'Layanan',
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.person_outline),
                      selectedIcon: Icon(Icons.person),
                      label: 'Profil',
                    ),
                  ],
                ),
        );
      },
    );
  }

  Widget _buildDrawer() {
    return NavigationDrawer(
      selectedIndex: _selectedIndex,
      onDestinationSelected: (index) {
        Navigator.pop(context);
        setState(() => _selectedIndex = index);
      },
      children: const [
        Padding(
          padding: EdgeInsets.fromLTRB(28, 20, 16, 12),
          child: Text('Navigasi aplikasi'),
        ),
        NavigationDrawerDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home),
          label: Text('Beranda'),
        ),
        NavigationDrawerDestination(
          icon: Icon(Icons.design_services_outlined),
          selectedIcon: Icon(Icons.design_services),
          label: Text('Layanan'),
        ),
        NavigationDrawerDestination(
          icon: Icon(Icons.person_outline),
          selectedIcon: Icon(Icons.person),
          label: Text('Profil'),
        ),
      ],
    );
  }

  Widget _buildContent() {
    switch (_selectedIndex) {
      case 1:
        return _buildServices();
      case 2:
        return const Center(child: Text('Profil pengguna Kutkatha'));
      default:
        return _buildHome();
    }
  }

  Widget _buildHome() {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Text('Kutkatha', style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 8),
        const Text(
          'Aplikasi kesehatan mental untuk membantu masyarakat Kutai Kartanegara '
          'mendapatkan akses psikolog, komunitas, dan edukasi.',
        ),
        const SizedBox(height: 24),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Layanan utama',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text('Pilih layanan untuk melihat detailnya.'),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _services
                      .map(
                        (service) => ActionChip(
                          label: Text(service),
                          onPressed: () => _openService(service),
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        DefaultTabController(
          length: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Informasi Kutkatha',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const TabBar(
                tabs: [
                  Tab(text: 'Tujuan'),
                  Tab(text: 'Pengguna'),
                  Tab(text: 'Teknologi'),
                ],
              ),
              SizedBox(
                height: 100,
                child: TabBarView(
                  children: [
                    const Center(
                      child: Text('Akses kesehatan mental yang mudah.'),
                    ),
                    const Center(child: Text('Warga Kutai Kartanegara.')),
                    const Center(
                      child: Text('Flutter terhubung API PABW/DPPB.'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildServices() {
    return ListView.builder(
      padding: const EdgeInsets.all(24),
      itemCount: _services.length,
      itemBuilder: (context, index) => Card(
        child: ListTile(
          leading: const CircleAvatar(child: Icon(Icons.psychology)),
          title: Text(_services[index]),
          subtitle: const Text('Lihat detail layanan'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => _openService(_services[index]),
        ),
      ),
    );
  }
}
