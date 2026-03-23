package com.iti.jets.model.dto.request;

import com.iti.jets.model.enums.ImageCategory;
import lombok.AllArgsConstructor;
import lombok.Getter;

import java.io.InputStream;

@Getter
@AllArgsConstructor
public class ImageUploadRequest {

    private InputStream data;
    private String contentType;
    private long size;
    private ImageCategory category;
}
