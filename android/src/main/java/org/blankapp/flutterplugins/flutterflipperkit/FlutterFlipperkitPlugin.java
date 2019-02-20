package org.blankapp.flutterplugins.flutterflipperkit;

import android.app.Activity;

import com.facebook.flipper.android.AndroidFlipperClient;
import com.facebook.flipper.android.utils.FlipperUtils;
import com.facebook.flipper.core.FlipperClient;
import com.facebook.flipper.plugins.network.NetworkFlipperPlugin;
import com.facebook.flipper.plugins.network.NetworkReporter;
import com.facebook.soloader.SoLoader;

import org.json.JSONObject;

import java.util.ArrayList;
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

    public FlutterFlipperkitPlugin(Activity activity) {
        this.activity = activity;

        SoLoader.init(activity.getApplication(), false);
        if (BuildConfig.DEBUG && FlipperUtils.shouldEnableFlipper(activity)) {
            flipperClient = AndroidFlipperClient.getInstance(activity);
            networkFlipperPlugin = new NetworkFlipperPlugin();
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
                    flipperClient.addPlugin(networkFlipperPlugin);
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
        List<NetworkReporter.Header> headers = convertHeader(call);
        NetworkReporter.RequestInfo info = new NetworkReporter.RequestInfo();

        Map<String, Object> map = call.argument("body");
        JSONObject body = null;
        if (map != null) {
            body = new JSONObject(map);
        }

        info.requestId = identifier;
        info.timeStamp = call.argument("timeStamp");
        info.headers = headers;
        info.method = call.argument("method");
        info.uri = call.argument("uri");
        info.body = body != null ? body.toString().getBytes() : null;
        return info;
    }

    private NetworkReporter.ResponseInfo convertResponse(MethodCall call, String identifier) {
        List<NetworkReporter.Header> headers = convertHeader(call);

        if (headers.size() == 0) {
            headers.add(new NetworkReporter.Header("Content-Type", "application/json"));
        }

        Map<String, Object> map = call.argument("body");
        JSONObject body = null;
        if (map != null) {
            body = new JSONObject(map);
        }

        NetworkReporter.ResponseInfo info = new NetworkReporter.ResponseInfo();
        info.requestId = identifier;
        info.timeStamp = call.argument("timeStamp");
        info.statusCode = call.argument("statusCode");
        info.headers = headers;
        info.body = body != null ? body.toString().getBytes() : null;
        return info;
    }

    private List<NetworkReporter.Header> convertHeader(MethodCall call) {
        List<NetworkReporter.Header> list = new ArrayList<>();
        Map<String, String> headers = call.argument("headers");

        if (headers != null) {
            Set<String> keys = headers.keySet();
            for (String key : keys) {
                list.add(new NetworkReporter.Header(key, headers.get(key)));
            }
        }
        return list;
    }
}
