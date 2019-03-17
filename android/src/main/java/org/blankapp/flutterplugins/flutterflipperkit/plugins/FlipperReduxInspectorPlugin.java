package org.blankapp.flutterplugins.flutterflipperkit.plugins;

import com.facebook.flipper.core.FlipperConnection;
import com.facebook.flipper.core.FlipperObject;
import com.facebook.flipper.core.FlipperPlugin;

import org.json.JSONArray;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.HashMap;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class FlipperReduxInspectorPlugin implements FlipperPlugin {
    public static final String ID = "ReduxInspector";

    private FlipperConnection flipperConnection;

    @Override
    public String getId() {
        return ID;
    }

    @Override
    public void onConnect(FlipperConnection connection) throws Exception {
        this.flipperConnection = connection;
    }

    @Override
    public void onDisconnect() throws Exception {
        this.flipperConnection = null;
    }

    @Override
    public boolean runInBackground() {
        return false;
    }

    public void handleMethodCall(MethodCall call, MethodChannel.Result result) {
        if (call.method.endsWith("Report")) {
            final FlipperObject actionObject =
                    new FlipperObject.Builder()
                            .put("uniqueId", call.argument("uniqueId"))
                            .put("actionType", call.argument("actionType"))
                            .put("timeStamp", call.argument("timeStamp"))
                            .put("payload", this.convertJsonToString(call, "payload"))
                            .put("prevState", this.convertJsonToString(call, "prevState"))
                            .put("nextState", this.convertJsonToString(call, "nextState"))
                            .build();

            this.flipperConnection.send("newAction", actionObject);
            result.success(true);
        }
    }

    private String convertJsonToString(MethodCall call, String key) {
        String stateString = null;
        if (call.hasArgument(key)) {
            try {
                Object argState = call.argument(key);

                if (argState instanceof HashMap) {
                    stateString = new JSONObject((HashMap) argState).toString();
                } else if (argState instanceof ArrayList) {
                    stateString = new JSONArray((ArrayList) argState).toString();
                }
            } catch (ClassCastException e) { }

            if (stateString == null) {
                try {
                    stateString = call.argument(key);
                } catch (NullPointerException e) { }
            }
        }

        return stateString;
    }
}
