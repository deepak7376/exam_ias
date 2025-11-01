# 🌐 Web App Setup Guide

This guide will help you run and test the IAS Test Series app as a web application before deploying to mobile.

## 🚀 Quick Start

### 1. Run on Web

```bash
# Navigate to Flutter project
cd exam_ias

# Run on Chrome (default)
flutter run -d chrome

# Or specify port
flutter run -d chrome --web-port=3000

# Or run on any browser
flutter run -d web-server
```

### 2. Build for Web

```bash
# Build for production
flutter build web

# Output will be in: build/web/
```

### 3. Test OAuth on Web

1. Open the app in your browser (usually `http://localhost:3000`)
2. Click "Continue with Google"
3. Complete Google Sign-In in the same tab
4. You'll be redirected back to the app
5. The app will automatically navigate to the home page

## 🔧 Configuration

### Web Redirect URL Setup

The app automatically configures the redirect URL based on your current domain:

- **Development**: `http://localhost:3000/auth/callback`
- **Production**: `https://yourdomain.com/auth/callback`

### Supabase Configuration

1. **Update Redirect URLs in Supabase Dashboard:**
   - Go to Supabase Dashboard → Authentication → URL Configuration
   - Add your redirect URLs:
     - `http://localhost:3000/auth/callback` (for local development)
     - `https://yourdomain.com/auth/callback` (for production)

2. **Update Google Cloud Console:**
   - Go to Google Cloud Console → APIs & Services → Credentials
   - Edit your OAuth 2.0 Client ID
   - Add Authorized redirect URIs:
     - `https://ocavzxqubkefmuvbtyeo.supabase.co/auth/v1/callback`
     - `http://localhost:3000/auth/callback` (for local dev)
     - `https://yourdomain.com/auth/callback` (for production)

## 📝 Testing Checklist

- [ ] App runs on web without errors
- [ ] Login page displays correctly
- [ ] Google Sign-In button works
- [ ] OAuth redirect works (same tab)
- [ ] User is authenticated after sign-in
- [ ] Navigation to home page works after login
- [ ] Logout functionality works
- [ ] Session persists on page refresh
- [ ] All API calls work from web
- [ ] Responsive design works on different screen sizes

## 🌐 Deploy to Web

### Option 1: Firebase Hosting

```bash
# Install Firebase CLI
npm install -g firebase-tools

# Login to Firebase
firebase login

# Initialize Firebase in your project
firebase init hosting

# Build Flutter web app
flutter build web

# Deploy
firebase deploy --only hosting
```

### Option 2: Netlify

1. Build the app: `flutter build web`
2. Drag and drop `build/web` folder to Netlify
3. Or connect your Git repository for continuous deployment

### Option 3: Vercel

```bash
# Install Vercel CLI
npm i -g vercel

# Build Flutter web app
flutter build web

# Deploy
cd build/web
vercel
```

### Option 4: GitHub Pages

1. Build the app: `flutter build web --base-href "/your-repo-name/"`
2. Push `build/web` contents to `gh-pages` branch
3. Enable GitHub Pages in repository settings

## 🔍 Troubleshooting

### Issue: OAuth redirect fails

**Solution:**
- Check that redirect URL matches exactly in Supabase and Google Cloud Console
- Ensure `auth/callback` route is accessible
- Check browser console for errors

### Issue: CORS errors

**Solution:**
- Supabase should handle CORS automatically
- If issues persist, check Supabase project settings
- Ensure anon key is correctly configured

### Issue: Session not persisting

**Solution:**
- Check that Supabase is properly initialized
- Verify auth state listener is working
- Check browser localStorage (Supabase stores tokens there)

### Issue: App not loading

**Solution:**
- Run `flutter clean` and `flutter pub get`
- Check browser console for errors
- Verify all dependencies are installed

## 📱 Converting to Mobile

Once everything works on web:

1. **Test on Mobile Emulator:**
   ```bash
   flutter run -d android
   flutter run -d ios
   ```

2. **Update Package Name** (if needed):
   - Change from `com.example.exam_ias` to your unique package name
   - Update in `android/app/build.gradle`
   - Update redirect URLs in Google Cloud Console

3. **Test Deep Linking:**
   - Verify OAuth redirect works on mobile
   - Test that app opens from deep link

4. **Build for Production:**
   - Follow `playstore_launch_guide.txt` for Android
   - Follow iOS App Store guide for iOS

## 🎯 Web-Specific Features

The app automatically handles platform differences:

- **Web**: OAuth opens in same tab, redirects to `/auth/callback`
- **Mobile**: OAuth opens in external browser, redirects via deep link
- **Session Management**: Works seamlessly on both platforms

## 📚 Additional Resources

- [Flutter Web Documentation](https://docs.flutter.dev/platform-integration/web)
- [Supabase Auth for Flutter](https://supabase.com/docs/reference/dart/auth-signinwithoauth)
- [Deploying Flutter Web](https://docs.flutter.dev/deployment/web)

