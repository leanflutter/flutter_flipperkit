package com.facebook.flipper.android;

import android.content.Context;
import android.content.pm.PackageManager;
import android.net.wifi.WifiInfo;
import android.net.wifi.WifiManager;
import android.os.Build;
import android.util.Log;
import com.facebook.flipper.core.FlipperClient;

public final class AndroidFlipperClient {
    public static synchronized FlipperClient getInstance(Context context) {
        return FlipperClientImpl.getInstance();
    }

    public static synchronized FlipperClient getInstanceIfInitialized() {
        return FlipperClientImpl.getInstance();
    }
}
