package com.iti.jets.service.extra;

import com.iti.jets.model.dto.request.ImageUploadRequest;
import com.iti.jets.model.dto.response.ImageResource;

import java.io.*;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.Properties;
import java.util.UUID;

public class ImageService {

    private static final long MAX_UPLOAD_SIZE = 5 * 1024 * 1024;

    private final String uploadDir;

    public ImageService() {
        Properties info = new Properties();
        try (InputStream in = getClass().getResourceAsStream("/application.properties")) {
            if (in == null) {
                throw new RuntimeException("application.properties not found");
            }
            info.load(in);
            String uploadDir = info.getProperty("upload.dir");

            if (uploadDir == null) {
                throw new RuntimeException("Uninitialized upload dir");
            }

            this.uploadDir = uploadDir;
        } catch (IOException e) {
            throw new RuntimeException("Failed to load configuration for ImageService", e);
        }
    }

    public String uploadImage(ImageUploadRequest uploadRequest) throws IOException {
        validateImage(uploadRequest.getContentType(), uploadRequest.getSize());

        String extension = getExtension(uploadRequest.getContentType());
        String fileName = UUID.randomUUID() + "." + extension;

        Path categoryPath = Paths.get(uploadDir, uploadRequest.getCategory().getFolder());
        Files.createDirectories(categoryPath);

        Path filePath = categoryPath.resolve(fileName);

        Files.copy(uploadRequest.getData(), filePath, StandardCopyOption.REPLACE_EXISTING);

        return "images/" + uploadRequest.getCategory().getFolder() + "/" + fileName;
    }

    public ImageResource getImage(String imagePath) throws IOException {
        File file = new File(uploadDir, imagePath);

        if (!file.exists() || file.isDirectory()) {
            throw new FileNotFoundException("Image not found");
        }

        // Security check
        String canonicalBase = new File(uploadDir).getCanonicalPath();
        String canonicalFile = file.getCanonicalPath();

        if (!canonicalFile.startsWith(canonicalBase)) {
            throw new SecurityException("Invalid path");
        }

        String contentType = Files.probeContentType(file.toPath());

        return new ImageResource(
            new FileInputStream(file),
            contentType,
            file.length()
        );
    }

    public boolean removeImage(String imagePath) throws IOException {
        File file = new File(uploadDir, imagePath);

        if (!file.exists() || file.isDirectory()) {
            throw new FileNotFoundException("Image not found");
        }

        // Security check
        String canonicalBase = new File(uploadDir).getCanonicalPath();
        String canonicalFile = file.getCanonicalPath();

        if (!canonicalFile.startsWith(canonicalBase)) {
            throw new SecurityException("Invalid path");
        }

        return file.delete();
    }

    private void validateImage(String contentType, long size) {
        if (contentType == null || !contentType.startsWith("image/")) {
            throw new IllegalArgumentException("Only image files are allowed");
        }

        if (size > MAX_UPLOAD_SIZE) {
            throw new IllegalArgumentException("Image too large");
        }
    }

    private String getExtension(String contentType) {
        return switch (contentType) {
            case "image/png"    -> "png";
            case "image/jpeg", "image/jpg" -> "jpg";
            case "image/webp"   -> "webp";
            default -> throw new IllegalArgumentException("Unsupported type");
        };
    }
}
