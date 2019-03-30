package com.facebook.flipper.plugins.sharedpreferences;

import android.content.Context;
import com.facebook.flipper.core.FlipperPlugin;
import com.facebook.flipper.core.FlipperConnection;

public class SharedPreferencesFlipperPlugin implements FlipperPlugin {
    public static final String ID = "Preferences";

    public SharedPreferencesFlipperPlugin(Context context, String name) {
        // No-op
    }

    @Override
    public String getId() {
        return ID;
    }

    @Override
    public void onConnect(FlipperConnection connection) throws Exception {

    }

    @Override
    public void onDisconnect() throws Exception {

    }

    @Override
    public boolean runInBackground() {
        return false;
    }
}
