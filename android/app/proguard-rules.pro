# Flutter
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# Keep Supabase
-keep class io.supabase.** { *; }
-dontwarn io.supabase.**

# Keep HTTP
-keep class okhttp3.** { *; }
-dontwarn okhttp3.**

# Keep Kotlin
-keep class kotlin.** { *; }
-keep class kotlin.Metadata { *; }
-dontwarn kotlin.**
-keepclassmembers class **$WhenMappings {
    <fields>;
}

# Keep Google services
-keep class com.google.** { *; }
-dontwarn com.google.**

# Keep app classes
-keep class com.iastestseries.iaspilot.** { *; }

