package com.iti.jets.model.entity;

import com.iti.jets.model.enums.BookType;
import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.OnDelete;
import org.hibernate.annotations.OnDeleteAction;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.HashSet;
import java.util.Set;

@Entity
@Table(name = "books", indexes = {
        @Index(name = "idx_books_category", columnList = "category_id"),
        @Index(name = "idx_books_title", columnList = "title"),
        @Index(name = "idx_books_price", columnList = "price"),
        @Index(name = "idx_books_publish_date", columnList = "publish_date")
})
@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
@Builder
@EqualsAndHashCode(onlyExplicitlyIncluded = true)
public class Book {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    @EqualsAndHashCode.Include
    private Long id;

    @Column(name = "title", nullable = false)
    private String title;

    @Lob
    @Column(name = "description")
    private String description;

    @Column(name = "price", nullable = false, precision = 10, scale = 2)
    @Builder.Default
    private BigDecimal price = BigDecimal.ZERO;

    @Column(name = "stock_quantity", nullable = false)
    @Builder.Default
    private Integer stockQuantity = 0;

    @Column(name = "publish_date")
    private LocalDate publishDate;

    @Lob
    @Column(name = "image_url")
    private String imageUrl;

    @Column(name = "isbn", nullable = false, unique = true, length = 20)
    private String isbn;

    @ManyToOne(fetch = FetchType.LAZY)
    @OnDelete(action = OnDeleteAction.SET_NULL)
    @JoinColumn(name = "category_id")
    private Category category;

    @Enumerated(EnumType.STRING)
    @Column(name = "book_type", nullable = false)
    @Builder.Default
    private BookType bookType = BookType.PAPERBACK;

    @Column(name = "pages")
    private Integer pages;

    @Column(name = "sold_quantity")
    @Builder.Default
    private Integer soldQuantity = 0;

    @OneToMany(mappedBy = "book", cascade = CascadeType.ALL, orphanRemoval = true, fetch = FetchType.LAZY)
    @Builder.Default
    private Set<Offer> offers = new HashSet<>();

    @OneToMany(mappedBy = "book", cascade = CascadeType.ALL, orphanRemoval = true, fetch = FetchType.LAZY)
    @Builder.Default
    private Set<BookAuthor> bookAuthors = new HashSet<>();

    @OneToMany(mappedBy = "book", cascade = CascadeType.ALL, orphanRemoval = true, fetch = FetchType.LAZY)
    @Builder.Default
    private Set<BookTag> bookTags = new HashSet<>();

    // Synchronization methods
    public void addOffer(Offer offer) {
        if (offer != null) {
            offers.add(offer);
            offer.setBook(this);
        }
    }

    public void removeOffer(Offer offer) {
        if (offer != null) {
            offers.remove(offer);
            offer.setBook(null);
        }
    }

    public void addAuthor(Author author) {
        BookAuthor bookAuthor = new BookAuthor();
        bookAuthor.setBook(this);
        bookAuthor.setAuthor(author);
        bookAuthors.add(bookAuthor);
    }

    public void removeAuthor(Author author) {
        bookAuthors.removeIf(ba -> ba.getAuthor().equals(author));
    }

    public void addTags(Tag tag) {
        BookTag bookTag = new BookTag();
        bookTag.setBook(this);
        bookTag.setTag(tag);
        bookTags.add(bookTag);
    }

    public void removeTag(Tag tag) {
        bookTags.removeIf(bt -> bt.getTag().equals(tag));
    }

    // Special Setters
    public void setPrice(BigDecimal price) {
        this.price = (price == null || price.compareTo(BigDecimal.ZERO) < 0)
                ? BigDecimal.ZERO
                : price;
    }

    public void setStockQuantity(Integer stockQuantity) {
        this.stockQuantity = (stockQuantity == null || stockQuantity < 0) ? 0 : stockQuantity;
    }

    public void setPages(Integer pages) {
        this.pages = (pages == null || pages < 0) ? 0 : pages;
    }

    @Override
    public String toString() {
        return "Book{" +
                "id=" + id +
                ", title='" + title + '\'' +
                ", description='" + description + '\'' +
                ", price=" + price +
                ", stockQuantity=" + stockQuantity +
                ", publishDate=" + publishDate +
                ", imageUrl='" + imageUrl + '\'' +
                ", isbn='" + isbn + '\'' +
                ", bookType=" + bookType +
                ", pages=" + pages +
                ", soldQuantity=" + soldQuantity +
                '}';
    }
}