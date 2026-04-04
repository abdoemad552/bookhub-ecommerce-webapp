package com.iti.jets.model.entity;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.iti.jets.model.enums.AddressType;
import com.iti.jets.model.enums.Government;
import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.OnDelete;
import org.hibernate.annotations.OnDeleteAction;

@Entity
@Table(name = "addresses", indexes = {
        @Index(name = "idx_addresses_user", columnList = "user_id")
}, uniqueConstraints = {
        @UniqueConstraint(
                name = "uk_user_address_type",
                columnNames = {"user_id", "address_type"}
        )
})
@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
@Builder
@EqualsAndHashCode(onlyExplicitlyIncluded = true)
public class Address {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    @EqualsAndHashCode.Include
    @JsonIgnore
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @OnDelete(action = OnDeleteAction.CASCADE)
    @JoinColumn(name = "user_id", nullable = false)
    @JsonIgnore
    private User user;

    @Enumerated(EnumType.STRING)
    @Column(name = "address_type")
    @Builder.Default
    private AddressType addressType = AddressType.SHIPPING;

    @Enumerated(EnumType.STRING)
    @Column(name = "government", nullable = false, length = 50)
    private Government government;

    @Column(name = "city", nullable = false, length = 50)
    private String city;

    @Column(name = "street", nullable = false, length = 100)
    private String street;

    @Column(name = "building_no", nullable = false, length = 20)
    private String buildingNo;

    @Column(name = "description")
    private String description;

    @Override
    public String toString() {
        return "Address{" +
                "id=" + id +
                ", addressType=" + addressType +
                ", government='" + government + '\'' +
                ", city='" + city + '\'' +
                ", street='" + street + '\'' +
                ", buildingNo='" + buildingNo + '\'' +
                ", description='" + description + '\'' +
                '}';
    }
}