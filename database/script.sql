DROP DATABASE if_exists CMS_db;
CREATE DATABASE CMS_db;
USE CMS_db;
CREATE TABLE users(
	user_id INT NOT NULL AUTO_INCREMENT,
	username VARCHAR(30) NOT NULL,
	email VARCHAR(255) NOT NULL,
	password_hash VARCHAR(255) NOT NULL,
	bio TEXT ,
	profile_picture_url VARCHAR(255),
	PRIMARY KEY (user_id)
);
CREATE TABLE categories(
	category_id int NOT null AUTO_INCREMENT,
    nom_category varchar(30),
    PRIMARY KEY(category_id)
);
CREATE Table tags(
    tag_id INT NOT null AUTO_INCREMENT,
    name varchar(50),
    PRIMARY KEY(tag_id)
);
CREATE TABLE articles(
	article_id int NOT NULL AUTO_INCREMENT PRIMARY KEY,
	title VARCHAR(255) NOT NULL,
	slug VARCHAR(255) NOT NULL,
	content TEXT NOT NULL,
	excerpt TEXT ,
	meta_description VARCHAR(160) ,
	category_id INT NOT NULL,
	featured_image VARCHAR(255),
	status ENUM("published","draft","complete"),
	schelduled_date DATETIME,
    user_id INT NOT NULL,
    created_at DATETIME,
    update_at DATETIME,
    views INT,
    Foreign Key (category_id) REFERENCES categories(category_id) on DELETE CASCADE on update CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(user_id) on DELETE CASCADE on update CASCADE
);
CREATE TABLE articles_tags(
	 article_id int,
    tag_id int,
    PRIMARY KEY(article_id, tag_id),
    FOREIGN KEY(article_id) REFERENCES articles(article_id) on DELETE CASCADE on update CASCADE,
    FOREIGN KEY(tag_id) REFERENCES tags(tag_id) on DELETE CASCADE on update CASCADE
);
