
-- Fetch all content in Hindi
SELECT ct.title , ct.body , l.language_name , c.content_id 
FROM content_translations  ct 
JOIN languages l 
ON ct.language_id = l.language_id 
JOIN content_versions cv 
ON ct.version_id = cv.version_id
JOIN content c 
ON cv.content_id = c.content_id 
WHERE l.language_code = 'hi';


-- Fetch content by category

SELECT c.content_id , ct.title , cat.category_name 
FROM content c 
JOIN categories cat 
ON c.category_id = cat.category_id 
JOIN content_versions cv 
ON cv.content_id = c.content_id 
JOIN content_translations ct 
ON ct.version_id = cv.version_id 
WHERE cat.category_name = 'Tutorials';


-- Query 3: Fetch content by status
SELECT ct.title , s.status_name 
FROM content c 
JOIN statuses s
ON c.status_id = s.status_id 
JOIN content_versions cv 
ON cv.content_id = c.content_id 
JOIN content_translations ct 
ON ct.version_id = cv.version_id 
WHERE s.status_name = 'published';


 -- Fetch content by author 
SELECT ct.title , u.username 
FROM content c
JOIN users u 
ON c.author_id = u.user_id
JOIN content_versions cv 
ON cv.content_id = c.content_id 
JOIN content_translations ct ON ct.version_id = cv.version_id 
WHERE u.username = 'kshitij.dev';

-- View version history of a content item 
SELECT c.content_id, cv.version_number, u.username AS updated_by, cv.updated_at
FROM content_versions cv
JOIN content c ON cv.content_id = c.content_id
JOIN users u ON cv.updated_by = u.user_id
WHERE c.content_id = 1
ORDER BY cv.version_number;

-- Get the latest version of each content item in a given language
-- (e.g., English)

SELECT 
  c.content_id,
  ct.title,
  ct.body,
  l.language_name,
  cv.version_number,
  cv.updated_at
FROM content_versions cv
JOIN (
    SELECT content_id, MAX(version_number) AS latest_version
    FROM content_versions
    GROUP BY content_id
) latest ON cv.content_id = latest.content_id AND cv.version_number = latest.latest_version
JOIN content_translations ct ON ct.version_id = cv.version_id
JOIN languages l ON ct.language_id = l.language_id
JOIN content c ON cv.content_id = c.content_id
WHERE l.language_code = 'en';


-- Show All Translation Suggestions (Recent First)
SELECT * FROM content_translations WHERE language_id = 2;

SELECT 
  ts.suggestion_id,
  ts.version_id,
  l.language_name,
  ts.suggested_title,
  u.username AS suggested_by,
  ts.suggested_at
FROM translation_suggestions ts
JOIN users u ON ts.suggested_by = u.user_id
JOIN languages l ON ts.language_id = l.language_id
ORDER BY ts.suggested_at DESC;


-- Show All Suggestions Grouped by Language
SELECT 
  l.language_name,
  COUNT(*) AS total_suggestions
FROM translation_suggestions ts
JOIN languages l ON ts.language_id = l.language_id
GROUP BY ts.language_id
ORDER BY total_suggestions DESC;


-- Get All Suggestions Made by a Specific User

SELECT 
  ts.suggestion_id,
  ts.version_id,
  l.language_code,
  ts.suggested_title,
  ts.suggested_body
FROM translation_suggestions ts
JOIN languages l ON ts.language_id = l.language_id
WHERE ts.suggested_by = 2;

-- Find Versions That Have Suggestions But No Official Translation Yet
SELECT 
  ts.version_id,
  l.language_name,
  ts.suggested_title
FROM translation_suggestions ts
LEFT JOIN content_translations ct 
  ON ct.version_id = ts.version_id AND ct.language_id = ts.language_id
JOIN languages l ON ts.language_id = l.language_id
WHERE ct.translation_id IS NULL;

