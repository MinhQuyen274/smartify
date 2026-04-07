import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smartify_flutter/app/router/app_router.dart';
import 'package:smartify_flutter/core/theme/light_color_tokens.dart';
import 'package:smartify_flutter/core/theme/light_theme.dart';
import 'package:smartify_flutter/features/onboarding-auth/presentation/widgets/auth_labeled_field.dart';
import 'package:smartify_flutter/features/onboarding-auth/presentation/widgets/auth_loading_button.dart';
import 'package:smartify_flutter/features/onboarding-auth/presentation/widgets/auth_motion_section.dart';
import 'package:smartify_flutter/features/onboarding-auth/presentation/widgets/auth_scaffold.dart';
import 'package:smartify_flutter/features/onboarding-auth/presentation/widgets/sign_up_setup_views.dart';
import 'package:smartify_flutter/features/onboarding-auth/presentation/widgets/welcome_social_button.dart';
import 'package:smartify_flutter/features/onboarding-auth/state/onboarding_auth_store.dart';
import 'package:smartify_flutter/shared/widgets/smartify_text_field.dart';

enum _SignUpPhase { account, country, homeName, rooms, location, success }

class OnboardingAuthSignUpScreen extends StatefulWidget {
  const OnboardingAuthSignUpScreen({super.key});

  @override
  State<OnboardingAuthSignUpScreen> createState() =>
      _OnboardingAuthSignUpScreenState();
}

class _OnboardingAuthSignUpScreenState
    extends State<OnboardingAuthSignUpScreen> {
  static const _countries = [
    ('Afghanistan', 'assets/png/flag_afghanistan_exact.png'),
    ('Albania', 'assets/png/flag_albania_exact.png'),
    ('Algeria', 'assets/png/flag_algeria_exact.png'),
    ('Andorra', 'assets/png/flag_andorra_exact.png'),
    ('Angola', 'assets/png/flag_angola_exact.png'),
  ];
  static const _rooms = [
    ('Living Room', Icons.weekend_outlined),
    ('Bedroom', Icons.bed_outlined),
    ('Bathroom', Icons.bathtub_outlined),
    ('Kitchen', Icons.soup_kitchen_outlined),
    ('Study Room', Icons.menu_book_outlined),
    ('Dining Room', Icons.dining_outlined),
    ('Backyard', Icons.deck_outlined),
    ('Add Room', Icons.add_circle_outline_rounded),
  ];

  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final TextEditingController _countrySearchController;
  late final TextEditingController _homeNameController;
  late final TextEditingController _addressController;

  var _phase = _SignUpPhase.account;
  var _obscurePassword = true;
  String? _selectedCountry;
  final Set<String> _selectedRooms = {
    'Living Room',
    'Bedroom',
    'Bathroom',
    'Kitchen',
    'Backyard',
  };
  var _showLocationPrompt = true;

  @override
  void initState() {
    super.initState();
    final store = context.read<OnboardingAuthStore>();
    _emailController = TextEditingController(text: store.signUpEmail);
    _passwordController = TextEditingController(text: store.signUpPassword);
    _countrySearchController = TextEditingController();
    _homeNameController = TextEditingController(text: 'My Home');
    _addressController = TextEditingController(text: '701 7th Ave, New York');
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _countrySearchController.dispose();
    _homeNameController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _submitAccountForm() async {
    final store = context.read<OnboardingAuthStore>();
    final ok = await store.submitSignUp();
    if (!mounted || !ok) {
      return;
    }
    setState(() => _phase = _SignUpPhase.country);
  }

  void _handlePrimaryStep() {
    setState(() {
      _phase = switch (_phase) {
        _SignUpPhase.country => _SignUpPhase.homeName,
        _SignUpPhase.homeName => _SignUpPhase.rooms,
        _SignUpPhase.rooms => _SignUpPhase.location,
        _SignUpPhase.location => _SignUpPhase.success,
        _ => _phase,
      };
      if (_phase == _SignUpPhase.location) {
        _showLocationPrompt = true;
      }
    });
  }

  void _handleBack() {
    if (_phase == _SignUpPhase.account) {
      Navigator.pop(context);
      return;
    }
    setState(() {
      _phase = switch (_phase) {
        _SignUpPhase.country => _SignUpPhase.account,
        _SignUpPhase.homeName => _SignUpPhase.country,
        _SignUpPhase.rooms => _SignUpPhase.homeName,
        _SignUpPhase.location => _SignUpPhase.rooms,
        _SignUpPhase.success => _SignUpPhase.location,
        _ => _phase,
      };
    });
  }

  void _finishSignUp() {
    Navigator.pushNamedAndRemoveUntil(context, AppRoutes.home, (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    return switch (_phase) {
      _SignUpPhase.account => _buildAccountForm(context),
      _SignUpPhase.success => _buildSuccess(context),
      _ => _buildSetup(context),
    };
  }

  Widget _buildAccountForm(BuildContext context) {
    final store = context.watch<OnboardingAuthStore>();
    return AuthScaffold(
      onBack: _handleBack,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AuthMotionSection(
              child: Text(
                'Join Smartify Today 👤',
                style: Theme.of(context).textTheme.displayLarge,
              ),
            ),
            const SizedBox(height: 8),
            AuthMotionSection(
              delay: const Duration(milliseconds: 60),
              child: Text(
                'Join Smartify, Your Gateway to Smart Living.',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            const SizedBox(height: 30),
            AuthLabeledField(
              label: 'Email',
              hintText: 'Email',
              controller: _emailController,
              prefixIcon: const Icon(
                Icons.email_outlined,
                color: Color(0xFF7A7F8E),
              ),
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              onChanged: store.setSignUpEmail,
              errorText: store.signUpError,
              enabled: !store.signUpLoading && !store.socialLoading,
            ),
            const SizedBox(height: LightThemeData.spacingL),
            AuthLabeledField(
              label: 'Password',
              hintText: 'Password',
              controller: _passwordController,
              prefixIcon: const Icon(
                Icons.lock_outline_rounded,
                color: Color(0xFF7A7F8E),
              ),
              suffixIcon: Icon(
                _obscurePassword
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: const Color(0xFF7A7F8E),
              ),
              onSuffixTap: () =>
                  setState(() => _obscurePassword = !_obscurePassword),
              obscureText: _obscurePassword,
              textInputAction: TextInputAction.done,
              onChanged: store.setSignUpPassword,
              enabled: !store.signUpLoading && !store.socialLoading,
            ),
            const SizedBox(height: LightThemeData.spacingM),
            Row(
              children: [
                Checkbox(
                  value: store.signUpAcceptedTerms,
                  onChanged: store.signUpLoading || store.socialLoading
                      ? null
                      : (value) => store.setSignUpAcceptedTerms(value ?? false),
                ),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: LightColorTokens.textPrimary,
                      ),
                      children: const [
                        TextSpan(text: 'I agree to Smartify '),
                        TextSpan(
                          text: 'Terms & Conditions.',
                          style: TextStyle(
                            color: LightColorTokens.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Center(
              child: Wrap(
                spacing: 6,
                children: [
                  Text(
                    'Already have an account?',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pushReplacementNamed(
                      context,
                      AppRoutes.onboardingAuthSignIn,
                    ),
                    child: Text(
                      'Sign in',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: LightColorTokens.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const Expanded(child: Divider(color: LightColorTokens.border)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    'or',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: LightColorTokens.textSecondary,
                    ),
                  ),
                ),
                const Expanded(child: Divider(color: LightColorTokens.border)),
              ],
            ),
            const SizedBox(height: 18),
            WelcomeSocialButton(
              provider: 'Google',
              loading:
                  store.socialLoading && store.socialProviderLabel == 'Google',
              onTap: () async {
                final ok = await store.submitSocialAuth('Google');
                if (!context.mounted || !ok) return;
                _finishSignUp();
              },
            ),
            const SizedBox(height: 12),
            WelcomeSocialButton(
              provider: 'Apple',
              loading:
                  store.socialLoading && store.socialProviderLabel == 'Apple',
              onTap: () async {
                final ok = await store.submitSocialAuth('Apple');
                if (!context.mounted || !ok) return;
                _finishSignUp();
              },
            ),
            const SizedBox(height: 22),
            AuthLoadingButton(
              label: 'Sign up',
              loading: store.signUpLoading,
              enabled: store.canSubmitSignUp,
              onTap: _submitAccountForm,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSetup(BuildContext context) {
    final query = _countrySearchController.text.toLowerCase();
    final filtered = _countries
        .where((country) => country.$1.toLowerCase().contains(query))
        .toList();
    final step = switch (_phase) {
      _SignUpPhase.country => 1,
      _SignUpPhase.homeName => 2,
      _SignUpPhase.rooms => 3,
      _SignUpPhase.location => 4,
      _ => 1,
    };
    final title = _phase == _SignUpPhase.country
        ? 'Select Country of Origin'
        : _phase == _SignUpPhase.homeName
        ? 'Add Home Name'
        : _phase == _SignUpPhase.rooms
        ? 'Add Rooms'
        : 'Set Home Location';
    final highlight = _phase == _SignUpPhase.country
        ? 'Country'
        : _phase == _SignUpPhase.homeName
        ? 'Home'
        : _phase == _SignUpPhase.rooms
        ? 'Rooms'
        : 'Location';
    final subtitle = _phase == _SignUpPhase.country
        ? 'Let\'s start by selecting the country where your smart haven resides.'
        : _phase == _SignUpPhase.homeName
        ? 'Every smart home needs a name. What would you like to call yours?'
        : _phase == _SignUpPhase.rooms
        ? 'Select the rooms in your house. Don\'t worry, you can always add more later.'
        : 'Pin your home\'s location to enhance location-based features. Privacy is our priority.';

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SignUpSetupHeader(
                    step: step,
                    totalSteps: 4,
                    title: title,
                    highlight: highlight,
                    subtitle: subtitle,
                    onBack: _handleBack,
                  ),
                  const SizedBox(height: 24),
                  Expanded(
                    child: _phase == _SignUpPhase.country
                        ? _buildCountryStep(filtered)
                        : _phase == _SignUpPhase.homeName
                        ? _buildHomeNameStep()
                        : _phase == _SignUpPhase.rooms
                        ? _buildRoomsStep()
                        : _buildLocationStep(),
                  ),
                  SignUpSetupFooter(
                    primaryLabel: 'Continue',
                    onPrimaryTap: _handlePrimaryStep,
                    onSkipTap: _handlePrimaryStep,
                  ),
                ],
              ),
            ),
            if (_phase == _SignUpPhase.location && _showLocationPrompt)
              _buildLocationPrompt(),
          ],
        ),
      ),
    );
  }

  Widget _buildCountryStep(List<(String, String)> filtered) {
    return Column(
      children: [
        SmartifyTextField(
          controller: _countrySearchController,
          onChanged: (_) => setState(() {}),
          hintText: 'Search Country...',
          prefixIcon: const Icon(Icons.search_rounded),
        ),
        const SizedBox(height: 20),
        Expanded(
          child: ListView.separated(
            itemCount: filtered.length,
            separatorBuilder: (_, _) => const SizedBox(height: 16),
            itemBuilder: (context, index) => CountryOptionTile(
              flagAsset: filtered[index].$2,
              label: filtered[index].$1,
              selected: _selectedCountry == filtered[index].$1,
              onTap: () =>
                  setState(() => _selectedCountry = filtered[index].$1),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHomeNameStep() => Padding(
    padding: const EdgeInsets.only(top: 12),
    child: SmartifyTextField(
      controller: _homeNameController,
      hintText: 'My Home',
    ),
  );

  Widget _buildRoomsStep() => GridView.builder(
    itemCount: _rooms.length,
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.2,
    ),
    itemBuilder: (context, index) {
      final room = _rooms[index];
      final selected = _selectedRooms.contains(room.$1);
      return RoomOptionCard(
        icon: room.$2,
        label: room.$1,
        selected: selected,
        onTap: () => setState(
          () => selected
              ? _selectedRooms.remove(room.$1)
              : _selectedRooms.add(room.$1),
        ),
      );
    },
  );

  Widget _buildLocationStep() => LayoutBuilder(
    builder: (context, constraints) {
      final maxHeight = constraints.maxHeight.isFinite
          ? constraints.maxHeight
          : 0.0;
      final mapHeight = maxHeight > 0
          ? ((maxHeight - 120).clamp(220.0, 332.0) as num).toDouble()
          : 332.0;

      return SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 4),
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: maxHeight),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: mapHeight,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: const Color(0xFFE8EBF3)),
                  image: const DecorationImage(
                    image: AssetImage('assets/png/location_map_exact.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 22),
              Text(
                'Address Details',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 12),
              SmartifyTextField(
                controller: _addressController,
                hintText: 'Address Details',
              ),
            ],
          ),
        ),
      );
    },
  );

  Widget _buildLocationPrompt() => ColoredBox(
    color: const Color(0x660F172A),
    child: Center(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 30),
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircleAvatar(
              radius: 30,
              backgroundColor: LightColorTokens.primary,
              child: Icon(
                Icons.location_searching_rounded,
                size: 30,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 22),
            Text(
              'Enable Location',
              style: Theme.of(context).textTheme.headlineLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 14),
            Text(
              'Please activate the location feature so we can find your home address.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: LightColorTokens.textSecondary,
              ),
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () => setState(() => _showLocationPrompt = false),
              style: FilledButton.styleFrom(
                backgroundColor: LightColorTokens.primary,
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(54),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(27),
                ),
              ),
              child: const Text('Enable Location'),
            ),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: () => setState(() => _showLocationPrompt = false),
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFFF1F4FE),
                foregroundColor: LightColorTokens.primary,
                minimumSize: const Size.fromHeight(54),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(27),
                ),
              ),
              child: const Text('Not Now'),
            ),
          ],
        ),
      ),
    ),
  );

  Widget _buildSuccess(BuildContext context) => Scaffold(
    backgroundColor: Colors.white,
    body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        child: SignUpSuccessView(onTap: _finishSignUp),
      ),
    ),
  );
}
