package com.iti.jets.controller.admin;

import com.iti.jets.model.dto.request.BookAddRequestDTO;
import com.iti.jets.model.dto.request.ImageUploadRequest;
import com.iti.jets.model.dto.response.BookAddResponseDTO;
import com.iti.jets.model.enums.BookType;
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
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.format.DateTimeParseException;
import java.util.Arrays;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@WebServlet("/admin/books/*")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,       // 1 MB — spool to disk above this
    maxFileSize       = 5 * 1024 * 1024,   // 5 MB max per file
    maxRequestSize    = 6 * 1024 * 1024    // 6 MB max total request
)
public class AdminBooksServlet extends HttpServlet {

    private BookService bookService;
    private ImageService imageService;
    private Jsonb jsonb;

    private static final Logger LOGGER = LoggerFactory.getLogger(AdminBooksServlet.class);

    @Override
    public void init() {
        this.bookService = ServiceFactory.getInstance().getBookService();
        this.imageService = ServiceFactory.getInstance().getImageService();
        jsonb = JsonbBuilder.create();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
//        int page = parseIntParam(request, "page", 0);
//        int size = parseIntParam(request, "size", 10);
//
//        page = Math.max(0, page);
//        size = Math.min(Math.max(1, size), 100);
//
//        try {
//            List<Book> books = bookService.findAll(page, size);
//            writeJson(resp, HttpServletResponse.SC_OK, JsonUtil.toJson(result));
//        } catch (Exception e) {
//            writeError(response, HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
//                "Failed to fetch books");
//        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Part imagePart = request.getPart("image");

        BookAddRequestDTO addRequest;
        try {
            addRequest = parseAddRequest(request);
        } catch (IllegalArgumentException e) {
            writeError(response, HttpServletResponse.SC_BAD_REQUEST, e.getMessage());
            return;
        }

        Optional<BookAddResponseDTO> result = bookService.addBook(addRequest);
        if (result.isEmpty()) {
            writeError(response, HttpServletResponse.SC_CONFLICT,
                "A book with ISBN '" + addRequest.getIsbn() + "' already exists.");
            return;
        }

        BookAddResponseDTO addResponse = result.get();
        handleCoverUpload(imagePart, addResponse);

        // Respond 201 Created
        writeJson(response, HttpServletResponse.SC_CREATED, addResponse);
    }

    @Override
    protected void doPut(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    }

    @Override
    protected void doDelete(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    }

    // ── Response helpers ──────────────────────────────────────────────────────

    private void writeJson(HttpServletResponse response, int status, Object body)
        throws IOException {
        response.setStatus(status);
        response.setContentType("application/json;charset=UTF-8");
        jsonb.toJson(body, response.getWriter());
    }

    private void writeError(HttpServletResponse resp, int status, String message)
        throws IOException {
        writeJson(resp, status, new ErrorResponse(message));
    }

    private BookAddRequestDTO parseAddRequest(HttpServletRequest request)
            throws IOException, ServletException {

        BookAddRequestDTO dto = new BookAddRequestDTO();

        dto.setIsbn(requireParam(request, "isbn", "ISBN is required"));
        dto.setTitle(requireParam(request, "title", "Title is required"));
        dto.setDescription(requireParam(request, "description", "ISBN is required"));
        dto.setCategory(requireParam(request, "category", "Category is required"));

        String bookTypeStr = requireParam(request, "bookType", "Book type is required");
        try {
            dto.setBookType(BookType.valueOf(bookTypeStr.toUpperCase()));
        } catch (IllegalArgumentException e) {
            throw new IllegalArgumentException("Invalid book type: " + bookTypeStr);
        }

        String publishDateStr = requireParam(request, "publishDate", "Publish date is required");
        try {
            dto.setPublishDate(LocalDate.parse(publishDateStr));
        } catch (DateTimeParseException e) {
            throw new IllegalArgumentException("Invalid publish date format, expected YYYY-MM-DD");
        }

        // Numeric fields
        dto.setPrice(parseDecimalParam(request, "price", "Price"));
        dto.setStockQuantity(parseIntegerParam(request, "stockQuantity", "Stock quantity"));
        dto.setPages(parseIntegerParam(request, "pages", "Pages"));

        if (dto.getPrice().compareTo(BigDecimal.ZERO) < 0)
            throw new IllegalArgumentException("Price must be >= 0");
        if (dto.getStockQuantity() < 0)
            throw new IllegalArgumentException("Stock quantity must be >= 0");
        if (dto.getPages() < 1)
            throw new IllegalArgumentException("Pages must be >= 1");

        String[] authorParams = request.getParameterValues("authors");
        List<String> authors = (authorParams != null)
            ? Arrays.stream(authorParams)
            .filter(n -> n != null && !n.isBlank())
            .collect(Collectors.toList())
            : List.of();

        if (authors.isEmpty())
            throw new IllegalArgumentException("At least one author is required");
        dto.setAuthors(authors);

        return dto;
    }

    /**
     * Uploads the cover image and updates the book's coverUrl in the DB.
     * Failures are non-fatal — the book has already been saved successfully
     * so we just log a warning and move on.
     */
    private void handleCoverUpload(
        Part imagePart,
        BookAddResponseDTO addResponse
    ) {
        if (imagePart != null && imagePart.getSize() > 0) {
            try {
                ImageUploadRequest uploadRequest = new ImageUploadRequest(
                    imagePart.getInputStream(),
                    imagePart.getContentType(),
                    imagePart.getSize(),
                    ImageCategory.BOOK
                );

                String coverUrl = imageService.uploadImage(uploadRequest);

                bookService.updateCoverUrl(addResponse.getBookId(), coverUrl);
                addResponse.setCoverUrl(coverUrl);
            } catch (Exception e) {
                LOGGER.warn("Cover upload failed for book {}, saved without cover",
                    addResponse.getBookId());
            }
        }
    }


    private String requireParam(HttpServletRequest request, String name, String errorMsg) {
        String val = request.getParameter(name);
        if (val == null || val.isBlank()) throw new IllegalArgumentException(errorMsg);
        return val.trim();
    }

    private BigDecimal parseDecimalParam(HttpServletRequest request, String name, String label) {
        String val = request.getParameter(name);
        if (val == null || val.isBlank())
            throw new IllegalArgumentException(label + " is required");
        try { return new BigDecimal(val.trim()); }
        catch (NumberFormatException e) {
            throw new IllegalArgumentException(label + " must be a valid number");
        }
    }

    private int parseIntegerParam(HttpServletRequest request, String name, String label) {
        String val = request.getParameter(name);
        if (val == null || val.isBlank())
            throw new IllegalArgumentException(label + " is required");
        try { return Integer.parseInt(val.trim()); }
        catch (NumberFormatException e) {
            throw new IllegalArgumentException(label + " must be a whole number");
        }
    }

    private int parseIntParam(HttpServletRequest req, String name, int defaultValue) {
        String val = req.getParameter(name);
        if (val == null) return defaultValue;
        try { return Integer.parseInt(val); }
        catch (NumberFormatException e) { return defaultValue; }
    }

    /**
     * Extracts the original filename from a Part's Content-Disposition header.
     * Returns "upload" if no filename is present.
     */
    private String getSubmittedFileName(Part part) {
        for (String cd : part.getHeader("content-disposition").split(";")) {
            if (cd.trim().startsWith("filename")) {
                return cd.substring(cd.indexOf('=') + 1).trim().replace("\"", "");
            }
        }
        return "upload";
    }

    public static class ErrorResponse {
        public final String error;
        public ErrorResponse(String error) { this.error = error; }
    }
}
