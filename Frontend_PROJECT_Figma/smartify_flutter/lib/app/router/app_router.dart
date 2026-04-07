import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smartify_flutter/core/motion/app_page_transitions.dart';
import 'package:smartify_flutter/features/account-settings/presentation/screens/account_additional_settings_screen.dart';
import 'package:smartify_flutter/features/account-settings/presentation/screens/account_profile_screen.dart';
import 'package:smartify_flutter/features/account-settings/presentation/screens/account_app_appearance_screen.dart';
import 'package:smartify_flutter/features/account-settings/presentation/screens/account_app_language_screen.dart';
import 'package:smartify_flutter/features/account-settings/presentation/screens/account_contact_support_screen.dart';
import 'package:smartify_flutter/features/account-settings/presentation/screens/account_data_analytics_screen.dart';
import 'package:smartify_flutter/features/account-settings/presentation/screens/account_faq_screen.dart';
import 'package:smartify_flutter/features/account-settings/presentation/screens/account_legal_information_screen.dart';
import 'package:smartify_flutter/features/account-settings/presentation/screens/account_security_screen.dart';
import 'package:smartify_flutter/features/account-settings/presentation/screens/account_settings_toggle_list_screen.dart';
import 'package:smartify_flutter/features/account-settings/presentation/screens/account_support_document_screen.dart';
import 'package:smartify_flutter/features/account-settings/presentation/screens/account_voice_assistants_screen.dart';
import 'package:smartify_flutter/features/account-settings/presentation/screens/account_help_support_screen.dart';
import 'package:smartify_flutter/features/account-settings/presentation/screens/linked_accounts_screen.dart';
import 'package:smartify_flutter/features/account-settings/presentation/screens/account_home_management_screen.dart';
import 'package:smartify_flutter/features/account-settings/presentation/screens/account_my_home_screen.dart';
import 'package:smartify_flutter/features/account-settings/presentation/screens/account_room_management_screen.dart';
import 'package:smartify_flutter/features/account-settings/presentation/screens/account_add_member_screen.dart';
import 'package:smartify_flutter/features/account-settings/presentation/screens/account_home_member_screen.dart';

import 'package:smartify_flutter/features/home-devices/presentation/screens/add_device_screen.dart';
import 'package:smartify_flutter/features/home-devices/presentation/screens/chat_with_bobo_screen.dart';
import 'package:smartify_flutter/features/home-devices/presentation/screens/control_ac_screen.dart';
import 'package:smartify_flutter/features/home-devices/presentation/screens/control_camera_screen.dart';
import 'package:smartify_flutter/features/home-devices/presentation/screens/control_lamp_screen.dart';
import 'package:smartify_flutter/features/home-devices/presentation/screens/control_speaker_screen.dart';
import 'package:smartify_flutter/features/home-devices/presentation/screens/home_voice_assistant_screen.dart';
import 'package:smartify_flutter/features/home-devices/presentation/screens/my_home_dashboard_screen.dart';
import 'package:smartify_flutter/features/home-devices/presentation/screens/notifications_screen.dart';
import 'package:smartify_flutter/features/home-devices/presentation/screens/switch_home_screen.dart';
import 'package:smartify_flutter/features/home/presentation/screens/home_screen.dart';
import 'package:smartify_flutter/features/onboarding-auth/presentation/screens/onboarding_auth_forgot_password_screen.dart';
import 'package:smartify_flutter/features/onboarding-auth/presentation/screens/onboarding_auth_otp_screen.dart';
import 'package:smartify_flutter/features/onboarding-auth/presentation/screens/onboarding_auth_reset_password_screen.dart';
import 'package:smartify_flutter/features/onboarding-auth/presentation/screens/onboarding_auth_reset_success_screen.dart';
import 'package:smartify_flutter/features/onboarding-auth/presentation/screens/onboarding_auth_sign_in_screen.dart';
import 'package:smartify_flutter/features/onboarding-auth/presentation/screens/onboarding_auth_sign_up_screen.dart';
import 'package:smartify_flutter/features/onboarding-auth/presentation/screens/onboarding_auth_splash_screen.dart';
import 'package:smartify_flutter/features/onboarding-auth/presentation/screens/onboarding_auth_walkthrough_screen.dart';
import 'package:smartify_flutter/features/onboarding-auth/presentation/screens/onboarding_auth_welcome_screen.dart';
import 'package:smartify_flutter/features/reports/presentation/screens/device_detail_bill_screen.dart';
import 'package:smartify_flutter/features/reports/presentation/screens/reports_dashboard_screen.dart';
import 'package:smartify_flutter/features/screen-mapping/screen_manifest.dart';
import 'package:smartify_flutter/features/screen-mapping/screen_viewer_screen.dart';
import 'package:smartify_flutter/features/smart-scenes/models/smart_scenes_models.dart';
import 'package:smartify_flutter/features/smart-scenes/presentation/screens/control_single_device_screen.dart';
import 'package:smartify_flutter/features/smart-scenes/presentation/screens/create_scene_screen.dart';
import 'package:smartify_flutter/features/smart-scenes/presentation/screens/delay_action_screen.dart';
import 'package:smartify_flutter/features/smart-scenes/presentation/screens/location_change_screen.dart';
import 'package:smartify_flutter/features/smart-scenes/presentation/screens/preset_location_screen.dart';
import 'package:smartify_flutter/features/smart-scenes/presentation/screens/schedule_time_screen.dart';
import 'package:smartify_flutter/features/smart-scenes/presentation/screens/select_function_screen.dart';
import 'package:smartify_flutter/features/smart-scenes/presentation/screens/select_smart_scene_screen.dart';
import 'package:smartify_flutter/features/smart-scenes/presentation/screens/smart_scene_detail_screen.dart';
import 'package:smartify_flutter/features/smart-scenes/presentation/screens/smart_option_condition_screen.dart';
import 'package:smartify_flutter/features/smart-scenes/presentation/screens/smart_scenes_dashboard_screen.dart';
import 'package:smartify_flutter/features/smart-scenes/presentation/screens/smart_threshold_condition_screen.dart';
import 'package:smartify_flutter/features/smart-scenes/presentation/screens/weather_condition_menu_screen.dart';

class AppRoutes {
  const AppRoutes._();

  static String prototypeScreen(String id) => '/screen/$id';

  static const String home = '/';

  // Onboarding / Auth
  static const String onboardingAuthSplash = '/onboarding-auth/splash';
  static const String onboardingAuthWalkthrough =
      '/onboarding-auth/walkthrough';
  static const String onboardingAuthWelcome = '/onboarding-auth/welcome';
  static const String onboardingAuthSignUp = '/onboarding-auth/sign-up';
  static const String onboardingAuthSignIn = '/onboarding-auth/sign-in';
  static const String onboardingAuthForgotPassword =
      '/onboarding-auth/forgot-password';
  static const String onboardingAuthOtp = '/onboarding-auth/otp';
  static const String onboardingAuthResetPassword =
      '/onboarding-auth/reset-password';
  static const String onboardingAuthResetSuccess =
      '/onboarding-auth/reset-success';

  // Home / Devices
  static const String homeDevicesDashboard = '/home-devices/dashboard';
  static const String homeDevicesAddDevice = '/home-devices/add-device';
  static const String homeDevicesSwitchHome = '/home-devices/switch-home';
  static const String homeDevicesNotifications = '/home-devices/notifications';
  static const String homeDevicesVoiceAssistant =
      '/home-devices/voice-assistant';
  static const String homeDevicesChatbot = '/home-devices/chatbot';
  static const String homeDevicesControlLamp = '/home-devices/control/lamp';
  static const String homeDevicesControlAc = '/home-devices/control/ac';
  static const String homeDevicesControlCamera = '/home-devices/control/camera';
  static const String homeDevicesControlSpeaker =
      '/home-devices/control/speaker';

  // Other features
  static const String smartScenesDashboard = '/smart-scenes/dashboard';
  static const String smartScenesCreate = '/smart-scenes/create';
  static const String smartScenesDetail = '/smart-scenes/detail';
  static const String smartScenesWeatherMenu = '/smart-scenes/create/weather';
  static const String smartScenesConditionTemperature =
      '/smart-scenes/create/weather/temperature';
  static const String smartScenesConditionHumidity =
      '/smart-scenes/create/weather/humidity';
  static const String smartScenesConditionWeather =
      '/smart-scenes/create/weather/weather';
  static const String smartScenesConditionSunriseSunset =
      '/smart-scenes/create/weather/sunrise-sunset';
  static const String smartScenesConditionWindSpeed =
      '/smart-scenes/create/weather/wind-speed';
  static const String smartScenesConditionLocationChange =
      '/smart-scenes/create/location-change';
  static const String smartScenesConditionPresetLocation =
      '/smart-scenes/create/location-change/preset';
  static const String smartScenesConditionScheduleTime =
      '/smart-scenes/create/schedule-time';
  static const String smartScenesTaskControlSingleDevice =
      '/smart-scenes/create/task/control-single-device';
  static const String smartScenesTaskSelectFunction =
      '/smart-scenes/create/task/select-function';
  static const String smartScenesTaskSelectSmartScene =
      '/smart-scenes/create/task/select-smart-scene';
  static const String smartScenesTaskDelayAction =
      '/smart-scenes/create/task/delay-action';
  static const String reportsDashboard = '/reports/dashboard';
  static const String reportsDeviceDetail = '/reports/device-detail';
  static const String accountProfile = '/account-settings/profile';
  static const String accountSecurity = '/account-settings/security';
  static const String accountLinkedAccounts =
      '/account-settings/linked-accounts';
  static const String accountVoiceAssistants =
      '/account-settings/voice-assistants';
  static const String accountAppAppearance =
      '/account-settings/app-appearance';
  static const String accountAppLanguage = '/account-settings/app-language';
  static const String accountAdditionalSettings =
      '/account-settings/additional-settings';
  static const String accountDataAnalytics =
      '/account-settings/data-analytics';
  static const String accountHelpSupport = '/account-settings/help-support';
  static const String accountFaq = '/account-settings/help-support/faq';
  static const String accountContactSupport =
      '/account-settings/help-support/contact-support';
  static const String accountPrivacyPolicy =
      '/account-settings/help-support/privacy-policy';
  static const String accountTermsOfService =
      '/account-settings/help-support/terms-of-service';
  static const String accountSupportDocument =
      '/account-settings/help-support/document';
  static const String accountHomeManagement =
      '/account-settings/home-management';
  static const String accountMyHome = '/account-settings/my-home';
  static const String accountRoomManagement =
      '/account-settings/room-management';
  static const String accountAddMember = '/account-settings/add-member';
  static const String accountHomeMember = '/account-settings/home-member';
  static const String accountSettingsToggleList =
      '/account-settings/toggle-list';
  static const String accountLegalInformation =
      '/account-settings/legal-information';
}

class AppRouter {
  const AppRouter._();

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.home:
        return AppPageTransitions.fadeSlide(
          const HomeScreen(),
          settings: settings,
        );

      // ── Onboarding / Auth ──
      case AppRoutes.onboardingAuthSplash:
        return AppPageTransitions.fadeSlide(
          const OnboardingAuthSplashScreen(),
          settings: settings,
        );
      case AppRoutes.onboardingAuthWalkthrough:
        return AppPageTransitions.fadeSlide(
          const OnboardingAuthWalkthroughScreen(),
          settings: settings,
        );
      case AppRoutes.onboardingAuthWelcome:
        return AppPageTransitions.fadeSlide(
          const OnboardingAuthWelcomeScreen(),
          settings: settings,
        );
      case AppRoutes.onboardingAuthSignUp:
        return AppPageTransitions.fadeSlide(
          const OnboardingAuthSignUpScreen(),
          settings: settings,
        );
      case AppRoutes.onboardingAuthSignIn:
        return AppPageTransitions.fadeSlide(
          const OnboardingAuthSignInScreen(),
          settings: settings,
        );
      case AppRoutes.onboardingAuthForgotPassword:
        return AppPageTransitions.fadeSlide(
          const OnboardingAuthForgotPasswordScreen(),
          settings: settings,
        );
      case AppRoutes.onboardingAuthOtp:
        return AppPageTransitions.fadeSlide(
          const OnboardingAuthOtpScreen(),
          settings: settings,
        );
      case AppRoutes.onboardingAuthResetPassword:
        return AppPageTransitions.fadeSlide(
          const OnboardingAuthResetPasswordScreen(),
          settings: settings,
        );
      case AppRoutes.onboardingAuthResetSuccess:
        return AppPageTransitions.fadeSlide(
          const OnboardingAuthResetSuccessScreen(),
          settings: settings,
        );

      // ── Home / Devices ──
      case AppRoutes.homeDevicesDashboard:
        return AppPageTransitions.fadeSlide(
          const MyHomeDashboardScreen(),
          settings: settings,
        );
      case AppRoutes.homeDevicesAddDevice:
        return AppPageTransitions.fadeSlide(
          const AddDeviceScreen(),
          settings: settings,
        );
      case AppRoutes.homeDevicesSwitchHome:
        return AppPageTransitions.fadeSlide(
          const SwitchHomeScreen(),
          settings: settings,
        );
      case AppRoutes.homeDevicesNotifications:
        return AppPageTransitions.fadeSlide(
          const NotificationsScreen(),
          settings: settings,
        );
      case AppRoutes.homeDevicesVoiceAssistant:
        return AppPageTransitions.fadeSlide(
          const HomeVoiceAssistantScreen(),
          settings: settings,
        );
      case AppRoutes.homeDevicesChatbot:
        return AppPageTransitions.fadeSlide(
          const ChatWithBoboScreen(),
          settings: settings,
        );
      case AppRoutes.homeDevicesControlLamp:
        return AppPageTransitions.fadeSlide(
          const ControlLampScreen(),
          settings: settings,
        );
      case AppRoutes.homeDevicesControlAc:
        return AppPageTransitions.fadeSlide(
          const ControlAcScreen(),
          settings: settings,
        );
      case AppRoutes.homeDevicesControlCamera:
        return AppPageTransitions.fadeSlide(
          const ControlCameraScreen(),
          settings: settings,
        );
      case AppRoutes.homeDevicesControlSpeaker:
        return AppPageTransitions.fadeSlide(
          const ControlSpeakerScreen(),
          settings: settings,
        );

      // ── Smart Scenes ──
      case AppRoutes.smartScenesDashboard:
        return AppPageTransitions.fadeSlide(
          const SmartScenesDashboardScreen(),
          settings: settings,
        );
      case AppRoutes.smartScenesCreate:
        return AppPageTransitions.fadeSlide(
          const CreateSceneScreen(),
          settings: settings,
        );
      case AppRoutes.smartScenesDetail:
        final args = settings.arguments as SmartSceneDetailArgs;
        return AppPageTransitions.fadeSlide(
          SmartSceneDetailScreen(args: args),
          settings: settings,
        );
      case AppRoutes.smartScenesWeatherMenu:
        return AppPageTransitions.fadeSlide(
          const WeatherConditionMenuScreen(),
          settings: settings,
        );
      case AppRoutes.smartScenesConditionTemperature:
        return AppPageTransitions.fadeSlide(
          const SmartThresholdConditionScreen(
            args: SmartThresholdConditionScreenArgs(
              title: 'Temperature',
              icon: Icons.thermostat_rounded,
              color: Color(0xFFFF5A4E),
              unit: '°C',
              min: -10,
              max: 40,
              initialValue: 20,
              minLabel: '-10°C',
              maxLabel: '40°C',
            ),
          ),
          settings: settings,
        );
      case AppRoutes.smartScenesConditionHumidity:
        return AppPageTransitions.fadeSlide(
          const SmartOptionConditionScreen(
            args: SmartOptionConditionScreenArgs(
              title: 'Humidity',
              options: ['Dry', 'Comfortable', 'Moist'],
              selectedOption: 'Dry',
              summaryPrefix: 'Humidity',
              icon: Icons.water_drop_rounded,
              color: Color(0xFF2D93E6),
            ),
          ),
          settings: settings,
        );
      case AppRoutes.smartScenesConditionWeather:
        return AppPageTransitions.fadeSlide(
          const SmartOptionConditionScreen(
            args: SmartOptionConditionScreenArgs(
              title: 'Weather',
              options: ['Sunny', 'Cloudy', 'Rainy', 'Snowy', 'Hazy'],
              selectedOption: 'Rainy',
              summaryPrefix: 'Weather',
              icon: Icons.wb_sunny_rounded,
              color: Color(0xFFFFA126),
            ),
          ),
          settings: settings,
        );
      case AppRoutes.smartScenesConditionSunriseSunset:
        return AppPageTransitions.fadeSlide(
          const SmartOptionConditionScreen(
            args: SmartOptionConditionScreenArgs(
              title: 'Sunrise / Sunset',
              options: ['Sunset', 'Sunrise'],
              selectedOption: 'Sunset',
              icon: Icons.light_mode_rounded,
              color: Color(0xFFFFB238),
            ),
          ),
          settings: settings,
        );
      case AppRoutes.smartScenesConditionWindSpeed:
        return AppPageTransitions.fadeSlide(
          const SmartThresholdConditionScreen(
            args: SmartThresholdConditionScreenArgs(
              title: 'Wind Speed',
              icon: Icons.air_rounded,
              color: Color(0xFF4A68F6),
              unit: ' m/s',
              min: 0,
              max: 62,
              initialValue: 45,
              minLabel: '0 m/s',
              maxLabel: '62 m/s',
            ),
          ),
          settings: settings,
        );
      case AppRoutes.smartScenesConditionLocationChange:
        return AppPageTransitions.fadeSlide(
          const LocationChangeScreen(),
          settings: settings,
        );
      case AppRoutes.smartScenesConditionPresetLocation:
        final isArrive = settings.arguments as bool? ?? true;
        return AppPageTransitions.fadeSlide(
          PresetLocationScreen(isArrive: isArrive),
          settings: settings,
        );
      case AppRoutes.smartScenesConditionScheduleTime:
        return AppPageTransitions.fadeSlide(
          const ScheduleTimeScreen(),
          settings: settings,
        );
      case AppRoutes.smartScenesTaskControlSingleDevice:
        return AppPageTransitions.fadeSlide(
          const ControlSingleDeviceScreen(),
          settings: settings,
        );
      case AppRoutes.smartScenesTaskSelectFunction:
        final device = settings.arguments as SmartSceneDevice;
        return AppPageTransitions.fadeSlide(
          SelectFunctionScreen(device: device),
          settings: settings,
        );
      case AppRoutes.smartScenesTaskSelectSmartScene:
        final initialTab =
            settings.arguments as SmartSceneSelectionTab? ??
                SmartSceneSelectionTab.automation;
        return AppPageTransitions.fadeSlide(
          SelectSmartSceneScreen(initialTab: initialTab),
          settings: settings,
        );
      case AppRoutes.smartScenesTaskDelayAction:
        return AppPageTransitions.fadeSlide(
          const DelayActionScreen(),
          settings: settings,
        );

      // ── Reports ──
      case AppRoutes.reportsDashboard:
        return AppPageTransitions.fadeSlide(
          const ReportsDashboardScreen(),
          settings: settings,
        );
      case AppRoutes.reportsDeviceDetail:
        final deviceId = settings.arguments as String? ?? '';
        return AppPageTransitions.fadeSlide(
          DeviceDetailBillScreen(deviceId: deviceId),
          settings: settings,
        );

      // ── Account / Settings ──
      case AppRoutes.accountProfile:
        return AppPageTransitions.fadeSlide(
          const AccountProfileScreen(),
          settings: settings,
        );
      case AppRoutes.accountSecurity:
        return AppPageTransitions.fadeSlide(
          const AccountSecurityScreen(),
          settings: settings,
        );
      case AppRoutes.accountLinkedAccounts:
        return AppPageTransitions.fadeSlide(
          const LinkedAccountsScreen(),
          settings: settings,
        );
      case AppRoutes.accountVoiceAssistants:
        return AppPageTransitions.fadeSlide(
          const AccountVoiceAssistantsScreen(),
          settings: settings,
        );
      case AppRoutes.accountAppAppearance:
        return AppPageTransitions.fadeSlide(
          const AccountAppAppearanceScreen(),
          settings: settings,
        );
      case AppRoutes.accountAppLanguage:
        return AppPageTransitions.fadeSlide(
          const AccountAppLanguageScreen(),
          settings: settings,
        );
      case AppRoutes.accountAdditionalSettings:
        return AppPageTransitions.fadeSlide(
          const AccountAdditionalSettingsScreen(),
          settings: settings,
        );
      case AppRoutes.accountDataAnalytics:
        return AppPageTransitions.fadeSlide(
          const AccountDataAnalyticsScreen(),
          settings: settings,
        );
      case AppRoutes.accountHelpSupport:
        return AppPageTransitions.fadeSlide(
          const AccountHelpSupportScreen(),
          settings: settings,
        );
      case AppRoutes.accountFaq:
        return AppPageTransitions.fadeSlide(
          const AccountFaqScreen(),
          settings: settings,
        );
      case AppRoutes.accountContactSupport:
        return AppPageTransitions.fadeSlide(
          const AccountContactSupportScreen(),
          settings: settings,
        );
      case AppRoutes.accountPrivacyPolicy:
        return AppPageTransitions.fadeSlide(
          AccountSupportDocumentScreen(args: _privacyPolicyArgs()),
          settings: settings,
        );
      case AppRoutes.accountTermsOfService:
        return AppPageTransitions.fadeSlide(
          AccountSupportDocumentScreen(args: _termsOfServiceArgs()),
          settings: settings,
        );
      case AppRoutes.accountSupportDocument:
        final supportArgs = settings.arguments as AccountSupportDocumentArgs;
        return AppPageTransitions.fadeSlide(
          AccountSupportDocumentScreen(args: supportArgs),
          settings: settings,
        );
      case AppRoutes.accountHomeManagement:
        return AppPageTransitions.fadeSlide(
          const AccountHomeManagementScreen(),
          settings: settings,
        );
      case AppRoutes.accountMyHome:
        final homeId = settings.arguments as String?;
        return AppPageTransitions.fadeSlide(
          AccountMyHomeScreen(homeId: homeId),
          settings: settings,
        );
      case AppRoutes.accountRoomManagement:
        return AppPageTransitions.fadeSlide(
          const AccountRoomManagementScreen(),
          settings: settings,
        );
      case AppRoutes.accountAddMember:
        return AppPageTransitions.fadeSlide(
          const AccountAddMemberScreen(),
          settings: settings,
        );
      case AppRoutes.accountHomeMember:
        return AppPageTransitions.fadeSlide(
          const AccountHomeMemberScreen(),
          settings: settings,
        );
      case AppRoutes.accountSettingsToggleList:
        final toggleArgs = settings.arguments as AccountSettingsToggleListArgs;
        return AppPageTransitions.fadeSlide(
          AccountSettingsToggleListScreen(args: toggleArgs),
          settings: settings,
        );
      case AppRoutes.accountLegalInformation:
        return AppPageTransitions.fadeSlide(
          const AccountLegalInformationScreen(),
          settings: settings,
        );

      default:
        if ((settings.name ?? '').startsWith('/screen/')) {
          final id = (settings.name ?? '').split('/').last;
          return AppPageTransitions.fadeSlide(
            ScreenViewerScreen(screenId: id),
            settings: settings,
          );
        }
        return MaterialPageRoute(
          settings: settings,
          builder: (context) {
            final store = context.read<ScreenManifestStore>();
            final first = store.items.isNotEmpty
                ? store.items.first.route
                : AppRoutes.home;
            return Scaffold(
              body: Center(
                child: TextButton(
                  onPressed: () =>
                      Navigator.pushReplacementNamed(context, first),
                  child: const Text('Unknown route. Go to first screen'),
                ),
              ),
            );
          },
        );
    }
  }
}

AccountSupportDocumentArgs _privacyPolicyArgs() {
  return const AccountSupportDocumentArgs(
    title: 'Privacy Policy',
    lastUpdated: 'December 19, 2024',
    introduction:
        'This Privacy Policy outlines how Smartify ("we," "us," or "our") collects, uses, and protects your personal information when you use our smart home application. By using Smartify, you agree to the terms outlined in this policy.',
    sections: [
      AccountSupportDocumentSection(
        heading: '1. Information We Collect',
        body: 'We may collect the following types of information:',
        bullets: [
          'Personal Information: This includes but is not limited to your name, email address, and other contact details provided during account creation.',
          'Device Information: We collect data related to your connected smart devices, such as device names and statuses.',
          'Usage Data: Information about how you interact with the Smartify application, including device control history and app usage patterns.',
        ],
      ),
      AccountSupportDocumentSection(
        heading: '2. How We Use Your Information',
        body: 'We use the collected information to:',
        bullets: [
          'Provide and improve our services.',
          'Personalize your experience.',
          'Deliver home alerts, automation status, and service updates.',
        ],
      ),
      AccountSupportDocumentSection(
        heading: '3. Your Choices',
        body:
            'You can manage analytics, ad preferences, and download requests from Data & Analytics inside Account Settings.',
      ),
    ],
  );
}

AccountSupportDocumentArgs _termsOfServiceArgs() {
  return const AccountSupportDocumentArgs(
    title: 'Terms of Service',
    lastUpdated: 'December 20, 2024',
    introduction:
        'By using the Smartify application, you agree to the following Terms of Service:',
    sections: [
      AccountSupportDocumentSection(
        heading: '1. Acceptance of Terms',
        body:
            'You agree to comply with all applicable laws and regulations when using Smartify. If you do not agree with any part of these terms, please do not use the application.',
      ),
      AccountSupportDocumentSection(
        heading: '2. Use of Services',
        body:
            'You are granted a non-exclusive, non-transferable, revocable license to use Smartify for personal, non-commercial purposes.',
      ),
      AccountSupportDocumentSection(
        heading: '3. User Account',
        body:
            'To use certain features, you may be required to create an account. You are responsible for maintaining the confidentiality of your account information.',
      ),
      AccountSupportDocumentSection(
        heading: '4. Prohibited Activities',
        body: 'You agree not to engage in any activities that may:',
        bullets: [
          'Violate laws or regulations.',
          'Infringe on the rights of others.',
          'Interfere with the operation or security of Smartify services.',
        ],
      ),
    ],
  );
}
