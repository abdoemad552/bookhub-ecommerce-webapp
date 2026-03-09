package com.iti.jets.model.entity;

import lombok.*;
import com.iti.jets.model.enums.UserRole;
import jakarta.persistence.*;

import java.math.BigDecimal;
import java.time.LocalDate;

@Entity
@Table(name = "users")
@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
@EqualsAndHashCode(onlyExplicitlyIncluded = true)
public class User {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    @EqualsAndHashCode.Include
    private Long id;

    @Column(name = "username", nullable = false, unique = true, length = 20)
    private String username;

    @Column(name = "email", nullable = false, unique = true, length = 100)
    private String email;

    @Column(name = "password", nullable = false)
    private String password;

    @Column(name = "first_name", length = 20)
    private String firstName;

    @Column(name = "last_name", length = 20)
    private String lastName;

    @Enumerated(EnumType.STRING)
    @Column(name = "role", nullable = false)
    private UserRole role = UserRole.USER;

    @Lob
    @Column(name = "profile_pic_url")
    private String profilePicUrl;

    @Column(name = "birth_date")
    private LocalDate birthDate;

    @Column(name = "job", length = 100)
    private String job;

    @Column(name = "credit_limit", nullable = false, precision = 10, scale = 2)
    private BigDecimal creditLimit = BigDecimal.ZERO;

    @Column(name = "email_notifications", nullable = false)
    private Boolean emailNotifications = false;

    public void setCreditLimit(BigDecimal creditLimit) {
        this.creditLimit = (creditLimit == null || creditLimit.compareTo(BigDecimal.ZERO) < 0)
                ? BigDecimal.ZERO
                : creditLimit;
    }

    @Override
    public String toString() {
        return "User{" +
                "id=" + id +
                ", username='" + username + '\'' +
                ", email='" + email + '\'' +
                ", firstName='" + firstName + '\'' +
                ", lastName='" + lastName + '\'' +
                ", role=" + role +
                ", profilePicUrl='" + profilePicUrl + '\'' +
                ", birthDate=" + birthDate +
                ", job='" + job + '\'' +
                ", creditLimit=" + creditLimit +
                ", emailNotifications=" + emailNotifications +
                ", password='" + password + '\'' +
                '}';
    }
}