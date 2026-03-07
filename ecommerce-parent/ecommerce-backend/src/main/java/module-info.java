module ecommerce.backend {
    requires org.mapstruct;
    requires jakarta.jakartaee.api;
    requires org.hibernate.orm.core;

    exports com.iti.jets.model.dto;
    exports com.iti.jets.service;
}