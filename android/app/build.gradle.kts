// Tambahkan import ini di baris paling atas
import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    id("com.google.gms.google-services")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

// Helper function untuk membaca file local.properties
fun localProperties(): Properties {
    val properties = Properties()
    val localPropertiesFile = project.rootProject.file("local.properties")
    if (localPropertiesFile.exists()) {
        properties.load(FileInputStream(localPropertiesFile))
    }
    return properties
}

android {
    namespace = "com.example.final_project_sanbercode"
    compileSdk = flutter.compileSdkVersion.toInt()
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = "11"
    }

    defaultConfig {
        applicationId = "com.example.final_project_sanbercode"
        minSdk = 23
        targetSdk = flutter.targetSdkVersion.toInt()
        
        // Mengambil versi dari local.properties
        versionCode = (localProperties().getProperty("flutter.versionCode") ?: "1").toInt()
        versionName = localProperties().getProperty("flutter.versionName") ?: "1.0"
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}