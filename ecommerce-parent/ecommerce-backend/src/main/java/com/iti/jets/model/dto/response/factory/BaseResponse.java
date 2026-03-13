package com.iti.jets.model.dto.response.factory;

import com.iti.jets.model.enums.ServerStatusCode;
import lombok.*;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
@ToString
public class BaseResponse<T> {

    private boolean success;
    private String message;
    // private ServerStatusCode statusCode;
    private T data;

    public boolean isFailure() {
        return !success;
    }

    public boolean hasData() {
        return data != null;
    }
}