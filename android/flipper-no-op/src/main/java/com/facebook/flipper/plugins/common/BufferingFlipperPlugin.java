package com.facebook.flipper.plugins.common;

import com.facebook.flipper.core.FlipperConnection;
import com.facebook.flipper.core.FlipperObject;
import com.facebook.flipper.core.FlipperPlugin;

public abstract class BufferingFlipperPlugin implements FlipperPlugin {
    @Override
    public String getId() {
        return null;
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

    public synchronized void send(String method, FlipperObject flipperObject) {
    }

    private synchronized void sendBufferedEvents() {
    }
}
