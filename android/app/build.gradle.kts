plugins {
  id("com.android.application")
  id("kotlin-android")
  // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
  id("dev.flutter.flutter-gradle-plugin")
}

android {
  namespace = "net.satoyan.sweat_and_beers"
  compileSdk = flutter.compileSdkVersion
  ndkVersion = flutter.ndkVersion

  flavorDimensions("app")

  var appName = "Sweat & Beers"
  var flavors = listOf("local", "dev", "prod")

  productFlavors {
    flavors.forEach { flavor ->
      create(flavor) {
        dimension = "app"
        applicationIdSuffix = ".${flavor}"
        resValue(
          type="string",
          name="app_name",
          value = "${appName}-${flavor}"
        )
      }
    }
  }

  compileOptions {
    sourceCompatibility = JavaVersion.VERSION_11
    targetCompatibility = JavaVersion.VERSION_11
  }

  kotlinOptions { jvmTarget = JavaVersion.VERSION_11.toString() }

  defaultConfig {
    applicationId = "net.satoyan.sweat_and_beers"
    minSdk = flutter.minSdkVersion
    targetSdk = flutter.targetSdkVersion
    versionCode = flutter.versionCode
    versionName = flutter.versionName
    manifestPlaceholders["GOOGLE_MAPS_API_KEY"] = System.getenv("GOOGLE_PLACES_API_KEY")
  }

  signingConfigs {
    create("release") {
      storeFile = file(System.getenv("STORE_FILE"))
      storePassword = System.getenv("STORE_PASSWORD")
      keyAlias = System.getenv("KEY_ALIAS")
      keyPassword = System.getenv("KEY_PASSWORD")
    }
  }

  buildTypes {
    release {
      signingConfig = signingConfigs.getByName("release")
    }

    debug {
      signingConfig = signingConfigs.getByName("release")
    }
  }
}

flutter { source = "../.." }
