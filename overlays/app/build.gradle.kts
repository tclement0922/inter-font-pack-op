plugins {
    id("com.android.application")
}

android {
    compileSdk = 30

    signingConfigs {
        maybeCreate("debug")
        getByName("debug") {
            storeFile = rootProject.file("keystore.jks")
            storePassword = "keystore"
            keyAlias = "defaultDebug"
            keyPassword = "keystore"
        }
        maybeCreate("release")
        getByName("release") {
            storeFile = rootProject.file("keystore.jks")
            storePassword = "keystore"
            keyAlias = "defaultRelease"
            keyPassword = "keystore"
        }
    }

    buildTypes {
        getByName("release") {
            isMinifyEnabled = true
        }
    }

    defaultConfig {
        minSdk = 30
        targetSdk = 30
        versionCode = 1
        versionName = "1.0"
    }

    setFlavorDimensions(listOf("package"))
    // Add a product flavor per package name registered in the file overlays.txt
    for (packageName in rootProject.file("overlays.txt").readLines().filter { it.isNotBlank() }) {
        productFlavors.register(packageName.replace('.', '_')) {
            dimension = "package"
            applicationId = "$packageName.InterFontOverlay"
            signingConfig = signingConfigs.getByName("release")
            manifestPlaceholders["overlayTarget"] = packageName
        }
    }
}