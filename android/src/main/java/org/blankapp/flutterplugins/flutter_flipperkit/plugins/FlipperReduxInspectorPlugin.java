package org.blankapp.flutterplugins.flutter_flipperkit.plugins;

import com.facebook.flipper.core.FlipperObject;
import com.facebook.flipper.plugins.common.BufferingFlipperPlugin;

import org.json.JSONArray;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.HashMap;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class FlipperReduxInspectorPlugin extends BufferingFlipperPlugin {
    public static final String ID = "ReduxInspector";

    @Override
    public String getId() {
        return ID;
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

            this.send("newAction", actionObject);

            result.success(true);
        }
    }

    private String convertJsonToString(MethodCall call, String key) {
        String stateString = null;
        if (call.hasArgument(key)) {
            try {
                Object argValue = call.argument(key);

                if (argValue instanceof HashMap) {
                    stateString = new JSONObject((HashMap) argValue).toString();
                } else if (argValue instanceof ArrayList) {
                    stateString = new JSONArray((ArrayList) argValue).toString();
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
