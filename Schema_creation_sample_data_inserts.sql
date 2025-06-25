CREATE DATABASE multilingual_cms;
USE multilingual_cms;

CREATE TABLE languages (
language_id INT AUTO_INCREMENT PRIMARY KEY,
language_code VARCHAR(10) NOT NULL UNIQUE,
language_name VARCHAR(50) NOT NULL

);


CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE statuses (
    status_id INT AUTO_INCREMENT PRIMARY KEY,
    status_name VARCHAR(20) NOT NULL UNIQUE       
);


CREATE TABLE categories (
category_id INT AUTO_INCREMENT PRIMARY KEY,
category_name VARCHAR(100) NOT NULL ,
parent_category_id INT ,
FOREIGN KEY (parent_category_id) REFERENCES categories(category_id)
);


-- Insert into languages
INSERT INTO languages (language_code, language_name) VALUES
('en', 'English'),
('hi', 'Hindi'),
('fr', 'French');

-- Insert into users
INSERT INTO users (username, email) VALUES
('kshitij.dev', 'kshitij@example.com'),
('alex_writer', 'alex@example.com'),
('mira_editor', 'mira@example.com');

-- Insert into statuses
INSERT INTO statuses (status_name) VALUES
('draft'),
('published'),
('archived');

-- Insert into categories
INSERT INTO categories (category_name, parent_category_id) VALUES
('Technology', NULL),
('Tutorials', NULL),
('Cybersecurity', 1),  -- Subcategory under Technology
('SQL', 2),            -- Subcategory under Tutorials
('Updates', NULL);


CREATE TABLE content(
content_id INT AUTO_INCREMENT PRIMARY KEY ,
category_id INT NOT NULL ,
status_id INT NOT NULL,
author_id INT NOT NULL,
created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
FOREIGN KEY (category_id) REFERENCES categories(category_id),
FOREIGN KEY (status_id) REFERENCES statuses(status_id),
FOREIGN KEY (author_id) REFERENCES users(user_id)

);

CREATE TABLE content_versions (
version_id INT AUTO_INCREMENT PRIMARY KEY,
content_id INT NOT NULL,
version_number INT NOT NULL, -- successive updates 
updated_by INT NOT NULL , -- user_id ofthe editor 
updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
FOREIGN KEY (content_id) REFERENCES content(content_id),
FOREIGN KEY (updated_by) REFERENCES users(user_id),
UNIQUE (content_id , version_number) -- to prevent duplicate version number for same content  

);

CREATE TABLE content_translations (
    translation_id INT AUTO_INCREMENT PRIMARY KEY,
    version_id INT NOT NULL,
    language_id INT NOT NULL,
    title VARCHAR(200) NOT NULL,
    body TEXT NOT NULL,
    translated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (version_id) REFERENCES content_versions(version_id),
    FOREIGN KEY (language_id) REFERENCES languages(language_id),
    UNIQUE (version_id, language_id) -- ensures one translation per language per version
);

INSERT INTO content (category_id, status_id, author_id)
VALUES
(1, 2, 1),   -- Tech post by kshitij.dev (published)
(2, 1, 2),   -- Tutorial draft by alex_writer
(3, 3, 3);   -- Cybersecurity post archived by mira_editor


INSERT INTO content_versions (content_id, version_number, updated_by)
VALUES
(1, 1, 1),
(2, 1, 2),
(3, 1, 3),
(1, 2, 3);  -- a second version of the first content, updated by mira_editor

INSERT INTO content_translations (version_id, language_id, title, body)
VALUES
-- Version 1 of Content 1
(1, 1, 'How to Secure Your Web App', 'Learn the basics of securing web applications.'),
(1, 2, 'अपना वेब ऐप सुरक्षित कैसे करें', 'वेब एप्लिकेशन को सुरक्षित करने की बुनियादी बातें जानें।'),

-- Version 2 of Content 1
(4, 1, 'Web App Security 101', 'We’ve expanded with tips on HTTPS, headers, and more.'),
(4, 3, 'Sécurité Web : Introduction', 'Conseils sur HTTPS, en-têtes HTTP, et plus encore.'),

-- Version 1 of Content 2
(2, 1, 'Getting Started with SQL', 'An introductory tutorial on SQL basics.'),

-- Version 1 of Content 3
(3, 1, 'XSS Attack Demo', 'Real-time simulation of a cross-site scripting attack.');

