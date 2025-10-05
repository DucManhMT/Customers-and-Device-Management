package crm.core.utils;

public class KeyGenerator {
    private static final Object lock = new Object();
    private static final long CUSTOM_EPOCH = 1756771200; // Tuesday, 2 September 2025 00:00:00
    private static final long MAX_COUNTER = 999;
    private static long lastTimestamp = -1L;
    private static long counter = 0;

    public static long nextId() {
        synchronized (lock) {
            long timestamp = currentTimestamp();
            if (timestamp < lastTimestamp) {
                throw new IllegalArgumentException("There is no time travel allowed!");
            } else if (timestamp == lastTimestamp) {
                counter++;
                if (counter > MAX_COUNTER) {
                    timestamp = waitNextMillis(lastTimestamp);
                    counter = 0;
                }
            } else {
                counter = 0;
            }
            lastTimestamp = timestamp;
            return (timestamp * 1000) + counter;
        }
    }

    private static long currentTimestamp() {
        return System.currentTimeMillis() - CUSTOM_EPOCH;
    }

    private static long waitNextMillis(long lastTs) {
        long ts = currentTimestamp();
        while (ts <= lastTs) {
            ts = currentTimestamp();
        }
        return ts;
    }
}
