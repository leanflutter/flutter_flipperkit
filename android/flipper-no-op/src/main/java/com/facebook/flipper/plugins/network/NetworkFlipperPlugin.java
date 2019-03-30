package com.facebook.flipper.plugins.network;

import com.facebook.flipper.core.FlipperPlugin;
import com.facebook.flipper.core.FlipperConnection;

public class NetworkFlipperPlugin implements FlipperPlugin, NetworkReporter {
    public static final String ID = "Network";

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

    public void reportRequest(RequestInfo requestInfo) {

    }

    public void reportResponse(final ResponseInfo responseInfo) {

    }
}
