import 'package:get/get_navigation/get_navigation.dart';
import 'package:organization/app/routes_name.dart';
import 'package:organization/screens/about_us/view/about_us_screen.dart';
import 'package:organization/screens/contact_us/view/contact_us_screen.dart';
import 'package:organization/screens/events/view/event_screen.dart';
import 'package:organization/screens/forgot_password/view/forgot_password_view.dart';
import 'package:organization/screens/gallery/view/gallery_screen.dart';
import 'package:organization/screens/home/view/home_view.dart';
import 'package:organization/screens/login/view/login_view.dart';
import 'package:organization/screens/membership/view/membership_screen.dart';
import 'package:organization/screens/splash_screen.dart';

class AppPages {
  static final pages = [
    GetPage(name: AppRoutes.splashScreen, page: () => SplashScreen()),
    GetPage(
      name: AppRoutes.loginScreen,
      page: () => LoginScreen(),
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: AppRoutes.forgot,
      page: () => ForgotPasswordScreen(),
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => HomeScreen(),
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: AppRoutes.contactUs,
      page: () => ContactUsListScreen(),
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: AppRoutes.events,
      page: () => EventScreen(),
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: AppRoutes.gallery,
      page: () => GalleryListScreen(),
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: AppRoutes.membership,
      page: () => MembershipDetailsScreen(),
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: AppRoutes.aboutus,
      page: () => AboutUsScreen(),
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: AppRoutes.membership,
      page: () => MembershipDetailsScreen(),
      transition: Transition.rightToLeftWithFade,
    ),
  ];
}
