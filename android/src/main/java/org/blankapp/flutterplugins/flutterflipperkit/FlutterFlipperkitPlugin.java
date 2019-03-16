package org.blankapp.flutterplugins.flutterflipperkit;

import android.app.Activity;
import android.content.Context;

import com.facebook.flipper.android.AndroidFlipperClient;
import com.facebook.flipper.android.utils.FlipperUtils;
import com.facebook.flipper.core.FlipperClient;
import com.facebook.flipper.plugins.network.NetworkFlipperPlugin;
import com.facebook.flipper.plugins.network.NetworkReporter;
import com.facebook.flipper.plugins.sharedpreferences.SharedPreferencesFlipperPlugin;
import com.facebook.soloader.SoLoader;

import org.blankapp.flutterplugins.flutterflipperkit.plugins.FlipperReduxInspectorPlugin;
import org.json.JSONArray;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/**
 * FlutterFlipperkitPlugin
 */
public class FlutterFlipperkitPlugin implements MethodCallHandler {
    private final Activity activity;

    private FlipperClient flipperClient;
    private NetworkFlipperPlugin networkFlipperPlugin;
    private FlipperReduxInspectorPlugin flipperReduxInspectorPlugin;
    private SharedPreferencesFlipperPlugin sharedPreferencesFlipperPlugin;

    public FlutterFlipperkitPlugin(Activity activity) {
        this.activity = activity;
        SoLoader.init(activity.getApplication(), false);
        if (BuildConfig.DEBUG && FlipperUtils.shouldEnableFlipper(activity)) {
            flipperClient = AndroidFlipperClient.getInstance(activity);
            networkFlipperPlugin = new NetworkFlipperPlugin();
            flipperReduxInspectorPlugin = new FlipperReduxInspectorPlugin();
            sharedPreferencesFlipperPlugin = new SharedPreferencesFlipperPlugin(activity, "FlutterSharedPreferences");
        }
    }

    /**
     * Plugin registration.
     */
    public static void registerWith(Registrar registrar) {
        final MethodChannel channel = new MethodChannel(registrar.messenger(), "flutter_flipperkit");
        channel.setMethodCallHandler(new FlutterFlipperkitPlugin(registrar.activity()));
    }

    @Override
    public void onMethodCall(MethodCall call, Result result) {
        final String method = call.method;

        if (method.startsWith("pluginReduxInspector")) {
            flipperReduxInspectorPlugin.handleMethodCall(call, result);
            return;
        }

        switch (method) {
            case "clientAddPlugin":
                this.clientAddPlugin(call, result);
                break;
            case "clientStart":
                this.clientStart(call, result);
                break;
            case "clientStop":
                this.clientStop(call, result);
                break;
            case "pluginNetworkReportRequest":
                this.pluginNetworkReportRequest(call, result);
                break;
            case "pluginNetworkReportResponse":
                this.pluginNetworkReportResponse(call, result);
                break;
            default:
                result.notImplemented();
        }
    }

    private void clientAddPlugin(MethodCall call, Result result) {
        if (call.hasArgument("id")) {
            final String pluginId = call.argument("id");
            if (pluginId == null) {
                result.error("", "", "");
                return;
            }
            switch (pluginId) {
                case NetworkFlipperPlugin.ID:
                    if (flipperClient.getPlugin(NetworkFlipperPlugin.ID) != null) {
                        flipperClient.removePlugin(networkFlipperPlugin);
                    }
                    flipperClient.addPlugin(networkFlipperPlugin);
                    break;
                case FlipperReduxInspectorPlugin.ID:
                    if (flipperClient.getPlugin(FlipperReduxInspectorPlugin.ID) != null) {
                        flipperClient.removePlugin(flipperReduxInspectorPlugin);
                    }
                    flipperClient.addPlugin(flipperReduxInspectorPlugin);
                    break;
                case "Preferences":
                    if (flipperClient.getPlugin("Preferences") != null) {
                        flipperClient.removePlugin(sharedPreferencesFlipperPlugin);
                    }
                    flipperClient.addPlugin(sharedPreferencesFlipperPlugin);
                    break;
            }
        }

        result.success(true);
    }

    private void clientStart(MethodCall call, Result result) {
        flipperClient.start();

        result.success(true);
    }

    private void clientStop(MethodCall call, Result result) {
        flipperClient.stop();

        result.success(true);
    }

    private void pluginNetworkReportRequest(MethodCall call, Result result) {
        final String identifier = call.argument("requestId");
        networkFlipperPlugin.reportRequest(convertRequest(call, identifier));

        result.success(true);
    }

    private void pluginNetworkReportResponse(MethodCall call, Result result) {
        final String identifier = call.argument("requestId");
        networkFlipperPlugin.reportResponse(convertResponse(call, identifier));

        result.success(true);
    }

    private NetworkReporter.RequestInfo convertRequest(MethodCall call, String identifier) {
        NetworkReporter.RequestInfo info = new NetworkReporter.RequestInfo();

        List<NetworkReporter.Header> headers = convertHeader(call);
        byte[] body = convertBody(call);

        info.requestId = identifier;
        info.timeStamp = call.argument("timeStamp");
        info.headers = headers;
        info.method = call.argument("method");
        info.uri = call.argument("uri");
        info.body = body;
        return info;
    }

    private NetworkReporter.ResponseInfo convertResponse(MethodCall call, String identifier) {
        NetworkReporter.ResponseInfo info = new NetworkReporter.ResponseInfo();

        List<NetworkReporter.Header> headers = convertHeader(call);
        byte[] body = convertBody(call);

        info.requestId = identifier;
        info.timeStamp = call.argument("timeStamp");
        info.statusCode = call.argument("statusCode");
        info.headers = headers;
        info.body = body;
        return info;
    }

    private byte[] convertBody(MethodCall call) {
        String bodyString = null;
        if (call.hasArgument("body")) {
            try {
                Object argBody = call.argument("body");

                if (argBody instanceof HashMap) {
                    bodyString = new JSONObject((HashMap) argBody).toString();
                } else if (argBody instanceof  ArrayList) {
                    bodyString = new JSONArray((ArrayList) argBody).toString();
                }
            } catch (ClassCastException e) { }

            if (bodyString == null) {
                try {
                    bodyString = call.argument("body");
                } catch (NullPointerException e) { }
            }
        }

        return bodyString != null ? bodyString.getBytes() : null;
    }

    private List<NetworkReporter.Header> convertHeader(MethodCall call) {
        Map<String, String> argHeaders = call.argument("headers");
        List<NetworkReporter.Header> list = new ArrayList<>();;

        if (argHeaders != null) {
            Set<String> keys = argHeaders.keySet();
            for (String key : keys) {
                list.add(new NetworkReporter.Header(key, argHeaders.get(key)));
            }
        }
        return list;
    }
}
