# ✅ Google OAuth Configuration Checklist

Follow these steps to fix the "Invalid Request" error:

## 🔍 Step 1: Google Cloud Console - Web Client Configuration

1. Go to: https://console.cloud.google.com/apis/credentials
2. Select your project
3. Click on your **Web Client ID** (the one you created for Supabase)
4. Verify **Authorized JavaScript origins** includes:
   ```
   https://ocavzxqubkefmuvbtyeo.supabase.co
   ```

5. Verify **Authorized redirect URIs** includes:
   ```
   https://ocavzxqubkefmuvbtyeo.supabase.co/auth/v1/callback
   ```

6. **IMPORTANT**: Remove any localhost URLs from redirect URIs (they don't work with Supabase OAuth)
7. Click **Save**

## 🔍 Step 2: Verify OAuth Consent Screen

1. Go to: https://console.cloud.google.com/apis/credentials/consent
2. Verify:
   - ✅ App name is set: "IAS Test Series" or "ExamIASapp"
   - ✅ User support email is set
   - ✅ Developer contact email is set
   - ✅ App is published OR you're added as a test user

3. If app is in "Testing" mode:
   - Go to "Test users" tab
   - Add your email address
   - Save

## 🔍 Step 3: Supabase Dashboard - Provider Configuration

1. Go to: https://app.supabase.com/project/ocavzxqubkefmuvbtyeo/auth/providers
2. Click on **Google** provider
3. Verify:
   - ✅ Toggle is **ON** (enabled)
   - ✅ **Client ID (for OAuth)** matches your Web Client ID from Google Cloud
   - ✅ **Client Secret (for OAuth)** matches your Web Client Secret from Google Cloud

4. Click **Save**

## 🔍 Step 4: Supabase Dashboard - URL Configuration

1. Go to: https://app.supabase.com/project/ocavzxqubkefmuvbtyeo/auth/url-configuration
2. Under **Redirect URLs**, add:
   ```
   http://localhost:3000/auth/callback
   http://localhost:8080/auth/callback
   http://localhost:5000/auth/callback
   ```
   (Add any ports you're using for development)

3. Click **Save**

## 🧪 Step 5: Test

1. Clear browser cache and cookies
2. Restart Flutter app:
   ```bash
   flutter run -d chrome --web-port=3000
   ```
3. Click "Continue with Google"
4. Should see Google OAuth page (not error)
5. Sign in with Google
6. Should redirect back to app at `/auth/callback`
7. Should then redirect to home page

## ❌ Common Issues

### Issue: Still getting "Invalid Request"
- **Fix**: Double-check Google Cloud Console redirect URI matches exactly: `https://ocavzxqubkefmuvbtyeo.supabase.co/auth/v1/callback`
- Remove any trailing slashes
- Case-sensitive - must be lowercase

### Issue: "redirect_uri_mismatch"
- **Fix**: The redirect URI in your app code doesn't match Google Cloud Console
- For web, Google redirects to Supabase, not your app directly
- Make sure Supabase callback URL is in Google Cloud Console

### Issue: OAuth consent screen error
- **Fix**: 
  - Go to OAuth consent screen
  - Make sure app name matches (check for typos)
  - Add yourself as test user if in testing mode
  - Publish app if ready (or keep in testing with test users)

### Issue: Can sign in but redirect doesn't work
- **Fix**: 
  - Check Supabase URL Configuration has your localhost URLs
  - Verify auth callback route is accessible
  - Check browser console for errors

## 📞 Need Help?

If still not working:
1. Check browser console for specific error messages
2. Check Flutter console output
3. Verify all URLs match exactly (case-sensitive)
4. Try using incognito/private browsing window
5. Clear all browser data for localhost

