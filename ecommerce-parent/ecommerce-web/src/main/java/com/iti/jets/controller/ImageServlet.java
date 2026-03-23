package com.iti.jets.controller;

import com.iti.jets.model.dto.response.ImageResource;
import com.iti.jets.service.extra.ImageService;
import com.iti.jets.service.factory.ServiceFactory;
import jakarta.servlet.ServletConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.*;

@WebServlet("/images/*")
public class ImageServlet extends HttpServlet {

    private ImageService imageService;

    @Override
    public void init() {
        this.imageService = ServiceFactory.getInstance().getImageService();
    }

    @Override
    protected void doGet(
        HttpServletRequest request,
        HttpServletResponse response
    ) throws ServletException, IOException {
        String pathInfo = request.getPathInfo();

        try {
            ImageResource image = imageService.getImage(pathInfo);

            response.setContentType(image.getContentType());
            response.setContentLengthLong(image.getSize());

            response.setHeader("Cache-Control", "public, max-age=31536000");

            try (InputStream in = image.getData()) {
                in.transferTo(response.getOutputStream());
            }
        } catch (FileNotFoundException e) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        } catch (SecurityException e) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
        }
    }

}
