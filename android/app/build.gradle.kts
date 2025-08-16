// android/app/build.gradle.kts (Kotlin DSL)

import java.util.Properties
import java.io.FileInputStream

// ---- تحميل بيانات keystore من key.properties ----
val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services")
}

android {
    namespace = "com.housie.permi.permi_app"
    compileSdk = 36
    ndkVersion = "27.0.12077973"

    defaultConfig {
        applicationId = "com.housie.permi.permi_app"
        minSdk = 23
        targetSdk = 36
        versionCode = 1
        versionName = "0.0.2"
    }
    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }
 signingConfigs {
        create("release") {
            // لو الملف موجود سنقرأ القيم، وإلا اتركها فاضية (أو ارمي خطأ)
            val keyAliasProp = keystoreProperties["keyAlias"] as String?
            val keyPasswordProp = keystoreProperties["keyPassword"] as String?
            val storeFileProp = keystoreProperties["storeFile"] as String?
            val storePasswordProp = keystoreProperties["storePassword"] as String?

            if (storeFileProp != null && keyAliasProp != null) {
                storeFile = file(storeFileProp)
                storePassword = storePasswordProp ?: ""
                keyAlias = keyAliasProp
                keyPassword = keyPasswordProp ?: ""
            } else {
                // يمكنك طباعة تحذير هنا إن أردت
                // println("⚠️ key.properties مفقود أو ناقص - سيتم البناء بدون توقيع release")
            }
        }
    }

    buildTypes {
        getByName("release") {
            signingConfig = signingConfigs.getByName("release")
            isMinifyEnabled = true
            isShrinkResources = true

            // NDK abiFilters بصياغة Kotlin DSL
            ndk {
                abiFilters += listOf("armeabi-v7a", "arm64-v8a", "x86_64")
            }
        }
    }
}

dependencies {
    // Firebase BoM
    implementation(platform("com.google.firebase:firebase-bom:34.0.0"))
    implementation("com.google.firebase:firebase-analytics")

    // AdMob
    implementation("com.google.android.gms:play-services-ads:24.4.0")
}

flutter {
    source = "../.."
}