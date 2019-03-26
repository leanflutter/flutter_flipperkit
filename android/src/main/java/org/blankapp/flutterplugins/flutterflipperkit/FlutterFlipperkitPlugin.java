package org.blankapp.flutterplugins.flutterflipperkit;

import android.app.Activity;

import com.facebook.flipper.android.AndroidFlipperClient;
import com.facebook.flipper.android.utils.FlipperUtils;
import com.facebook.flipper.core.FlipperClient;
import com.facebook.flipper.plugins.network.NetworkFlipperPlugin;
import com.facebook.flipper.plugins.network.NetworkReporter;
import com.facebook.flipper.plugins.sharedpreferences.SharedPreferencesFlipperPlugin;
import com.facebook.soloader.SoLoader;

import org.blankapp.flutterplugins.flutterflipperkit.plugins.FlipperDatabaseBrowserPlugin;
import org.blankapp.flutterplugins.flutterflipperkit.plugins.FlipperReduxInspectorPlugin;
import org.json.JSONArray;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/**
 * FlutterFlipperkitPlugin
 */
public class FlutterFlipperkitPlugin implements MethodCallHandler, EventChannel.StreamHandler {
    private EventChannel.EventSink eventSink;

    private FlipperClient flipperClient;
    private NetworkFlipperPlugin networkFlipperPlugin;
    private SharedPreferencesFlipperPlugin sharedPreferencesFlipperPlugin;

    private FlipperDatabaseBrowserPlugin flipperDatabaseBrowserPlugin;
    private FlipperReduxInspectorPlugin flipperReduxInspectorPlugin;

    public FlutterFlipperkitPlugin(Activity activity) {
        SoLoader.init(activity.getApplication(), false);
        if (BuildConfig.DEBUG && FlipperUtils.shouldEnableFlipper(activity)) {
            flipperClient = AndroidFlipperClient.getInstance(activity);
            networkFlipperPlugin = new NetworkFlipperPlugin();
            sharedPreferencesFlipperPlugin = new SharedPreferencesFlipperPlugin(activity, "FlutterSharedPreferences");

            flipperDatabaseBrowserPlugin = new FlipperDatabaseBrowserPlugin();
            flipperReduxInspectorPlugin = new FlipperReduxInspectorPlugin();
        }
    }

    /**
     * Plugin registration.
     */
    public static void registerWith(Registrar registrar) {
        final FlutterFlipperkitPlugin flipperkitPlugin = new FlutterFlipperkitPlugin(registrar.activity());
        final MethodChannel channel = new MethodChannel(registrar.messenger(), "flutter_flipperkit");
        channel.setMethodCallHandler(flipperkitPlugin);

        final EventChannel eventChannel = new EventChannel(registrar.messenger(), "flutter_flipperkit/event_channel");
        eventChannel.setStreamHandler(flipperkitPlugin);
    }

    @Override
    public void onMethodCall(MethodCall call, Result result) {
        final String method = call.method;

        if (method.startsWith("pluginDatabaseBrowser")) {
            flipperDatabaseBrowserPlugin.handleMethodCall(call, result);
            return;
        } else if (method.startsWith("pluginReduxInspector")) {
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
            // 当插件已经添加时，避免再次添加
            if (flipperClient.getPlugin(pluginId) != null) {
                result.success(true);
                return;
            }
            switch (pluginId) {
                case NetworkFlipperPlugin.ID:
                    flipperClient.addPlugin(networkFlipperPlugin);
                    break;
                case "Preferences":
                    flipperClient.addPlugin(sharedPreferencesFlipperPlugin);
                    break;
                case FlipperDatabaseBrowserPlugin.ID:
                    flipperClient.addPlugin(flipperDatabaseBrowserPlugin);
                    break;
                case FlipperReduxInspectorPlugin.ID:
                    flipperClient.addPlugin(flipperReduxInspectorPlugin);
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
        Map<String, Object> argHeaders = call.argument("headers");
        List<NetworkReporter.Header> list = new ArrayList<>();;

        if (argHeaders != null) {
            Set<String> keys = argHeaders.keySet();
            for (String key : keys) {
                Object value = argHeaders.get(key);

                String valueString;
                if (value instanceof ArrayList) {
                    List values = (ArrayList) value;
                    StringBuilder builder = new StringBuilder();
                    for(Object obj : values) {
                        builder.append(obj);
                    }
                    valueString = builder.toString();
                } else {
                    valueString = (String) value;
                }
                list.add(new NetworkReporter.Header(key, valueString));
            }
        }
        return list;
    }

    @Override
    public void onListen(Object args, EventChannel.EventSink eventSink) {
        this.eventSink = eventSink;
        flipperDatabaseBrowserPlugin.setEventSink(eventSink);
    }

    @Override
    public void onCancel(Object args) {
        this.eventSink = null;
    }
}
