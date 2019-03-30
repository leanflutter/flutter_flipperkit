package com.facebook.flipper.core;

public interface FlipperReceiver {
    void onReceive(FlipperObject params, FlipperResponder responder) throws Exception;
}
