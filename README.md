#  Multi-language Content Manager (MySQL-only)

##  Project Overview

This project implements a robust, fully normalized MySQL schema for a **Multi-language Content Management System**, featuring version control, multi-language support, content audit trails, and category hierarchy — all entirely managed through SQL. The database is designed for scalability, data integrity, and real-world editorial use cases in multilingual environments.

Built using **MySQL 8.0**, the schema supports key editorial features like draft/published/archive status tracking, audit timestamps, full-text multilingual content search, and user-suggested translations.

>  _No frontend or backend — this is a data-first, schema-centric CMS core._

---

##  Database Architecture

### 1. `languages`
Stores metadata for supported languages using ISO-style codes.

| Field         | Type         | Notes                            |
|---------------|--------------|----------------------------------|
| language_id   | INT PK       | Auto-incremented ID              |
| language_code | VARCHAR(10)  | Unique (e.g., 'en', 'hi')        |
| language_name | VARCHAR(50)  | Display name                     |

---

### 2. `users`
Captures authors, editors, and contributors.

| Field      | Type         | Notes                       |
|------------|--------------|-----------------------------|
| user_id    | INT PK       | Auto-incremented ID         |
| username   | VARCHAR(50)  | Must be unique              |
| email      | VARCHAR(100) | Must be unique              |
| created_at | DATETIME     | Auto-set on insert          |

---

### 3. `statuses`
Tracks content lifecycle state.

| status_id   | INT PK     | Auto-incremented         |
|-------------|------------|--------------------------|
| status_name | VARCHAR(20)| 'draft', 'published', etc|

---

### 4. `categories`
Hierarchical structure to categorize content (supports parent-child nesting).

| Field              | Type   | Notes                             |
|--------------------|--------|-----------------------------------|
| category_id        | INT PK |                                   |
| category_name      | VARCHAR(100) | Required                  |
| parent_category_id | INT FK | Nullable — points to self         |

---

### 5. `content`
Core content item. Each content is abstract — actual text lives in translations.

| Field      | Type       | Notes                          |
|------------|------------|--------------------------------|
| content_id | INT PK     |                                |
| category_id| INT FK     |                                |
| status_id  | INT FK     |                                |
| author_id  | INT FK     | Creator reference              |
| is_deleted | BOOLEAN    | Soft delete support            |
| created_at | DATETIME   |                                |
| updated_at | DATETIME   |                                |

---

### 6. `content_versions`
Tracks edits to each content. A single content can have many versions.

| version_id     | INT PK     |                                |
|----------------|------------|--------------------------------|
| content_id     | INT FK     |                                |
| version_number | INT        | Unique per content             |
| updated_by     | INT FK     | Editor                         |
| updated_at     | DATETIME   |                                |

---

### 7. `content_translations`
Holds translated titles and bodies for each version of content.

| Field         | Type         | Notes                            |
|---------------|--------------|----------------------------------|
| translation_id| INT PK       |                                  |
| version_id    | INT FK       | Links to a specific version      |
| language_id   | INT FK       | One translation per lang/version|
| title         | VARCHAR(200) |                                  |
| body          | TEXT         |                                  |
| translated_at | DATETIME     | Auto-populated                   |

---

### 8. `translation_suggestions`     [ _Bonus Feature_ ]
Tracks user-submitted suggestions for new translations.

| suggestion_id   | INT PK     |
|------------------|-----------|
| version_id       | INT FK    |
| language_id      | INT FK    |
| suggested_title  | VARCHAR   |
| suggested_body   | TEXT      |
| suggested_by     | INT FK    |
| suggested_at     | DATETIME  |

---

##  Supported Languages

- English (`en`)
- Hindi (`hi`)
- Marathi (`mr`)
- Bengali (`bn`)
- Tamil (`ta`)
- Telugu (`te`)
- French (`fr`)

---

##  Sample Data Highlights

- 3+ authors with unique content pieces
- Each content has 1–2 versions
- Localized translations for each version (5–7 languages)
- Translation suggestions added to simulate community feedback

---

## Core SQL Queries (with Comments)

Included in `queries.sql`:
- Fetch content filtered by category, status, language, and author
- Retrieve latest version per content in a given language
- View version history with editor and timestamp
- Show content in Hindi using views
- Run full-text search on multilingual content
- List and analyze translation suggestions
- Group suggestions by language and contributor

_All queries return real data using sample inserts_

---

##  Deliverables

### ✔ `schema.sql`
- DDL for all 8 tables
- Foreign keys, primary keys, indexes
- Inline commentary

### ✔ `sample_data.sql`
- Language, user, content inserts
- Multilingual translations
- Suggestions for bonus features

### ✔ `queries.sql`
- All retrieval queries
- Bonus query block for features like suggestions and full-text

### ✔ `README.md`
- This file — outlining design, usage, and coverage

---

## How to Use This Project

1. `CREATE DATABASE multilingual_cms;`
2. Run `schema.sql` to build structure.
3. Run `sample_data.sql` to populate data.
4. Run individual queries in `queries.sql` or explore the schema manually.

 _Targeted for MySQL 8.0 or later._

---

##  Bonus Features Implemented

-  Hierarchical categories (`parent_category_id`)
-  Soft-deletes via `is_deleted`
-  Translation suggestions (editable pool of proposed translations)
-  Full-text search (`MATCH ... AGAINST(...)`) on `title` + `body`
-  Custom views like `latest_hindi_published`

---

##  Author Notes 

> This was a project that required analytical as well as creative thinking on my part as I found the problem statement unique in the vast amounts of SQL related projects out there. I was happy to go through the procedural thinking that was required while building this project.

---


