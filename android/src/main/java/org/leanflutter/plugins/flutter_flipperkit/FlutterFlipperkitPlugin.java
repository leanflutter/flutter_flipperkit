package org.leanflutter.plugins.flutter_flipperkit;

import android.content.Context;

import androidx.annotation.NonNull;

import com.facebook.flipper.android.AndroidFlipperClient;
import com.facebook.flipper.android.utils.FlipperUtils;
import com.facebook.flipper.core.FlipperClient;
import com.facebook.flipper.plugins.network.NetworkFlipperPlugin;
import com.facebook.flipper.plugins.network.NetworkReporter;
import com.facebook.flipper.plugins.sharedpreferences.SharedPreferencesFlipperPlugin;
import com.facebook.soloader.SoLoader;

import org.leanflutter.plugins.flutter_flipperkit.plugins.FlipperDatabaseBrowserPlugin;
import org.leanflutter.plugins.flutter_flipperkit.plugins.FlipperReduxInspectorPlugin;
import org.json.JSONArray;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/**
 * FlutterFlipperkitPlugin
 */
public class FlutterFlipperkitPlugin implements FlutterPlugin, MethodCallHandler, EventChannel.StreamHandler {
    private static final String CHANNEL_NAME = "flutter_flipperkit";
    private static final String EVENT_CHANNEL_NAME = "flutter_flipperkit/event_channel";

    private Context context;
    private MethodChannel channel;
    private EventChannel eventChannel;

    private EventChannel.EventSink eventSink;

    private FlipperClient flipperClient;
    private NetworkFlipperPlugin networkFlipperPlugin;
    private SharedPreferencesFlipperPlugin sharedPreferencesFlipperPlugin;

    private FlipperDatabaseBrowserPlugin flipperDatabaseBrowserPlugin;
    private FlipperReduxInspectorPlugin flipperReduxInspectorPlugin;

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        this.setupChannel(flutterPluginBinding.getBinaryMessenger(), flutterPluginBinding.getApplicationContext());
    }

    // This static function is optional and equivalent to onAttachedToEngine. It supports the old
    // pre-Flutter-1.12 Android projects. You are encouraged to continue supporting
    // plugin registration via this function while apps migrate to use the new Android APIs
    // post-flutter-1.12 via https://flutter.dev/go/android-project-migration.
    //
    // It is encouraged to share logic between onAttachedToEngine and registerWith to keep
    // them functionally equivalent. Only one of onAttachedToEngine or registerWith will be called
    // depending on the user's project. onAttachedToEngine or registerWith must both be defined
    // in the same class.
    public static void registerWith(Registrar registrar) {
        final FlutterFlipperkitPlugin plugin = new FlutterFlipperkitPlugin();
        plugin.setupChannel(registrar.messenger(), registrar.activeContext());
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
        if (!FlipperUtils.shouldEnableFlipper(context)) {
            result.success(true);
            return;
        }

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
                } else if (argBody instanceof ArrayList) {
                    bodyString = new JSONArray((ArrayList) argBody).toString();
                }
            } catch (ClassCastException e) {
            }

            if (bodyString == null) {
                try {
                    bodyString = call.argument("body");
                } catch (NullPointerException e) {
                }
            }
        }

        return bodyString != null ? bodyString.getBytes() : null;
    }

    private List<NetworkReporter.Header> convertHeader(MethodCall call) {
        Map<String, Object> argHeaders = call.argument("headers");
        List<NetworkReporter.Header> list = new ArrayList<>();

        if (argHeaders != null) {
            Set<String> keys = argHeaders.keySet();
            for (String key : keys) {
                Object value = argHeaders.get(key);

                String valueString;
                if (value instanceof ArrayList) {
                    List values = (ArrayList) value;
                    StringBuilder builder = new StringBuilder();
                    for (Object obj : values) {
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
        flipperDatabaseBrowserPlugin.setEventSink(this.eventSink);
    }

    @Override
    public void onCancel(Object args) {
        this.eventSink = null;
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        this.teardownChannel();
    }

    private void setupChannel(BinaryMessenger messenger, Context context) {
        this.context = context;
        SoLoader.init(context.getApplicationContext(), false);
        if (BuildConfig.DEBUG && FlipperUtils.shouldEnableFlipper(context)) {
            flipperClient = AndroidFlipperClient.getInstance(context);
            networkFlipperPlugin = new NetworkFlipperPlugin();
            sharedPreferencesFlipperPlugin = new SharedPreferencesFlipperPlugin(context, "FlutterSharedPreferences");

            flipperDatabaseBrowserPlugin = new FlipperDatabaseBrowserPlugin();
            flipperReduxInspectorPlugin = new FlipperReduxInspectorPlugin();
        }

        this.channel = new MethodChannel(messenger, CHANNEL_NAME);
        this.channel.setMethodCallHandler(this);

        this.eventChannel = new EventChannel(messenger, EVENT_CHANNEL_NAME);
        this.eventChannel.setStreamHandler(this);
    }

    private void teardownChannel() {
        this.channel.setMethodCallHandler(null);
        this.channel = null;
        this.eventChannel.setStreamHandler(null);
        this.eventChannel = null;
    }
}
