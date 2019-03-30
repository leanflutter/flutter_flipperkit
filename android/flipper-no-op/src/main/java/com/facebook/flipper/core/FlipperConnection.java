package com.facebook.flipper.core;

public interface FlipperConnection {

    void send(String method, Object params);

    void reportError(Throwable throwable);

    void receive(String method, Object receiver);
}
