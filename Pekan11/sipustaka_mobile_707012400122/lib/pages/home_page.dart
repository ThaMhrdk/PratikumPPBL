import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../config/app_theme.dart';
import '../cubits/auth_cubit.dart';
import '../cubits/auth_state.dart';
import '../cubits/book_cubit.dart';
import '../cubits/book_state.dart';
import '../cubits/loan_cubit.dart';
import '../cubits/loan_state.dart';
import '../models/loan.dart';
import '../models/user.dart';
import '../widgets/book_card.dart';
import '../widgets/home_header.dart';
import '../widgets/info_view.dart';
import '../widgets/loan_card.dart';
import 'book_detail_page.dart';
import 'book_form_page.dart';
import 'login_page.dart';

// ============================================================
// HALAMAN UTAMA SIPUSTAKA (KATALOG BUKU + PEMINJAMAN)
// ============================================================
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _tabIndex = 0;
  bool _onlyMyLoans = true;

  void _openLogin() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
    );
  }

  void _openAddBook() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const BookFormPage()),
    );
  }

  void _showProfile(User user) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (sheetContext) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(height: 24),
              Container(
                width: 76,
                height: 76,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  gradient: AppColors.mainGradient,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  user.name.isEmpty ? '?' : user.name[0].toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                user.name,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
              Text(user.email, style: const TextStyle(color: AppColors.textGrey)),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.pop(sheetContext);
                    context.read<AuthCubit>().logout();
                  },
                  icon: const Icon(Icons.logout_rounded),
                  label: const Text('Logout'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.danger,
                    side: const BorderSide(color: AppColors.danger),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _confirmReturnLoan(Loan loan) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text('Kembalikan Buku?'),
        content: Text(
          'Tandai "${loan.book?.judul ?? 'Buku #${loan.bookId}'}" sebagai Dikembalikan?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.primary),
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Kembalikan'),
          ),
        ],
      ),
    );
    if (confirm != true || !mounted) return;
    await context.read<LoanCubit>().markReturned(loan);
  }

  Future<void> _confirmDeleteLoan(Loan loan) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text('Hapus Peminjaman?'),
        content: Text(
          'Riwayat peminjaman "${loan.book?.judul ?? 'Buku #${loan.bookId}'}" akan dihapus permanen.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.danger),
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
    if (confirm != true || !mounted) return;
    await context.read<LoanCubit>().deleteLoan(loan.id);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, authState) {
        return BlocBuilder<BookCubit, BookState>(
          builder: (context, bookState) {
            return BlocBuilder<LoanCubit, LoanState>(
              builder: (context, loanState) {
                final user = authState.user;
                final myLoansCount = user == null
                    ? 0
                    : loanState.loans
                        .where((loan) => loan.userId == user.id)
                        .length;
                final showAddBookFab = _tabIndex == 0 && authState.isLoggedIn;

                return Scaffold(
                  floatingActionButton: showAddBookFab
                      ? FloatingActionButton.extended(
                          onPressed: _openAddBook,
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          icon: const Icon(Icons.add_rounded),
                          label: const Text('Tambah Buku'),
                        )
                      : null,
                  bottomNavigationBar: NavigationBar(
                    selectedIndex: _tabIndex,
                    onDestinationSelected: (idx) {
                      setState(() => _tabIndex = idx);
                      if (idx == 1 && authState.isLoggedIn) {
                        context.read<LoanCubit>().loadLoans();
                      }
                    },
                    destinations: const [
                      NavigationDestination(
                        icon: Icon(Icons.menu_book_outlined),
                        selectedIcon: Icon(Icons.menu_book_rounded),
                        label: 'Katalog Buku',
                      ),
                      NavigationDestination(
                        icon: Icon(Icons.assignment_outlined),
                        selectedIcon: Icon(Icons.assignment_rounded),
                        label: 'Peminjaman',
                      ),
                    ],
                  ),
                  body: Column(
                    children: [
                      HomeHeader(
                        user: user,
                        isChecking: authState.isChecking,
                        totalBuku: bookState.books.length,
                        pinjamanSaya: myLoansCount,
                        onLoginTap: _openLogin,
                        onProfileTap: () => _showProfile(user!),
                      ),
                      Expanded(
                        child: _tabIndex == 0
                            ? _buildBookTab(bookState)
                            : _buildLoanTab(loanState, user),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildBookTab(BookState state) {
    final cubit = context.read<BookCubit>();
    if (state.isLoading && state.books.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    if (state.errorText != null && state.books.isEmpty) {
      return InfoView(
        icon: Icons.cloud_off_rounded,
        title: 'Oops, gagal terhubung',
        subtitle: state.errorText!,
        buttonText: 'Coba Lagi',
        onPressed: cubit.loadBooks,
      );
    }
    if (state.books.isEmpty) {
      return RefreshIndicator(
        onRefresh: cubit.loadBooks,
        child: ListView(
          children: const [
            SizedBox(height: 40),
            InfoView(
              icon: Icons.menu_book_outlined,
              title: 'Katalog buku kosong',
              subtitle: 'Silakan login lalu tambahkan buku pertama.',
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: cubit.loadBooks,
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 96),
        itemCount: state.books.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return const Padding(
              padding: EdgeInsets.only(bottom: 12),
              child: Text(
                'Daftar Koleksi Buku',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
            );
          }
          final book = state.books[index - 1];
          return BookCard(
            book: book,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => BookDetailPage(book: book)),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLoanTab(LoanState state, User? user) {
    if (user == null) {
      return InfoView(
        icon: Icons.lock_outline_rounded,
        title: 'Login Diperlukan',
        subtitle: 'Masuk untuk meminjam buku dan melihat riwayat peminjaman.',
        buttonText: 'Login Sekarang',
        onPressed: _openLogin,
      );
    }

    final cubit = context.read<LoanCubit>();
    if (state.isLoading && state.loans.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    if (state.errorText != null && state.loans.isEmpty) {
      return InfoView(
        icon: Icons.cloud_off_rounded,
        title: 'Gagal memuat peminjaman',
        subtitle: state.errorText!,
        buttonText: 'Coba Lagi',
        onPressed: cubit.loadLoans,
      );
    }

    final visibleLoans = _onlyMyLoans
        ? state.loans.where((l) => l.userId == user.id).toList()
        : state.loans;

    return RefreshIndicator(
      onRefresh: cubit.loadLoans,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ChoiceChip(
                label: const Text('Milik Saya'),
                selected: _onlyMyLoans,
                onSelected: (_) => setState(() => _onlyMyLoans = true),
              ),
              ChoiceChip(
                label: const Text('Semua Peminjaman'),
                selected: !_onlyMyLoans,
                onSelected: (_) => setState(() => _onlyMyLoans = false),
              ),
            ],
          ),
          const SizedBox(height: 14),
          if (visibleLoans.isEmpty)
            const InfoView(
              icon: Icons.assignment_outlined,
              title: 'Belum ada peminjaman',
              subtitle: 'Buka detail buku di tab Katalog untuk meminjam.',
            )
          else
            ...visibleLoans.map(
              (loan) => LoanCard(
                loan: loan,
                isMine: loan.userId == user.id,
                onReturn: () => _confirmReturnLoan(loan),
                onDelete: () => _confirmDeleteLoan(loan),
              ),
            ),
        ],
      ),
    );
  }
}
