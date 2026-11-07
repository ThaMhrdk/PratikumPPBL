import 'package:flutter/material.dart';

class HalamanBeranda extends StatelessWidget {
  const HalamanBeranda({super.key});

  static const List<_PilarSmartCity> _daftarPilar = [
    _PilarSmartCity(
      'Smart Governance',
      'Layanan pemerintahan yang transparan dan responsif.',
      Icons.account_balance,
    ),
    _PilarSmartCity(
      'Smart Economy',
      'Mendorong iklim usaha dan ekonomi digital warga.',
      Icons.trending_up,
    ),
    _PilarSmartCity(
      'Smart Living',
      'Kualitas hidup warga melalui fasilitas kota yang layak.',
      Icons.holiday_village,
    ),
    _PilarSmartCity(
      'Smart Mobility',
      'Transportasi kota yang efisien dan terintegrasi.',
      Icons.directions_bus,
    ),
    _PilarSmartCity(
      'Smart Environment',
      'Pengelolaan lingkungan dan sumber daya kota.',
      Icons.eco,
    ),
    _PilarSmartCity(
      'Smart People',
      'Partisipasi dan literasi digital warga kota.',
      Icons.groups,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Banner Sambutan Smart City
        Card(
          color: theme.colorScheme.primaryContainer,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(
                  Icons.location_city,
                  size: 40,
                  color: theme.colorScheme.onPrimaryContainer,
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Kota Nusantara Cerdas',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onPrimaryContainer,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Pusat layanan digital terpadu warga smart city.',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onPrimaryContainer
                              .withValues(alpha: 0.85),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        Text(
          'Ringkasan Enam Pilar Smart City',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Nusantara Cerdas Mobile - Layanan Warga Terpadu',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _daftarPilar.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.85,
          ),
          itemBuilder: (context, indeks) {
            final pilar = _daftarPilar[indeks];
            return Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.secondaryContainer,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        pilar.ikon,
                        size: 28,
                        color: theme.colorScheme.onSecondaryContainer,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      pilar.judul,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      pilar.deskripsi,
                      textAlign: TextAlign.center,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontSize: 11,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class _PilarSmartCity {
  const _PilarSmartCity(this.judul, this.deskripsi, this.ikon);
  final String judul;
  final String deskripsi;
  final IconData ikon;
}
