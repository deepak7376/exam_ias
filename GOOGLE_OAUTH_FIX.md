# 🔧 Google OAuth "Invalid Request" Error - Fix Guide

## ❌ Error Message
```
Access blocked: ExamIASapp's request is invalid
```

## 🔍 Root Cause

This error occurs when the redirect URI sent to Google doesn't match what's configured in Google Cloud Console. For web apps using Supabase, the redirect flow is:

1. App → Supabase OAuth endpoint
2. Supabase → Google OAuth
3. Google → Supabase callback (`https://YOUR_PROJECT.supabase.co/auth/v1/callback`)
4. Supabase → Your app callback

The issue is that we're trying to redirect directly from Google to our app, but Google needs to redirect to Supabase first.

## ✅ Solution

### Step 1: Verify Google Cloud Console Configuration

1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Select your project
3. Go to **APIs & Services** → **Credentials**
4. Click on your **Web Client ID** (OAuth 2.0 Client)
5. In **Authorized redirect URIs**, ensure you have:

```
https://ocavzxqubkefmuvbtyeo.supabase.co/auth/v1/callback
```

**IMPORTANT**: 
- Do NOT add `http://localhost:3000/auth/callback` here
- The redirect URI must be the Supabase callback URL
- Google redirects to Supabase, then Supabase redirects to your app

6. In **Authorized JavaScript origins**, add:
```
https://ocavzxqubkefmuvbtyeo.supabase.co
```

7. Click **Save**

### Step 2: Update Supabase URL Configuration

1. Go to [Supabase Dashboard](https://app.supabase.com/)
2. Select your project: `ocavzxqubkefmuvbtyeo`
3. Go to **Authentication** → **URL Configuration**
4. In **Redirect URLs**, add:
```
http://localhost:3000/auth/callback
http://localhost:8080/auth/callback
```

(Add any other URLs you'll be using during development)

5. Click **Save**

### Step 3: Fix the Auth Service

The auth service needs to use the Supabase callback URL for the redirectTo parameter on web, or better yet, let Supabase handle it automatically.

## 🛠️ Quick Fix

For web, the `redirectTo` should be your app's URL where Supabase will redirect after authentication, not the Google redirect URL.

**The flow should be:**
- `redirectTo`: Your app URL (where Supabase redirects after processing)
- Google → Supabase callback (configured in Google Cloud)
- Supabase → Your app (the redirectTo URL)

## 📝 Verification Checklist

- [ ] Google Cloud Console has Supabase callback URL: `https://ocavzxqubkefmuvbtyeo.supabase.co/auth/v1/callback`
- [ ] Google Cloud Console has JavaScript origin: `https://ocavzxqubkefmuvbtyeo.supabase.co`
- [ ] Supabase Dashboard has your app URLs in Redirect URLs
- [ ] Google provider is enabled in Supabase
- [ ] Client ID and Secret are correctly set in Supabase

## 🔄 Testing

After making these changes:

1. Clear browser cache
2. Restart Flutter web app
3. Try signing in again
4. The flow should work:
   - Click "Continue with Google"
   - Google OAuth page opens
   - After sign-in, Google redirects to Supabase
   - Supabase processes and redirects to your app
   - You see the auth callback page briefly
   - You're redirected to home page

