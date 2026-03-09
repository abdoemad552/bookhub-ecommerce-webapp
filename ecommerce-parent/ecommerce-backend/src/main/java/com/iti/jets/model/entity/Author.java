package com.iti.jets.model.entity;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "authors", indexes = {
        @Index(name = "idx_authors_name", columnList = "name")
})
@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
@EqualsAndHashCode(onlyExplicitlyIncluded = true)
public class Author {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    @EqualsAndHashCode.Include
    private Long id;

    @Column(name = "name", nullable = false, length = 100)
    private String name;

    @Lob
    @Column(name = "about")
    private String about;
}