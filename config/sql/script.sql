-- Active: 1676217837382@@127.0.0.1@3306@devblog_db
-- Create the database
DROP DATABASE IF EXISTS devblog_db;
CREATE DATABASE devblog_db;

-- Connect to the database
USE devblog_db;

-- Create table for categories
CREATE TABLE categories (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    name TEXT NOT NULL
);

-- Create table for users
CREATE TABLE users (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(20) NOT NULL UNIQUE,
    email VARCHAR(255) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    bio TEXT,
    profile_picture_url VARCHAR(255)
);

-- Create table for articles

CREATE TABLE articles (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(255) NOT NULL,
    slug VARCHAR(255) NOT NULL,
    content TEXT NOT NULL,
    excerpt TEXT,
    meta_description VARCHAR(160),
    category_id BIGINT NOT NULL,
    featured_image VARCHAR(255),
    status ENUM('draft', 'published', 'scheduled') NOT NULL DEFAULT 'draft',
    scheduled_date DATETIME NULL,
    author_id BIGINT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    views INTEGER DEFAULT 0,
    UNIQUE KEY idx_articles_slug (slug),
    KEY idx_articles_category (category_id),
    KEY idx_articles_author (author_id),
    KEY idx_articles_status_date (status, scheduled_date),
    CONSTRAINT fk_articles_category FOREIGN KEY (category_id) 
        REFERENCES categories (id),
    CONSTRAINT fk_articles_author FOREIGN KEY (author_id) 
        REFERENCES users (id),
    CONSTRAINT chk_scheduled_date CHECK (
        (status != 'scheduled') OR 
        (status = 'scheduled' AND scheduled_date IS NOT NULL)
    )
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- Create table for tags
CREATE TABLE tags (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL UNIQUE
);

-- Create table for article_tags to handle many-to-many relationship
CREATE TABLE article_tags (
    article_id BIGINT,
    tag_id BIGINT,
    PRIMARY KEY (article_id, tag_id),
    FOREIGN KEY (article_id) REFERENCES articles(id) ON DELETE CASCADE,
    FOREIGN KEY (tag_id) REFERENCES tags(id) ON DELETE CASCADE
);

-- Insert Categories
-- Insert Categories
INSERT INTO categories (id, name) VALUES
(1, 'Web Development'),
(2, 'Mobile Development'),
(3, 'DevOps'),
(4, 'Data Science'),
(5, 'Artificial Intelligence');

-- Insert Users
INSERT INTO users (id, username, email, password_hash, bio, profile_picture_url) VALUES
(5, 'john_doe', 'john@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Senior Web Developer with 10 years of experience', 'profiles/john.jpg'),
(6, 'jane_smith', 'jane@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Full Stack Developer and AI enthusiast', 'profiles/jane.jpg'),
(7, 'michelle_wilson', 'michelle@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'DevOps Engineer and Cloud Architect', 'profiles/mike.jpg');

-- Insert Articles
INSERT INTO articles (
    title, 
    slug, 
    content, 
    excerpt, 
    meta_description, 
    category_id, 
    featured_image, 
    status, 
    scheduled_date, 
    author_id
) VALUES
(
    'Getting Started with React Hooks',
    'getting-started-with-react-hooks',
    'React Hooks are a powerful feature that allows you to use state and other React features without writing a class component...',
    'Learn how to use React Hooks in your applications',
    'A comprehensive guide to React Hooks for beginners',
    1, -- category_id for Web Development
    'images/react-hooks.jpg',
    'published',
    NULL,
    1  -- author_id for john_doe
),
(
    'Docker Container Basics',
    'docker-container-basics',
    'Docker containers provide a way to package applications with all their dependencies...',
    'Understanding Docker containers and their benefits',
    'Learn Docker container basics and best practices',
    3, -- category_id for DevOps
    'images/docker-basics.jpg',
    'published',
    NULL,
    3  -- author_id for mike_wilson
);

-- Insert Article Tags (after articles are inserted)
INSERT INTO article_tags (article_id, tag_id)
SELECT a.id, t.id
FROM articles a, tags t
WHERE a.slug = 'getting-started-with-react-hooks'
AND t.name IN ('JavaScript', 'React', 'Web Development');

INSERT INTO article_tags (article_id, tag_id)
SELECT a.id, t.id
FROM articles a, tags t
WHERE a.slug = 'docker-container-basics'
AND t.name IN ('Docker', 'DevOps');

-- Insert Tags
INSERT INTO tags (id, name) VALUES
(1, 'JavaScript'),
(2, 'React'),
(3, 'Docker'),
(4, 'Machine Learning'),
(5, 'Web Development'),
(6, 'DevOps'),
(7, 'Python'),
(8, 'AI');

-- Insert Article Tags
INSERT INTO article_tags (article_id, tag_id) VALUES
(1, 1), -- React Hooks article - JavaScript
(1, 2), -- React Hooks article - React
(1, 5), -- React Hooks article - Web Development
(2, 3), -- Docker article - Docker
(2, 6), -- Docker article - DevOps
(3, 4), -- ML article - Machine Learning
(3, 8), -- ML article - AI
(4, 1), -- JavaScript article - JavaScript
(4, 5); -- JavaScript article - Web Development

-- Test Queries

-- 1. Get all published articles with their authors
SELECT 
    a.title,
    a.slug,
    a.excerpt,
    u.username as author,
    c.name as category
FROM articles a
JOIN users u ON a.author_id = u.id
JOIN categories c ON a.category_id = c.id
WHERE a.status = 'published'
ORDER BY a.created_at DESC;

-- 2. Get all articles with their tags
SELECT 
    a.title,
    GROUP_CONCAT(t.name) as tags
FROM articles a
LEFT JOIN article_tags at ON a.id = at.article_id
LEFT JOIN tags t ON at.tag_id = t.id
GROUP BY a.id;

-- 3. Get scheduled articles
SELECT 
    title,
    scheduled_date,
    u.username as author
FROM articles a
JOIN users u ON a.author_id = u.id
WHERE status = 'scheduled'
ORDER BY scheduled_date;

-- 4. Get articles by category with author and view count
SELECT 
    c.name as category,
    a.title,
    u.username as author,
    a.views
FROM articles a
JOIN categories c ON a.category_id = c.id
JOIN users u ON a.author_id = u.id
ORDER BY c.name, a.views DESC;

-- 5. Get top authors by article count
SELECT 
    u.username,
    COUNT(a.id) as article_count
FROM users u
LEFT JOIN articles a ON u.id = a.author_id
GROUP BY u.id
ORDER BY article_count DESC;

-- First, drop tables in correct order (if they exist)
DROP TABLE IF EXISTS article_tags;
DROP TABLE IF EXISTS articles;
DROP TABLE IF EXISTS tags;
DROP TABLE IF EXISTS categories;
DROP TABLE IF EXISTS users;

-- Create users table first (since it's referenced by articles)
CREATE TABLE users (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(20) NOT NULL UNIQUE,
    email VARCHAR(255) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    bio TEXT,
    profile_picture_url VARCHAR(255)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Create categories table
CREATE TABLE categories (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    name TEXT NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Create articles table with proper foreign keys
CREATE TABLE articles (
    id BIGINT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(255) NOT NULL,
    slug VARCHAR(255) NOT NULL,
    content TEXT NOT NULL,
    excerpt TEXT,
    meta_description VARCHAR(160),
    category_id BIGINT NOT NULL,
    featured_image VARCHAR(255),
    status ENUM('draft', 'published', 'scheduled') NOT NULL DEFAULT 'draft',
    scheduled_date DATETIME NULL,
    author_id BIGINT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    views INTEGER DEFAULT 0,
    UNIQUE KEY idx_articles_slug (slug),
    KEY idx_articles_category (category_id),
    KEY idx_articles_author (author_id),
    KEY idx_articles_status_date (status, scheduled_date),
    CONSTRAINT fk_articles_category FOREIGN KEY (category_id) 
        REFERENCES categories (id),
    CONSTRAINT fk_articles_author FOREIGN KEY (author_id) 
        REFERENCES users (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Create tags table
CREATE TABLE tags (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL UNIQUE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Create article_tags table
CREATE TABLE article_tags (
    article_id BIGINT UNSIGNED,
    tag_id BIGINT,
    PRIMARY KEY (article_id, tag_id),
    CONSTRAINT fk_article_tags_article FOREIGN KEY (article_id) 
        REFERENCES articles (id) ON DELETE CASCADE,
    CONSTRAINT fk_article_tags_tag FOREIGN KEY (tag_id) 
        REFERENCES tags (id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Now insert data in the correct order

-- 1. First, insert users
INSERT INTO users (username, email, password_hash, bio, profile_picture_url) VALUES
('john_doe', 'john@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Senior Web Developer with 10 years of experience', 'profiles/john.jpg'),
('jane_smith', 'jane@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Full Stack Developer and AI enthusiast', 'profiles/jane.jpg'),
('mike_wilson', 'mike@example.com', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'DevOps Engineer and Cloud Architect', 'profiles/mike.jpg');

-- 2. Then insert categories
INSERT INTO categories (name) VALUES
('Web Development'),
('Mobile Development'),
('DevOps'),
('Data Science'),
('Artificial Intelligence');

-- 3. Then insert tags
INSERT INTO tags (name) VALUES
('JavaScript'),
('React'),
('Docker'),
('Machine Learning'),
('Web Development'),
('DevOps'),
('Python'),
('AI');

-- 4. Then insert articles (using SELECT to get the correct IDs)
INSERT INTO articles (
    title, 
    slug, 
    content, 
    excerpt, 
    meta_description, 
    category_id, 
    featured_image, 
    status, 
    scheduled_date, 
    author_id
) 
SELECT 
    'Getting Started with React Hooks',
    'getting-started-with-react-hooks',
    'React Hooks are a powerful feature that allows you to use state and other React features without writing a class component...',
    'Learn how to use React Hooks in your applications',
    'A comprehensive guide to React Hooks for beginners',
    c.id,
    'images/react-hooks.jpg',
    'published',
    NULL,
    u.id
FROM categories c, users u
WHERE c.name = 'Web Development' 
AND u.username = 'john_doe';

-- 5. Finally, insert article tags
INSERT INTO article_tags (article_id, tag_id)
SELECT a.id, t.id
FROM articles a, tags t
WHERE a.slug = 'getting-started-with-react-hooks'
AND t.name IN ('JavaScript', 'React', 'Web Development');

-- Verify the data
SELECT 
    a.title,
    u.username as author,
    c.name as category,
    GROUP_CONCAT(t.name) as tags
FROM articles a
JOIN users u ON a.author_id = u.id
JOIN categories c ON a.category_id = c.id
LEFT JOIN article_tags at ON a.id = at.article_id
LEFT JOIN tags t ON at.tag_id = t.id
GROUP BY a.id;
