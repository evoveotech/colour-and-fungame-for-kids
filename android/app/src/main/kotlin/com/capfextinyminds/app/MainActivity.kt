package com.capfextinyminds.app

import android.os.Bundle
import androidx.core.view.WindowCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine

class MainActivity : FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        // Turant NormalTheme apply karo taaki LaunchTheme (splash) minimize ho
        setTheme(android.R.style.Theme_Black_NoTitleBar)
        super.onCreate(savedInstanceState)
        // Allow Flutter content to draw edge-to-edge.
        WindowCompat.setDecorFitsSystemWindows(window, false)
    }
    
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        // Flutter engine ready hone ke turant baad splash screen hide karo
        // OpeningVideoScreen turant dikhegi
    }
}
