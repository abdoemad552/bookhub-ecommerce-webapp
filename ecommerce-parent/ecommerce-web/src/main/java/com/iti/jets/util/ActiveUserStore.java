package com.iti.jets.util;

import java.util.Map;
import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;

public class ActiveUserStore {

    private static final Map<Long, Set<String>> userSessions =
            new ConcurrentHashMap<>();

    public static void addSession(Long userId, String sessionId) {
        userSessions
                .computeIfAbsent(userId, k -> ConcurrentHashMap.newKeySet())
                .add(sessionId);
    }

    public static void removeSession(Long userId, String sessionId) {
        Set<String> sessions = userSessions.get(userId);

        if (sessions != null) {
            sessions.remove(sessionId);

            if (sessions.isEmpty()) {
                userSessions.remove(userId);
            }
        }
    }

    public static int count() {
        return userSessions.size(); // number of logged-in users
    }
}