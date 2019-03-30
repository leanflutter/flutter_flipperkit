package com.facebook.flipper.core;

public interface FlipperClient {
    void addPlugin(FlipperPlugin plugin);

    <T extends FlipperPlugin> T getPlugin(String id);

    <T extends FlipperPlugin> T getPluginByClass(Class<T> cls);

    void removePlugin(FlipperPlugin plugin);

    void start();

    void stop();

    void subscribeForUpdates(FlipperStateUpdateListener stateListener);

    void unsubscribe();

    String getState();

    StateSummary getStateSummary();
}
