package com.iti.jets.controller;

import com.iti.jets.controller.admin.AdminBooksServlet;
import com.iti.jets.model.dto.response.AuthorStatsDTO;
import com.iti.jets.model.dto.response.BookCardDTO;
import com.iti.jets.model.dto.response.PageResponseDTO;
import com.iti.jets.service.factory.ServiceFactory;
import com.iti.jets.service.interfaces.AuthorService;
import com.iti.jets.service.interfaces.BookService;
import com.iti.jets.util.PathStorage;
import jakarta.json.bind.Jsonb;
import jakarta.json.bind.JsonbBuilder;
import jakarta.json.bind.JsonbConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;

@WebServlet("/author/books")
public class AuthorBooksServlet extends HttpServlet {

    private static final int DEFAULT_PAGE_SIZE = 12;

    private AuthorService authorService;
    private BookService bookService;
    private Jsonb jsonb;

    private static final Logger LOGGER = LoggerFactory.getLogger(AuthorBooksServlet.class);

    @Override
    public void init() {
        this.authorService = ServiceFactory.getInstance().getAuthorService();
        this.bookService = ServiceFactory.getInstance().getBookService();

        JsonbConfig config = new JsonbConfig();
        config.withFormatting(true);
        jsonb = JsonbBuilder.create(config);
    }

    @Override
    public void destroy() {
        try { if (jsonb != null) jsonb.close(); }
        catch (Exception ignored) {}
    }

    @Override
    protected void doGet(
        HttpServletRequest request,
        HttpServletResponse response
    ) throws ServletException, IOException {

        int page = parsePositiveInteger(request.getParameter("page"), 1);
        int size = parsePositiveInteger(request.getParameter("size"), DEFAULT_PAGE_SIZE);

        String strAuthorId = request.getParameter("authorId");

        long authorId;
        try {
            authorId = Long.parseLong(strAuthorId);
        } catch (NumberFormatException e) {
            writeError(response, HttpServletResponse.SC_BAD_REQUEST,
                strAuthorId + " is not a valid id");
            return;
        }

        PageResponseDTO<BookCardDTO> authoredBooksPage = bookService.findAuthoredBooks(authorId, page, size);

        System.out.println(jsonb.toJson(authoredBooksPage));
        request.setAttribute("pagination", authoredBooksPage);

        request.getRequestDispatcher(PathStorage.AUTHORS_BOOKS_CONTAINER).forward(request, response);
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

    private int parsePositiveInteger(String rawValue, int fallback) {
        try {
            int parsedValue = Integer.parseInt(rawValue);
            return parsedValue > 0 ? parsedValue : fallback;
        } catch (NumberFormatException e) {
            return fallback;
        }
    }
}
