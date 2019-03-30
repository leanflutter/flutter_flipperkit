package com.facebook.flipper.android;

import com.facebook.flipper.core.FlipperClient;
import com.facebook.flipper.core.FlipperPlugin;
import com.facebook.flipper.core.FlipperStateUpdateListener;
import com.facebook.flipper.core.StateSummary;
import java.util.HashMap;
import java.util.Map;

class FlipperClientImpl implements FlipperClient {
    private FlipperClientImpl(Object hd) {
    }

    public static FlipperClientImpl getInstance() {
        return new FlipperClientImpl(null);
    }

    @Override
    public void addPlugin(FlipperPlugin plugin) {
        // No-op
    }

    @Override
    public <T extends FlipperPlugin> T getPlugin(String id) {
        // No-op
        return null;
    }

    @Override
    public <T extends FlipperPlugin> T getPluginByClass(Class<T> cls) {
        // No-op
        return getPlugin(null);
    }

    @Override
    public void removePlugin(FlipperPlugin plugin) {
        // No-op
    }

    @Override
    public void start() {
        // No-op
    }

    @Override
    public void stop() {
        // No-op
    }

    @Override
    public void subscribeForUpdates(FlipperStateUpdateListener stateListener) {
        // No-op
    }

    @Override
    public void unsubscribe() {
        // No-op
    }

    @Override
    public String getState() {
        // No-op
        return null;
    }

    @Override
    public StateSummary getStateSummary() {
        // No-op
        return null;
    }
}
