# 📚 BookHub - E-Commerce Platform

![Java](https://img.shields.io/badge/Java-21-blue)
![Maven](https://img.shields.io/badge/Maven-Multi--Module-orange)
![Frontend](https://img.shields.io/badge/Frontend-JSP%2FJSTL%2FTailwind-blueviolet)
![Database](https://img.shields.io/badge/Database-MySQL-brightgreen)
![Status](https://img.shields.io/badge/Status-Completed-brightgreen)

> A full-featured **e-commerce platform for selling books** built with **Java, JSP/JSTL, Tailwind CSS, Hibernate, Maven**, following clean architecture, modern UI principles, and best practices for scalability and maintainability.

---

## 📌 Table of Contents

- [Overview](#-overview)
- [Features](#-features)
- [System Architecture](#-system-architecture)
- [Project Structure](#-project-structure)
- [Module Responsibilities](#-module-responsibilities)
- [Technology Stack](#-technology-stack)
- [Design Patterns & Principles](#-design-patterns--principles)
- [Asynchronous Processing](#-asynchronous-processing)
- [Concurrency & Thread Safety](#-concurrency--thread-safety)
- [Database Schema (ERD)](#-database-schema-(erd))
- [Run the Code](#-run-the-code)
- [Testing & Code Coverage](#-testing--code-coverage)
- [Demo Video](#-demo-video)
- [Team Members](#-team-members)

---
## 📖 Overview

**BookHub** is a comprehensive e-commerce platform designed to facilitate the buying and selling of books online. The application is built with a **multi-module Maven structure** that separates business logic (backend) from presentation (frontend/web), ensuring scalability, maintainability, and clean separation of concerns.

The system leverages **modern technologies** including:
- **Java 21** with **Hibernate** ORM for robust backend development
- **JSP/JSTL** templating with **Tailwind CSS** for responsive frontend
- **HikariCP** for high-performance connection pooling
- **BCrypt** for secure password hashing
- **MySQL** for reliable data persistence

This architecture enables the platform to handle high traffic, ensure data consistency, and provide an excellent user experience across devices.

---

## ✨ Features

### 🛍️ User Features

#### **Authentication & Authorization**
* User registration with secure password hashing (BCrypt)
* Login & logout functionality
* Role-based access control (Admin, Customer)
* Session management
* Email verification & account activation
* Password reset functionality

#### **Book Discovery & Search**
* Browse all available books
* Advanced filtering (by category, price, rating)
* Full-text search functionality
* Sort by price, rating, popularity, newest
* Category-based navigation
* Featured/bestseller book recommendations
* Detailed book information pages

#### **Shopping Experience**
* Add/remove books from shopping cart 
* View cart with real-time price calculations
* Wishlist creation and management
* Save items for later
* Persistent cart storage

#### **Ordering & Checkout**
* Multi-step checkout process
* Order history and tracking
* Order details and invoice generation
* Payment processing (virtual payment)
* Order status updates

#### **Reviews & Ratings**
* Submit product reviews with ratings (1-5 stars)
* View customer reviews and ratings

#### **User Account Management**
* View and edit profile information
* Manage multiple presaved addresses (Home, Work, etc.)
* Track order history with detailed information
* View wishlist
* Account settings & preferences
* Profile customization using interests (personalized recommendations)
* Email notifications with news updates and promotions

#### **Guest Features**
* Browse all books without login requirement
* View book details and author information
* Add books to cart anonymously
* View existing reviews and community ratings
* Search and filter books by category, price, rating

#### **Author Information**
* Detailed author profile pages
* All books by specific author
* Author ratings and reviews

### 🛡️ Admin Features

#### **Dashboard & Analytics**
* Admin dashboard with key statistics
* User engagement metrics
* Sales performance analytics
* User demographics and statistics

#### **Book Management**
* Add new books with ISBN, title, author, description
* Edit book details
* Delete books from catalog
* Manage book categories
* Upload book cover images
* Manage book inventory/stock

#### **User Management**
* View registered users
* User details and activity logs
* View orders' history for specific user account
* User statistics and insights
* Grant/Revoke admin role to specific user

---

## 🧱 System Architecture

The application follows a **Layered Client-Server Architecture** with clear separation of concerns:

<div align=center>
<img width="742" height="694" alt="diagram-export-4-4-2026-10_13_14-PM" src="https://github.com/user-attachments/assets/085b2242-838f-47e2-8ae3-bddf99e6c3bb" />
</div>

**Key Architectural Principles:**
- **Separation of Concerns**: Each layer has distinct responsibilities
- **DRY (Don't Repeat Yourself)**: Reusable components and shared utilities

---

## 📂 Project Structure

```
ecommerce-webapp/
│
├── ecommerce-parent/                   
   │
   ├── ecommerce-backend/           # Backend module (JAR)    
   │   ├── src/main/java/
   │   │   │   │   └── com/iti/jets/
   │   │   │   │       ├── config/          # Configuration classes (Hibernate, DB)
   │   │   │   │       ├── exception/       # Custom exception classes
   │   │   │   │       ├── mapper/          # DTO to Entity mappers
   │   │   │   │       ├── model/           # JPA entity models
   │   │   │   │       ├── repository/      # Data access layer (DAO)
   │   │   │   │       ├── service/
   │   │   │   │       │   ├── interfaces/         # Service interfaces
   │   │   │   │       │   ├── implementation/     # Service implementations
   │   │   │   │       │   ├── factory/            # Service factory (optional)
   │   │   │   │       │   └── extra/              # Extra/utility services
   │   │   │   │       └── util/            # Utility classes
   │   │   │   └── resources/
   │   │   │       ├── application.properties  # DB & app config
   │   │   │       ├── log4j2.properties       # Logging configuration
   │   │   │       ├── smtp_config.properties  # Email configuration
   │   │   │       ├── db/                     # SQL scripts (schema, data)
   │   │   │       └── META-INF/
   │   │   │
   │   │   └── test/java/
   │   │       │   └── com/iti/jets/
   │   │       │       └── service/implementation/
   │   │       └── resources/
   │   │
   │   └── pom.xml               
   │
   ├── ecommerce-web/                # Web module (WAR)
   │   ├── src/main/java/
   │   │       │   └── com/iti/jets/ 
   │   │       │         ├── controllers/       # Servlets  
   │   │       │         ├── filter/     
   │   │       │         ├── listener/      
   │   │       │         └──  util/    
   │   │       └── webapp/
   │   │           ├── assets/        # Static resources (CSS, JS, images)
   │   │           ├── WEB-INF/
   │   │           │   ├── views/     # JSP pages (organized by feature)
   │   │           │   ├── auth/      
   │   │           │   ├── books/     
   │   │           │   ├── cart/      
   │   │           │   ├── orders/    
   │   │           │   ├── admin/     
   │   │           │   └── common/   
   │   │           └── web.xml    
   │   ├── pom.xml              
   │   ├── package.json          # Frontend dependencies (Tailwind, jQuery)
   │   ├── tailwind.config.js    # Tailwind CSS configuration
   │   └── node_modules/         # npm dependencies
   │
   └── pom.xml                   # Parent POM (dependency management)
```

---

## 📦 Module Responsibilities

| Module | Responsibility | Technology |
|--------|-----------------|------------|
| **ecommerce-backend** | Business logic, data persistence, service layer, API endpoints | Java 21, Hibernate, HikariCP, MySQL |
| **ecommerce-web** | User interface, presentation logic, request handling | JSP/JSTL, Tailwind CSS, jQuery, HTML5 |
| **Parent POM** | Dependency management, build configuration, common properties | Maven |

---

## 🛠 Technology Stack

### Backend

| Category | Technology | Version | Purpose |
|----------|-----------|---------|---------|
| **Language** | Java | 21 | Core backend development |
| **ORM** | Hibernate | 6.4.4 | Object-Relational Mapping |
| **Database Driver** | MySQL Connector/J | 9.5.0 | MySQL database connectivity |
| **Connection Pooling** | HikariCP | 5.1.0 | High-performance connection pooling |
| **Annotation Processing** | Lombok | 1.18.32 | Java boilerplate reduction |
| **Security** | jBCrypt | 0.4 | Password hashing & verification |
| **Email** | Jakarta Mail | 2.0.2 | Email sending functionality |
| **Logging** | Log4j2 | Latest | Application logging |
| **Web Framework** | Jakarta EE | 10.0.0 | Enterprise Java standard |
| **Testing** | JUnit 5 | 5.10.2 | Unit testing framework |
| **Mocking** | Mockito | 5.11.0 | Test mocking library |

### Frontend

| Category | Technology | Version | Purpose |
|----------|-----------|---------|---------|
| **Template Engine** | JSP/Servlet | Jakarta EE 10 | Server-side page generation & request handling |
| **CSS Framework** | Tailwind CSS | 4.2.1 | Utility-first CSS styling |
| **JavaScript Library** | jQuery | 4.0.0 | Asynchronous DOM manipulation & AJAX |

### Web Server

| Component | Technology | Version | Purpose |
|-----------|-----------|---------|---------|
| **Application Server** | Apache Tomcat | 11.x | Servlet container & JSP processing |
| **Protocol** | HTTP/HTTPS | - | Web communication |
| **Session Management** | Tomcat Sessions | - | User session handling |

### Database

| Component | Technology | Purpose |
|-----------|-----------|---------|
| **Database** | MySQL | 8.0+ | Relational data storage |
| **Driver** | Connector/J | Native MySQL connectivity |
| **Connection Pool** | HikariCP | High-performance pooling |

### Build & Deployment

| Tool | Purpose |
|------|---------|
| **Build Tool** | Maven (Multi-Module) |
| **Package Format** | WAR (ecommerce-web), JAR (ecommerce-backend) |
| **Source Control** | Git |

---

## 🧠 Design Patterns & Principles
- SOLID Principles
- MVC (Model-View-Controller)
- Repository Pattern (DAO - Data Access Object)
- Service Layer Pattern
- Factory Pattern
- Singleton Pattern
- DTO (Data Transfer Object) Pattern
- Builder Pattern
---
## 📡 Asynchronous Processing

### **Client-Side AJAX Operations**

#### **Asynchronous JavaScript Requests**
- **jQuery AJAX**: for asynchronous HTTP requests
- No page refreshes required for data operations
- Loading indicators and progress feedback
- Error handling and retry mechanisms

#### **Common Asynchronous Operations**
- **Book Search/Filtering**: Real-time search results
- **Cart Operations**: Add/remove items without page reload
- **Review Submission**: Submit reviews asynchronously
- **Wishlist Management**: Add/remove from wishlist
- **Address Management**: CRUD operations on addresses
- **Order Checkout**: Multi-step checkout with validation
- **Profile Updates**: Edit profile information dynamically

## 🔒 Concurrency & Thread Safety

### **Entity Manager Thread Safety**

#### **ThreadLocal Pattern Implementation**
- Individual Entity Manager per thread via ThreadLocal
- Prevents Entity Manager sharing between threads
- Lazy initialization of Entity Manager on first use
- Automatic cleanup on thread completion

#### **Benefits**
- Thread-safe database operations
- Isolation between concurrent transactions
- Prevention of race conditions
- Proper resource cleanup per thread

## 📊 Database Schema (ERD)

<img width="2000" height="2000" align=center alt="Picture1" src="https://github.com/user-attachments/assets/a8f6f83b-ca8d-4c8d-a25c-29ea9aa5688d" />

## 🚀 Run the Code

### Prerequisites

- **Java Development Kit (JDK) 21** or higher
- **Maven 3.9+**
- **MySQL Server 8.0+**
- **Git**
- **Node.js & npm** (for frontend build tools)

### Step 1: Clone the Repository

```bash
git clone <repository-url>
cd ecommerce-webapp
```

### Step 2: Configure Database

1. Create MySQL database:
```sql
CREATE DATABASE book_hub;
```

2. Update database configuration in `ecommerce-backend/src/main/resources/application.properties`:
```properties
db.url=jdbc:mysql://localhost:3306/book_hub
db.username=your_username
db.password=your_password
```

### Step 3: Configure Email (Optional)

Update `ecommerce-backend/src/main/resources/smtp_config.properties`:
```properties
mail.smtp.host=smtp.gmail.com
mail.smtp.port=587
mail.from=your-email@gmail.com
mail.password=your-app-password
```

### Step 4: Build the Project

```bash
# From project root
mvn clean install
```

### Step 5: Deploy on Tomcat

```bash
cd ecommerce-parent

# Using Maven Tomcat plugin
mvn tomcat7:redeploy
```

### Access the Application

- **Frontend URL**: `http://localhost:9090/ecommerce`
- **Admin Dashboard**: `http://localhost:9090/ecommerce/admin/dashboard`

---
## 🧪 Testing & Code Coverage

### **Tests Included**

The project includes comprehensive unit tests for all service implementations:

### **Running Tests**

```bash
# Run all tests
mvn test

# Run tests for specific module
mvn test -pl ecommerce-backend

# Run specific test class
mvn test -Dtest=AuthServiceImplTest

# Run tests with coverage
mvn clean test jacoco:report
```

### **Code Coverage Reports**

- Generated by **JaCoCo** Maven plugin
- Reports available at: `ecommerce-backend/target/site/jacoco/index.html`
- Coverage metrics include line, branch, and method coverage

### **Test Frameworks**

- **JUnit 5** for test execution
- **Mockito** for mocking dependencies

---
### **📽️ Demo Video**

[Enjoy BookHub Demo](https://drive.google.com/file/d/1--YF2PcxSjXv1a7g_UkrwlF2uRRq5hZ9/view?usp=sharing)

---

## 👥 Team Members

* **Abdelrahman Emad**
* **Reem Mohy Eldin**
* **Yousef Abdallah**

---
