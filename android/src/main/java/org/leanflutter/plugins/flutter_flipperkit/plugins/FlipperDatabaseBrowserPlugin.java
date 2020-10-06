package org.leanflutter.plugins.flutter_flipperkit.plugins;

import android.app.Activity;
import android.content.Context;
import android.os.Handler;
import android.os.Looper;
import android.util.Log;

import androidx.annotation.MainThread;

import com.facebook.flipper.core.FlipperArray;
import com.facebook.flipper.core.FlipperConnection;
import com.facebook.flipper.core.FlipperObject;
import com.facebook.flipper.core.FlipperPlugin;
import com.facebook.flipper.core.FlipperReceiver;
import com.facebook.flipper.core.FlipperResponder;

import org.json.JSONArray;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class FlipperDatabaseBrowserPlugin implements FlipperPlugin {
    public static final String ID = "DatabaseBrowser";

    private EventChannel.EventSink eventSink;
    private FlipperConnection flipperConnection;

    @Override
    public String getId() {
        return ID;
    }

    @Override
    public void onConnect(FlipperConnection connection) throws Exception {
        Log.d("DatabaseBrowserPlugin", "onConnect");
        this.flipperConnection = connection;
        this.flipperConnection.receive("execQuery", new FlipperReceiver() {
            @Override
            public void onReceive(FlipperObject params, FlipperResponder responder) throws Exception {
                final Map<String, Object> map = new HashMap<>();
                map.put("action", params.getString("action"));
                map.put("table", params.getString("table"));
                if (params.contains("limit")) {
                    map.put("limit", params.getInt("limit"));
                }
                if (params.contains("offset")) {
                    map.put("offset", params.getInt("offset"));
                }

                new Handler(Looper.getMainLooper()).post(new Runnable() {
                    @Override
                    public void run() {
                        eventSink.success(map);
                    }
                });
            }
        });
    }

    @Override
    public void onDisconnect() throws Exception {
        this.flipperConnection = null;
    }

    @Override
    public boolean runInBackground() {
        return false;
    }

    public void setEventSink(EventChannel.EventSink eventSink) {
        this.eventSink = eventSink;
    }


    public void handleMethodCall(MethodCall call, MethodChannel.Result result) {
        if (call.method.endsWith("ReportQueryResult")) {
            String jsonString = new JSONArray((ArrayList) call.argument("results")).toString();
            FlipperArray results = new FlipperArray(jsonString);

            final FlipperObject flipperObject =
                    new FlipperObject.Builder()
                            .put("action", call.argument("action"))
                            .put("table", call.argument("table"))
                            .put("results", results)
                            .build();

            this.sendData("newQueryResult", flipperObject);
        }
        result.success(true);
    }

    private void sendData(String method, FlipperObject data) {
        if (this.flipperConnection == null) return;

        this.flipperConnection.send(method, data);
    }
}
