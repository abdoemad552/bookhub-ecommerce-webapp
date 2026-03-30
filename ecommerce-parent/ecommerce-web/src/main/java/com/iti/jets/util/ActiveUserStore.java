package com.iti.jets.util;

import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;

public class ActiveUserStore {

    private static final Set<Long> activeUsers = ConcurrentHashMap.newKeySet();

    public static void addUser(Long userId) {
        activeUsers.add(userId);
    }

    public static void removeUser(Long userId) {
        activeUsers.remove(userId);
    }

    public static int count() {
        return activeUsers.size();
    }
}