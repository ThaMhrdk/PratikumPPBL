import 'package:flutter/material.dart';

class HalamanChat extends StatefulWidget {
  const HalamanChat({super.key});

  @override
  State<HalamanChat> createState() => _HalamanChatState();
}

class _HalamanChatState extends State<HalamanChat> {
  final _pesanController = TextEditingController();
  final List<Map<String, dynamic>> _daftarPesan = [
    {
      'teks': 'Halo! Selamat datang di Layanan Tanya Petugas Kota Nusantara. Ada yang bisa kami bantu terkait permohonan layanan Anda?',
      'dariSaya': false,
      'waktu': '08:00',
    },
    {
      'teks': 'Selamat pagi petugas, saya ingin menanyakan jadwal verifikasi berkas izin usaha.',
      'dariSaya': true,
      'waktu': '08:02',
    },
    {
      'teks': 'Untuk verifikasi berkas perizinan dibuka pada Sesi Pagi (08.00-11.30) dan Sesi Siang (13.00-15.00) di Balai Kota. Pastikan membawa berkas asli ya.',
      'dariSaya': false,
      'waktu': '08:03',
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
      _daftarPesan.add({
        'teks': teks,
        'dariSaya': true,
        'waktu': jam,
      });
      _pesanController.clear();
    });

    // Simulasi balasan otomatis dari petugas setelah 1 detik
    Future.delayed(const Duration(milliseconds: 1000), () {
      if (!mounted) return;
      setState(() {
        _daftarPesan.add({
          'teks': 'Terima kasih atas pesan Anda. Petugas layanan kami sedang meninjau informasi: "$teks". Mohon menunggu sebentar.',
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
        // Banner Info
        Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: Colors.teal.shade50,
            child: Row(
              children: [
                Icon(Icons.lock_clock_outlined, size: 16, color: Colors.teal.shade700),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Percakapan ini terenkripsi dan tercatat dalam sistem layanan terpadu.',
                    style: TextStyle(fontSize: 11, color: Colors.teal.shade900),
                  ),
                ),
              ],
            ),
          ),
          // Daftar Pesan Chat (ListView.builder reverse)
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              reverse: true,
              itemCount: _daftarPesan.length,
              itemBuilder: (context, index) {
                final pesan = _daftarPesan[_daftarPesan.length - 1 - index];
                final dariSaya = pesan['dariSaya'] as bool;

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
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment:
                          dariSaya ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                      children: [
                        Text(
                          pesan['teks'],
                          style: TextStyle(
                            color: dariSaya ? Colors.white : Colors.black87,
                            fontSize: 13.5,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          pesan['waktu'],
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
                  color: Colors.black.withOpacity(0.05),
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
                      textCapitalization: TextCapitalization.sentences,
                      decoration: InputDecoration(
                        hintText: 'Ketik pertanyaan untuk petugas...',
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
