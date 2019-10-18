package com.connecthings.flutter.herow_example;

import android.Manifest;
import android.os.Build;

import com.connecthings.herow.HerowInitializer;
import com.connecthings.util.connection.Url;

import io.flutter.app.FlutterApplication;

public class FlutterApp extends FlutterApplication {
    public void onCreate() {
        super.onCreate();

        final HerowInitializer herowInitializer = HerowInitializer.getInstance();

        herowInitializer.initContext(this)
                .initUrlType(Url.UrlType.PRE_PROD)
                .initApp("SDK_ID", "SDK_KEY")
                .synchronize();

        herowInitializer.addPermissionToAsk(Manifest.permission.ACCESS_FINE_LOCATION);
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            herowInitializer.addPermissionToAsk(Manifest.permission.ACCESS_BACKGROUND_LOCATION);
        }
    }
}