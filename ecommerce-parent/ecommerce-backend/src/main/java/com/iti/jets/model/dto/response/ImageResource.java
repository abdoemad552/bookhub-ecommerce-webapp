package com.iti.jets.model.dto.response;

import lombok.AllArgsConstructor;
import lombok.Getter;

import java.io.InputStream;

@Getter
@AllArgsConstructor
public class ImageResource {
    InputStream data;
    String contentType;
    long size;
}
