import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/theme_cubit.dart';
import '../helpers/pengaturan_helper.dart';
import '../widgets/primary_button.dart';

class HalamanPengaturan extends StatefulWidget {
  const HalamanPengaturan({super.key});

  @override
  State<HalamanPengaturan> createState() => _HalamanPengaturanState();
}

class _HalamanPengaturanState extends State<HalamanPengaturan> {
  bool temaGelap = false;
  final cWaspadaAir = TextEditingController();
  final cSiagaAir = TextEditingController();
  final cWaspadaTanah = TextEditingController();
  final cSiagaTanah = TextEditingController();
  final cWaspadaHujan = TextEditingController();
  final cSiagaHujan = TextEditingController();

  @override
  void initState() {
    super.initState();
    _muatPengaturan();
  }

  Future<void> _muatPengaturan() async {
    final gelap = await PengaturanHelper.muatTemaGelap();
    final ambang = await PengaturanHelper.muatAmbangBatas();
    if (!mounted) return;
    setState(() {
      temaGelap = gelap;
      _isiController(ambang);
    });
    context.read<ThemeCubit>().setTemaGelap(gelap);
  }

  void _isiController(AmbangBatas ambang) {
    cWaspadaAir.text = ambang.waspadaAir.toString();
    cSiagaAir.text = ambang.siagaAir.toString();
    cWaspadaTanah.text = ambang.waspadaTanah.toString();
    cSiagaTanah.text = ambang.siagaTanah.toString();
    cWaspadaHujan.text = ambang.waspadaHujan.toString();
    cSiagaHujan.text = ambang.siagaHujan.toString();
  }

  Future<void> _simpanAmbang() async {
    final ambang = AmbangBatas(
      waspadaAir: int.tryParse(cWaspadaAir.text) ?? 100,
      siagaAir: int.tryParse(cSiagaAir.text) ?? 200,
      waspadaTanah: int.tryParse(cWaspadaTanah.text) ?? 15,
      siagaTanah: int.tryParse(cSiagaTanah.text) ?? 30,
      waspadaHujan: int.tryParse(cWaspadaHujan.text) ?? 50,
      siagaHujan: int.tryParse(cSiagaHujan.text) ?? 100,
    );
    await PengaturanHelper.simpanAmbangBatas(ambang);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Ambang batas status siaga disimpan.')),
    );
  }

  Future<void> _resetPengaturan() async {
    await PengaturanHelper.resetSemua();
    if (!mounted) return;
    if (temaGelap) {
      context.read<ThemeCubit>().setTemaGelap(false);
    }
    setState(() {
      temaGelap = false;
      _isiController(const AmbangBatas());
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Pengaturan dikembalikan ke bawaan.')),
    );
  }

  @override
  void dispose() {
    cWaspadaAir.dispose();
    cSiagaAir.dispose();
    cWaspadaTanah.dispose();
    cSiagaTanah.dispose();
    cWaspadaHujan.dispose();
    cSiagaHujan.dispose();
    super.dispose();
  }

  Widget _buildPair(
    String judul,
    TextEditingController ctrlWaspada,
    TextEditingController ctrlSiaga,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(judul, style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: ctrlWaspada,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Batas Waspada',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: ctrlSiaga,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Batas Siaga',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pengaturan Ambang Batas')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            children: [
              const Text('Mode Gelap'),
              const Spacer(),
              Switch(
                value: temaGelap,
                onChanged: (nilai) async {
                  setState(() => temaGelap = nilai);
                  await PengaturanHelper.simpanTemaGelap(nilai);
                  if (!context.mounted) return;
                  context.read<ThemeCubit>().setTemaGelap(nilai);
                },
              ),
            ],
          ),
          const Divider(height: 24),
          _buildPair('Ketinggian Air (cm)', cWaspadaAir, cSiagaAir),
          _buildPair('Pergeseran Tanah (mm)', cWaspadaTanah, cSiagaTanah),
          _buildPair('Curah Hujan (mm/jam)', cWaspadaHujan, cSiagaHujan),
          const SizedBox(height: 8),
          PrimaryButton(
            label: 'Simpan Ambang Batas',
            icon: Icons.save,
            onPressed: _simpanAmbang,
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: _resetPengaturan,
            icon: const Icon(Icons.restore),
            label: const Text('Reset Pengaturan'),
          ),
        ],
      ),
    );
  }
}
