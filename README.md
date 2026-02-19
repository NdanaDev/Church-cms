# Church Management System

Web-based Church Management System built with **Spring Boot**, **Flutter Web**, **PostgreSQL**, and **Supabase Auth**. Manages members, events, attendance, announcements, and reporting with role-based access control.

## Tech Stack

| Layer        | Technology                     |
|--------------|--------------------------------|
| Frontend     | Flutter Web                    |
| Backend      | Spring Boot 4.0.2 (Java 21)   |
| Database     | PostgreSQL                     |
| Auth         | Supabase Auth (JWT / ES256)    |
| API Docs     | OpenAPI 3.0 / Swagger UI       |
| API Testing  | Postman                        |

## Modules

- **Authentication & Security** — Supabase JWT verification, role-based access control (Admin, Leader, Member)
- **Member Management** — Full CRUD with paginated search
- **Events & Attendance** — Event scheduling, RSVP, attendance tracking
- **Announcements** — Admin-only posting, public feed
- **Reporting & Dashboard** — Member totals, upcoming events, weekly attendance summary

## Getting Started

### Prerequisites

- Java 21
- PostgreSQL
- Maven
- A Supabase project (for authentication)

### Backend Setup

1. Clone the repository:
   ```bash
   git clone https://github.com/NdanaDev/Church-cms.git
   cd Church-cms/chruch-cms
   ```

2. Create a PostgreSQL database:
   ```sql
   CREATE DATABASE church_cms;
   ```

3. Copy the example environment config and update with your credentials:
   ```bash
   cp src/main/resources/application.yml.example src/main/resources/application.yml
   ```

   Update the following in `application.yml`:
   - `spring.datasource.url` — your PostgreSQL connection URL
   - `spring.datasource.username` — your database username
   - `spring.datasource.password` — your database password
   - `spring.security.oauth2.resourceserver.jwt.jwk-set-uri` — your Supabase JWKS URL

4. Run the application:
   ```bash
   ./mvnw spring-boot:run
   ```

5. The API will be available at `http://localhost:8081`

### Swagger UI

Once the backend is running, visit:
```
http://localhost:8081/swagger-ui/index.html
```

## API Endpoints

### Auth
| Method | Endpoint       | Access  | Description            |
|--------|----------------|---------|------------------------|
| GET    | `/api/health`  | Public  | Health check           |
| GET    | `/api/me`      | Auth    | Current user info      |

### Members
| Method | Endpoint               | Access  | Description                  |
|--------|------------------------|---------|------------------------------|
| GET    | `/api/members`         | Auth    | List members (paginated)     |
| POST   | `/api/members`         | Auth    | Create a member              |
| GET    | `/api/members/{id}`    | Auth    | Get member by ID             |
| PUT    | `/api/members/{id}`    | Auth    | Update a member              |
| DELETE | `/api/members/{id}`    | Auth    | Delete a member              |

## Project Structure

```
chruch-cms/src/main/java/com/ephraim/chruch_cms/
├── config/          # Security configuration
├── controller/      # REST controllers
├── dto/             # Request/response DTOs
├── exception/       # Global exception handling
├── model/           # JPA entities and enums
├── repository/      # Spring Data JPA repositories
└── service/         # Business logic
```

## Role-Based Access Control

| Role   | Permissions                              |
|--------|------------------------------------------|
| ADMIN  | Full access to all resources             |
| LEADER | Event and attendance management          |
| MEMBER | Read-only access to events/announcements |

