package com.iti.jets.controller.admin;

import com.iti.jets.model.dto.request.ImageUploadRequest;
import com.iti.jets.model.entity.Book;
import com.iti.jets.model.enums.ImageCategory;
import com.iti.jets.service.extra.ImageService;
import com.iti.jets.service.factory.ServiceFactory;
import com.iti.jets.service.interfaces.BookService;
import jakarta.json.bind.Jsonb;
import jakarta.json.bind.JsonbBuilder;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;
import java.util.Map;

@WebServlet("/admin/book/update/cover")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,       // 1 MB — spool to disk above this
    maxFileSize       = 5 * 1024 * 1024,   // 5 MB max per file
    maxRequestSize    = 6 * 1024 * 1024    // 6 MB max total request
)
public class UpdateBookCoverServlet extends HttpServlet {

    private BookService bookService;
    private ImageService imageService;
    private Jsonb jsonb;

    private static final Logger LOGGER = LoggerFactory.getLogger(UpdateBookCoverServlet.class);

    @Override
    public void init() throws ServletException {
        bookService = ServiceFactory.getInstance().getBookService();
        imageService = ServiceFactory.getInstance().getImageService();
        jsonb = JsonbBuilder.create();
    }

    @Override
    public void destroy() {
        try { if (jsonb != null) jsonb.close(); }
        catch (Exception ignored) {}
    }

    @Override
    protected void doPut(
        HttpServletRequest request,
        HttpServletResponse response
    ) throws ServletException, IOException {

        Part imagePart = request.getPart("image");

        long bookId;
        try {
            bookId = parseLongParam(request, "bookId", "Book ID");
        } catch (NumberFormatException e) {
            writeError(response, HttpServletResponse.SC_BAD_REQUEST, e.getMessage());
            return;
        }

        Book book = bookService.findById(bookId);

        if (book == null) {
            writeError(response, HttpServletResponse.SC_NOT_FOUND, "Book not found");
            return;
        }

        String newCoverUrl;
        String oldCoverUrl = book.getImageUrl();
        if (imagePart != null && imagePart.getSize() > 0) {
            try {
                ImageUploadRequest uploadRequest = new ImageUploadRequest(
                    imagePart.getInputStream(),
                    imagePart.getContentType(),
                    imagePart.getSize(),
                    ImageCategory.BOOK
                );

                newCoverUrl = imageService.uploadImage(uploadRequest);
                bookService.updateCoverUrl(bookId, newCoverUrl);
            } catch (Exception e) {
                System.out.println(e.getMessage());
                LOGGER.warn("Cover upload failed for book {}, saved without cover", bookId);
                writeError(response, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Failed to update the image");
                return;
            }
        } else {
            writeError(response, HttpServletResponse.SC_BAD_REQUEST, "Image must be provided");
            return;
        }

        try {
            System.out.println("Deleting: " + oldCoverUrl);
            imageService.removeImage(oldCoverUrl.replace("images/", "/"));
        } catch (Exception ignored) {
            System.out.println("Couldn't delete the book");
        }

        writeJson(response, HttpServletResponse.SC_OK, Map.of("coverUrl", newCoverUrl));
    }

    private void writeJson(HttpServletResponse response, int status, Object body)
        throws IOException {
        response.setStatus(status);
        response.setContentType("application/json;charset=UTF-8");
        jsonb.toJson(body, response.getWriter());
    }

    private void writeError(HttpServletResponse resp, int status, String message)
        throws IOException {
        writeJson(resp, status, new AdminBooksServlet.ErrorResponse(message));
    }

    private long parseLongParam(HttpServletRequest request, String name, String label) {
        String val = request.getParameter(name);
        if (val == null || val.isBlank())
            throw new IllegalArgumentException(label + " is required");
        try { return Long.parseLong(val.trim()); }
        catch (NumberFormatException e) {
            throw new IllegalArgumentException(label + " must be a whole number");
        }
    }
}
