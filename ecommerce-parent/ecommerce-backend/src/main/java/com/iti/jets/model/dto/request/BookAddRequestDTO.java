package com.iti.jets.model.dto.request;

import com.iti.jets.model.enums.BookType;
import lombok.*;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

@Setter
@Getter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class BookAddRequestDTO {
    private String          isbn;
    private String          title;
    private String          description;
    private int             pages;
    private BigDecimal      price;
    private int             stockQuantity;
    private LocalDate       publishDate;
    private BookType        bookType;
    private String          category;
    private List<String>    authors;

    private byte[]  imageBytes;
    private String  imageFileName;
}
