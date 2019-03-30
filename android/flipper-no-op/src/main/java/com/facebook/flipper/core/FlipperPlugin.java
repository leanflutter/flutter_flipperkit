package com.facebook.flipper.core;

public interface FlipperPlugin {
    String getId();

    void onConnect(FlipperConnection connection) throws Exception;

    void onDisconnect() throws Exception;

    boolean runInBackground();
}
