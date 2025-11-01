# Authentication Setup Instructions

## 📋 Prerequisites

Before using the authentication feature, you need to:

1. Set up Supabase project (if not already done)
2. Configure Google OAuth in Google Cloud Console
3. Configure Google OAuth in Supabase Dashboard
4. Update app configuration with your credentials

## 🔧 Step-by-Step Setup

### 1. Update Supabase Credentials

Edit `lib/core/constants/app_config.dart`:

```dart
class AppConfig {
  static const String supabaseUrl = 'https://YOUR_PROJECT_ID.supabase.co';
  static const String supabaseAnonKey = 'YOUR_ANON_KEY_HERE';
  
  static const String androidRedirectUrl = 'com.example.exam_ias://login-callback';
  static const String iosRedirectUrl = 'com.example.examIas://login-callback';
}
```

**Get your credentials:**
- Go to Supabase Dashboard → Your Project → Settings → API
- Copy the "Project URL" → `supabaseUrl`
- Copy the "anon public" key → `supabaseAnonKey`

### 2. Configure Google OAuth (Google Cloud Console)

Follow the detailed instructions in:
- `exam_ias_backend/auth.txt` (see Google Cloud Console Setup section)

**Quick Steps:**
1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Create a new project or select existing
3. Enable Google+ API
4. Create OAuth 2.0 credentials
5. Add authorized redirect URIs:
   - `https://YOUR_PROJECT_ID.supabase.co/auth/v1/callback`
   - For Android: `com.example.exam_ias://login-callback`
   - For iOS: `com.example.examIas://login-callback`

### 3. Configure Supabase Auth

1. Go to Supabase Dashboard → Authentication → Providers
2. Enable Google provider
3. Add your Google OAuth credentials:
   - Client ID (from Google Cloud Console)
   - Client Secret (from Google Cloud Console)

### 4. Update Android Package Name (Important!)

**Current package name**: `com.example.exam_ias`

**You should change this to your unique package name** for production!

1. Update `android/app/build.gradle`:
```gradle
applicationId = "com.yourcompany.iastest"
```

2. Update `AndroidManifest.xml` deep link scheme:
```xml
<data android:scheme="com.yourcompany.iastest" />
```

3. Update `AppConfig` redirect URLs:
```dart
static const String androidRedirectUrl = 'com.yourcompany.iastest://login-callback';
```

4. Update Google Cloud Console OAuth redirect URIs to match new package name

### 5. Run the App

```bash
# Install dependencies
flutter pub get

# Run on device/emulator
flutter run
```

## 🔍 How It Works

1. **Login Page**: User taps "Continue with Google"
2. **OAuth Flow**: App opens browser for Google Sign-In
3. **Callback**: Google redirects back to app via deep link
4. **Session**: Supabase creates session and stores user
5. **Navigation**: Router automatically redirects to home page

## 🐛 Troubleshooting

### Issue: "Google Sign-In failed"
- Check Supabase credentials in `app_config.dart`
- Verify Google OAuth is enabled in Supabase
- Check redirect URLs match in Google Cloud Console

### Issue: "Redirect URL mismatch"
- Ensure redirect URL in `app_config.dart` matches:
  - Android package name in `build.gradle`
  - Deep link scheme in `AndroidManifest.xml`
  - Redirect URI in Google Cloud Console

### Issue: App doesn't redirect after sign-in
- Check deep link configuration in `AndroidManifest.xml`
- Verify package name consistency across all files
- Test deep link manually: `adb shell am start -a android.intent.action.VIEW -d "com.example.exam_ias://login-callback"`

### Issue: "Session not found" after sign-in
- Check Supabase URL is correct
- Verify anon key is correct
- Check Supabase project is active
- Look at debug console for detailed error messages

## 📱 Testing

1. **Test Login Flow:**
   - Launch app
   - Should show login page first
   - Tap "Continue with Google"
   - Complete Google sign-in
   - Should redirect to home page

2. **Test Logout:**
   - Go to Profile page
   - Tap Logout
   - Confirm logout
   - Should redirect to login page

3. **Test Auth Persistence:**
   - Sign in
   - Close app completely
   - Reopen app
   - Should stay logged in (go to home, not login)

## ✅ Verification Checklist

- [ ] Supabase URL and key updated in `app_config.dart`
- [ ] Google OAuth configured in Google Cloud Console
- [ ] Google provider enabled in Supabase Dashboard
- [ ] Package name updated (if changed)
- [ ] Deep link configured in `AndroidManifest.xml`
- [ ] Redirect URLs match everywhere
- [ ] App runs without errors
- [ ] Login flow works end-to-end
- [ ] Logout works
- [ ] Session persists after app restart

## 📚 Additional Resources

- Supabase Auth Docs: https://supabase.com/docs/guides/auth
- Flutter Supabase: https://supabase.com/docs/reference/dart
- Google OAuth Setup: See `exam_ias_backend/auth.txt`

