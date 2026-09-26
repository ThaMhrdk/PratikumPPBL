import 'package:flutter/material.dart';

import '../mvc/article/view/article_detail_page.dart';
import '../mvc/article/view/article_list_page.dart';
import '../mvc/auth/view/login_page.dart';
import '../mvc/auth/view/register_page.dart';
import '../mvc/booking/data/booking_model.dart';
import '../mvc/booking/view/booking_form_page.dart';
import '../mvc/booking/view/booking_list_page.dart';
import '../mvc/booking/view/payment_page.dart';
import '../mvc/consultation/data/consultation_model.dart';
import '../mvc/consultation/view/chat_page.dart';
import '../mvc/consultation/view/consultation_list_page.dart';
import '../mvc/forum/data/forum_model.dart';
import '../mvc/forum/view/forum_detail_page.dart';
import '../mvc/forum/view/forum_form_page.dart';
import '../mvc/forum/view/forum_list_page.dart';
import '../mvc/home/view/home_page.dart';
import '../mvc/home/view/splash_page.dart';
import '../mvc/psikolog/data/psikolog_model.dart';
import '../mvc/psikolog/view/psikolog_detail_page.dart';
import '../mvc/psikolog/view/psikolog_list_page.dart';
import '../mvc/settings/view/change_password_page.dart';
import '../mvc/settings/view/edit_profile_page.dart';
import '../mvc/settings/view/settings_page.dart';
import '../pages/detail_layanan_page.dart';
import '../pages/kerangka_tugas_akhir.dart';

/// Satu daftar route untuk seluruh perpindahan halaman aplikasi.
class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String finalProject = '/tugas-akhir';
  static const String serviceDetail = '/tugas-akhir/layanan';

  static const String forumList = '/forum';
  static const String forumDetail = '/forum/detail';
  static const String forumCreate = '/forum/create';
  static const String forumEdit = '/forum/edit';
  static const String psikologList = '/psikolog';
  static const String psikologDetail = '/psikolog/detail';
  static const String bookingList = '/booking';
  static const String bookingCreate = '/booking/create';
  static const String payment = '/payment';
  static const String consultationList = '/consultation';
  static const String consultation = '/consultation/chat';
  static const String chat = '/chat';
  static const String articleList = '/article';
  static const String articleDetail = '/article/detail';
  static const String settings = '/settings';
  static const String editProfile = '/settings/profile';
  static const String changePassword = '/settings/password';
}

class AppRouter {
  static Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splash:
        return _page(const SplashPage());
      case AppRoutes.login:
        return _page(const LoginPage());
      case AppRoutes.register:
        return _page(const RegisterPage());
      case AppRoutes.home:
        return _page(const HomePage());
      case AppRoutes.finalProject:
        return _page(const KerangkaTugasAkhirPage());
      case AppRoutes.serviceDetail:
        final serviceName = settings.arguments as String?;
        if (serviceName == null || serviceName.trim().isEmpty) return null;
        return _page(DetailLayananPage(serviceName: serviceName));
      case AppRoutes.forumList:
        return _page(const ForumListPage());
      case AppRoutes.forumDetail:
        final topic = settings.arguments as ForumTopic?;
        return topic == null ? null : _page(ForumDetailPage(topic: topic));
      case AppRoutes.forumCreate:
        return _page(const ForumFormPage(isEdit: false));
      case AppRoutes.forumEdit:
        final topic = settings.arguments as ForumTopic?;
        return topic == null
            ? null
            : _page(ForumFormPage(isEdit: true, topic: topic));
      case AppRoutes.psikologList:
        return _page(const PsikologListPage());
      case AppRoutes.psikologDetail:
        final psikologId = settings.arguments as int?;
        return psikologId == null
            ? null
            : _page(PsikologDetailPage(psikologId: psikologId));
      case AppRoutes.bookingList:
        return _page(const BookingListPage());
      case AppRoutes.bookingCreate:
        final args = settings.arguments as Map<String, dynamic>?;
        final schedule = args?['schedule'] as Schedule?;
        final psikolog = args?['psikolog'] as Psikolog?;
        return schedule == null || psikolog == null
            ? null
            : _page(BookingFormPage(schedule: schedule, psikolog: psikolog));
      case AppRoutes.payment:
        final booking = settings.arguments as Booking?;
        return booking == null ? null : _page(PaymentPage(booking: booking));
      case AppRoutes.consultationList:
        return _page(const ConsultationListPage());
      case AppRoutes.consultation:
        final booking = settings.arguments as Booking?;
        return booking == null ? null : _page(ChatPage(booking: booking));
      case AppRoutes.chat:
        final consultation = settings.arguments as Consultation?;
        return consultation == null
            ? null
            : _page(ChatPage(consultation: consultation));
      case AppRoutes.articleList:
        return _page(const ArticleListPage());
      case AppRoutes.articleDetail:
        final articleId = settings.arguments as int?;
        return articleId == null
            ? null
            : _page(ArticleDetailPage(articleId: articleId));
      case AppRoutes.settings:
        return _page(const SettingsPage());
      case AppRoutes.editProfile:
        return _page(const EditProfilePage());
      case AppRoutes.changePassword:
        return _page(const ChangePasswordPage());
      default:
        return null;
    }
  }

  static Route<dynamic> unknownRoute(RouteSettings settings) {
    return _page(
      Scaffold(
        appBar: AppBar(title: const Text('Halaman tidak ditemukan')),
        body: Center(
          child: Text('Route "${settings.name ?? '-'}" tidak tersedia.'),
        ),
      ),
    );
  }

  static MaterialPageRoute<void> _page(Widget child) {
    return MaterialPageRoute<void>(builder: (_) => child);
  }
}
