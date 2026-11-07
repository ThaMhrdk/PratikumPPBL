import 'package:flutter/material.dart';

class HalamanChatKonsultasi extends StatefulWidget {
  const HalamanChatKonsultasi({super.key});

  @override
  State<HalamanChatKonsultasi> createState() => _HalamanChatKonsultasiState();
}

class _HalamanChatKonsultasiState extends State<HalamanChatKonsultasi> {
  final _pesanController = TextEditingController();
  final List<Map<String, dynamic>> _pesan = [
    {
      'teks': 'Halo, selamat datang di sesi konseling online Kutkatha. Saya Psikolog Pendamping Anda hari ini. Bagaimana kabar dan perasaan Anda saat ini?',
      'dariSaya': false,
      'waktu': '09:00',
    },
    {
      'teks': 'Pagi dok, belakangan ini saya merasa sulit tidur karena kepikiran target pekerjaan dan kuliah.',
      'dariSaya': true,
      'waktu': '09:02',
    },
    {
      'teks': 'Terima kasih sudah mau berbagi. Sangat wajar merasakan hal tersebut saat beban sedang tinggi. Mari kita mulai dengan latihan pernapasan sejenak, ya.',
      'dariSaya': false,
      'waktu': '09:03',
    },
  ];

  @override
  void dispose() {
    _pesanController.dispose();
    super.dispose();
  }

  void _kirimPesan() {
    final teks = _pesanController.text.trim();
    if (teks.isEmpty) return;

    final now = DateTime.now();
    final jam = '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';

    setState(() {
      _pesan.add({
        'teks': teks,
        'dariSaya': true,
        'waktu': jam,
      });
      _pesanController.clear();
    });

    // Simulasi respons psikolog setelah 1.2 detik
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (!mounted) return;
      setState(() {
        _pesan.add({
          'teks': 'Saya mendengarkan Anda. Boleh diceritakan lebih lanjut sejak kapan situasi ini mulai terasa paling mengganggu?',
          'dariSaya': false,
          'waktu': '${DateTime.now().hour.toString().padLeft(2, '0')}:${DateTime.now().minute.toString().padLeft(2, '0')}',
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header Status Sesi
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          color: Colors.deepPurple.shade50,
          child: Row(
            children: [
              const Icon(Icons.security, size: 16, color: Colors.deepPurple),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Sesi Konseling Aktif • Dilindungi Kode Etik Kerahasiaan Psikologi',
                  style: TextStyle(fontSize: 11.5, color: Colors.deepPurple.shade900),
                ),
              ),
            ],
          ),
        ),
        // Daftar Pesan Chat
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(12),
            reverse: true,
            itemCount: _pesan.length,
            itemBuilder: (context, index) {
              final item = _pesan[_pesan.length - 1 - index];
              final dariSaya = item['dariSaya'] as bool;

              return Align(
                alignment: dariSaya ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.78,
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: dariSaya ? Theme.of(context).colorScheme.primary : Colors.grey.shade200,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(14),
                      topRight: const Radius.circular(14),
                      bottomLeft: Radius.circular(dariSaya ? 14 : 2),
                      bottomRight: Radius.circular(dariSaya ? 2 : 14),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment:
                        dariSaya ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['teks'],
                        style: TextStyle(
                          color: dariSaya ? Colors.white : Colors.black87,
                          fontSize: 13.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item['waktu'],
                        style: TextStyle(
                          color: dariSaya ? Colors.white70 : Colors.black45,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        // Kolom Input Pesan dan Tombol Kirim
        Container(
          padding: const EdgeInsets.fromLTRB(12, 6, 8, 12),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                offset: const Offset(0, -1),
                blurRadius: 4,
              ),
            ],
          ),
          child: SafeArea(
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _pesanController,
                    decoration: InputDecoration(
                      hintText: 'Ketik pesan konseling...',
                      hintStyle: const TextStyle(fontSize: 13),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onSubmitted: (_) => _kirimPesan(),
                  ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white, size: 18),
                    onPressed: _kirimPesan,
                    tooltip: 'Kirim Pesan',
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
