package com.iti.jets.model.dto.response.factory;

import java.util.List;

public final class ResponseFactory {

    // Prevent instantiation
    private ResponseFactory() {}

    public static <T> BaseResponse<T> success(String message, T data) {
        return BaseResponse.<T>builder()
                .success(true)
                .message(message)
                .data(data)
                .build();
    }

    public static <Void> BaseResponse<Void> success(String message) {
        return BaseResponse.<Void>builder()
                .success(true)
                .message(message)
                .data(null)
                .build();
    }

    public static <T> BaseResponse<T> failure(String message) {
        return BaseResponse.<T>builder()
                .success(false)
                .message(message)
                .data(null)
                .build();
    }
}