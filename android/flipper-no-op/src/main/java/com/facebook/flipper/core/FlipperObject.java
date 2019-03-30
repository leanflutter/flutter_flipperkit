package com.facebook.flipper.core;

public class FlipperObject {
    public FlipperObject(String jsonString) {}

    public static class Builder {
        public Builder() {
        }

        public Builder put(String name, Object obj) {
            return this;
        }

        public FlipperObject build() {
            return null;
        }
    }

    public String getString(String name) {
        return null;
    }

    public int getInt(String name) {
        return 0;
    }

    public long getLong(String name) {
        return 0;
    }

    public float getFloat(String name) {
        return 0;
    }

    public double getDouble(String name) {
        return 0;
    }

    public boolean getBoolean(String name) {
        return false;
    }

    public FlipperObject getObject(String name) {
        return null;
    }

    public FlipperArray getArray(String name) {
        return null;
    }

    public boolean contains(String name) {
        return false;
    }
}
