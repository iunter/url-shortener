# url-service

Spring Boot service for URL shortening. Schema changes are managed with Liquibase against PostgreSQL 18.6. Hibernate `ddl-auto` is `validate` only; it does not create or update tables.

## Local PostgreSQL

From this directory:

```bash
docker compose up -d
```

That starts `postgres:18.6` on `localhost:5432` with:

| Setting  | Value         |
|----------|---------------|
| Database | `url_service` |
| User     | `url_service` |
| Password | `url_service` |

Override Spring datasource settings with `SPRING_DATASOURCE_URL`, `SPRING_DATASOURCE_USERNAME`, and `SPRING_DATASOURCE_PASSWORD` if needed.

Maven Liquibase goals read the same defaults from `liquibase.properties`.

## Changelog layout

- `src/main/resources/db/changelog/db.changelog-master.xml` — master changelog included at runtime
- `src/main/resources/db/changelog/changeset.xml` — change sets applied to the database (updated by `liquibase:diff`)

The app applies the master changelog on startup.

## Run migrations

Make sure PostgreSQL is running, then either start the service:

```bash
./mvnw spring-boot:run
```

On Windows: `.\mvnw.cmd spring-boot:run`

Or apply change sets with Maven (does not start the app):

```bash
./mvnw liquibase:update
```

Useful checks:

```bash
./mvnw liquibase:status
./mvnw liquibase:history
```

## Update `changeset.xml` with a Hibernate diff

1. Add or change JPA entities under `com.iunter.url_shortener.url_service`.
2. Start PostgreSQL so Liquibase can compare the current schema.
3. Compile, then generate the diff into `changeset.xml`:

```bash
./mvnw compile liquibase:diff
```

Liquibase 4.31 has no `diffChangeLog` Maven goal. `liquibase:diff` writes change sets when `diffChangeLogFile` is set (see `liquibase.properties` and the plugin config). It **appends** to `src/main/resources/db/changelog/changeset.xml`. Review that file, then apply:

```bash
./mvnw liquibase:update
```

To print a comparison report instead of writing the file:

```bash
./mvnw compile liquibase:diff -Dliquibase.diffChangeLogFile=
```

`compile` is required so Hibernate can see the latest entity classes.

From the repository root:

```bash
mvn -pl :url-service compile liquibase:diff
mvn -pl :url-service liquibase:update
```
