package com.iti.jets.model.entity;

import com.iti.jets.model.enums.UserRole;
import jakarta.persistence.*;
import lombok.*;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.HashSet;
import java.util.Set;

@Entity
@Table(name = "users")
@NamedQueries({
        @NamedQuery(
                name = "User.findByEmail",
                query = "SELECT u FROM User u WHERE u.email = :email"
        ),
        @NamedQuery(
                name = "User.findByUserName",
                query = "SELECT u FROM User u WHERE u.username = :username"
        ),
        @NamedQuery(
                name = "User.findByRole",
                query = "SELECT u FROM User u WHERE u.role = :role"
        ),
        @NamedQuery(
                name = "User.findByJob",
                query = "SELECT u FROM User u WHERE u.job = :job"
        ),
        @NamedQuery(
                name = "User.findEmailEnabledUsers",
                query = "SELECT u FROM User u WHERE u.emailNotifications = true"
        ),
        @NamedQuery(
                name = "User.findZeroCreditUsers",
                query = "SELECT u FROM User u WHERE u.creditLimit = 0"
        )
})
@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
@Builder
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
    @Builder.Default
    private UserRole role = UserRole.USER;

    @Lob
    @Column(name = "profile_pic_url")
    private String profilePicUrl;

    @Column(name = "birth_date")
    private LocalDate birthDate;

    @Column(name = "job", length = 100)
    private String job;

    @Column(name = "credit_limit", nullable = false, precision = 10, scale = 2)
    @Builder.Default
    private BigDecimal creditLimit = BigDecimal.ZERO;

    @Column(name = "email_notifications", nullable = false)
    @Builder.Default
    private Boolean emailNotifications = false;

    @OneToMany(mappedBy = "user", cascade = CascadeType.ALL, orphanRemoval = true, fetch = FetchType.LAZY)
    @Builder.Default
    private Set<Address> addresses = new HashSet<>();

    @OneToMany(mappedBy = "user", cascade = CascadeType.ALL, orphanRemoval = true, fetch = FetchType.LAZY)
    @Builder.Default
    private Set<Order> orders = new HashSet<>();

    @OneToMany(mappedBy = "user", cascade = CascadeType.ALL, orphanRemoval = true, fetch = FetchType.LAZY)
    @Builder.Default
    private Set<UserTag> userTags = new HashSet<>();

    @OneToMany(mappedBy = "user", cascade = CascadeType.ALL, orphanRemoval = true, fetch = FetchType.LAZY)
    @Builder.Default
    private Set<UserInterest> interests = new HashSet<>();

    // Synchronization methods
    public void addAddress(Address address) {
        if (address != null) {
            addresses.add(address);
            address.setUser(this);
        }
    }

    public void removeAddress(Address address) {
        if (address != null) {
            addresses.remove(address);
            address.setUser(null);
        }
    }

    public void addOrder(Order order) {
        if (order != null) {
            orders.add(order);
            order.setUser(this);
        }
    }

    public void removeOrder(Order order) {
        if (order != null) {
            orders.remove(order);
            order.setUser(null);
        }
    }

    public void addUserTag(UserTag ut) {
        if (ut != null) {
            userTags.add(ut);
            ut.setUser(this);
        }
    }

    public void removeUserTag(UserTag ut) {
        if (ut != null) {
            userTags.remove(ut);
            ut.setUser(null);
        }
    }

    public void addInterest(Category category) {
        if (category != null) {
            UserInterest ui = new UserInterest();
            ui.setUser(this);
            ui.setCategory(category);
            interests.add(ui);
        }
    }

    public void removeInterest(Category category) {
        interests.removeIf(ui -> ui.getCategory().equals(category));
    }

    // Special setters
    public void setCreditLimit(BigDecimal creditLimit) {
        this.creditLimit = (creditLimit == null || creditLimit.compareTo(BigDecimal.ZERO) < 0)
                ? BigDecimal.ZERO
                : creditLimit;
    }

    public void setInterests(Set<Category> categories) {
        interests.clear();
        if (categories != null) {
            categories.forEach(this::addInterest);
        }
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