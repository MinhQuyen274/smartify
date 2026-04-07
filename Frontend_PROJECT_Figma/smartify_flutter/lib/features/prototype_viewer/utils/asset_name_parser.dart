class AssetNameParser {
  const AssetNameParser._();

  static int parseOrder(String fileName) {
    final leading = fileName.split('_').first;
    return int.tryParse(leading) ?? 999999;
  }

  static String parseId(String fileName) {
    return fileName.replaceAll('.png', '');
  }

  static String parseLabel(String fileName) {
    return fileName.replaceAll('.png', '').replaceAll('_', ' ');
  }

  static String resolveFeature(String normalizedName) {
    if (normalizedName.contains('walkthrough') ||
        normalizedName.contains('sign_') ||
        normalizedName.contains('forgot') ||
        normalizedName.contains('otp') ||
        normalizedName.contains('password') ||
        normalizedName.contains('splash') ||
        normalizedName.contains('welcome')) {
      return 'onboarding-auth';
    }
    if (normalizedName.contains('home') ||
        normalizedName.contains('device') ||
        normalizedName.contains('chat') ||
        normalizedName.contains('voice_assistant') ||
        normalizedName.contains('notification') ||
        normalizedName.contains('control_device') ||
        normalizedName.contains('cameras') ||
        normalizedName.contains('lightning')) {
      return 'home-devices';
    }
    if (normalizedName.contains('scene') ||
        normalizedName.contains('automation') ||
        normalizedName.contains('tap_to_run')) {
      return 'smart-scenes';
    }
    if (normalizedName.contains('report')) {
      return 'reports';
    }
    if (normalizedName.contains('account') ||
        normalizedName.contains('settings') ||
        normalizedName.contains('home_management') ||
        normalizedName.contains('member') ||
        normalizedName.contains('profile') ||
        normalizedName.contains('logout')) {
      return 'account-settings';
    }
    return 'misc';
  }
}
