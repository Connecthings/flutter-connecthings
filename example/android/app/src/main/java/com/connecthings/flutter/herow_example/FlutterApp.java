package com.connecthings.flutter.herow_example;

import android.Manifest;

import com.connecthings.herow.HerowInitializer;
import com.connecthings.util.connection.Url;

import io.flutter.app.FlutterApplication;

public class FlutterApp extends FlutterApplication {

    public void onCreate() {
        super.onCreate();
        HerowInitializer.getInstance().initContext(this)
                .initUrlType(Url.UrlType.PRE_PROD)
                .initApp("SDK_ID", "SDK_KEY")
                .synchronize();
        HerowInitializer.getInstance().addPermissionToAsk(Manifest.permission.ACCESS_FINE_LOCATION);
    }
}